package assignment1;

import android.graphics.Canvas;
import uvamult.assignment1.R;
import android.graphics.Color;
import android.graphics.Paint;
import android.hardware.Camera.Size;
import assignment1.android.CameraView;
import android.widget.SeekBar;

public class DrawCamera implements SeekBar.OnSeekBarChangeListener{
	public Size imageSize;
	
	private int[] rgb;			// the array of integers
	private Paint p, black;
	private int binwidth = 256;
	private int avgGreenValue = 0;
	private int stdDev = 0;
	private int median = 0;
	private int[] bins;
	private int[] greenValuesCount;
	private int ymin, ymid1, ymid2, ymax;
	
	public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser){
		progress += 20;
		progress = (int) Math.pow(2, (int) (progress / 32));
		binwidth = 256 / progress;
	}
	
	public void onStartTrackingTouch(SeekBar seekBar){
	}
	
	public void onStopTrackingTouch(SeekBar seekBar){
	}
	
	public void imageReceived(byte[] data) {
		// Allocate the image as an array of integers if needed.
		// Then, decode the raw image data in YUV420SP format into a red-green-blue array (rgb array)
		// Note that per pixel the RGB values are packed into an integer. See the methods r(), g() and b().
		int arraySize = imageSize.width*imageSize.height;
		if(rgb == null)rgb = new int[arraySize];
		decodeYUV420SP(rgb, data);
		
		for(int i = 0; i < 256; i++){
			bins[i] = 0;
			greenValuesCount[i] = 0;
		}
		
		long total = 0;
		for(int i = 0; i < arraySize; i++){
			bins[g(rgb[i])/binwidth]++;
			greenValuesCount[g(rgb[i])]++;
			total += g(rgb[i]);
		}
		
		avgGreenValue = (int) ((double) total / (double) arraySize);
		
		total = 0;
		for(int i = 0; i < arraySize; i++){
			total += Math.pow((g(rgb[i]) - avgGreenValue), 2);
		}
		stdDev = (int) Math.sqrt((double) total / (double) arraySize);
		
		// Calculate frequency
		for(int i = 0; i < 256; i++){
			bins[i] = (int) ((double) bins[i] / (double) arraySize * 100.0d);
		}
		
		int pos = 0;
		for(int idx = 0; pos < arraySize / 2 - 1; idx++){
			pos += greenValuesCount[idx];
			median = idx;
		}
		
		if(pos == arraySize){
			median = (median * 2 + 1) / 2;
		}
		
	}
	
	public void draw(Canvas c) {
		int w = c.getWidth();
		int h = c.getHeight();
		
		// Calculate scaling and centre
		int centre = w % 256;	
		int scalex = w/256;
		
		// Calculate max y axis label and vertical scaling of the bins
		int barscale = 100;
		for(int i = 0; i < (256 / binwidth); i++){
			if(100.0d / (double) bins[i] < barscale){
				barscale = (int) Math.floor(100.0d / (double) bins[i]);
				ymax = bins[i];
			}
		}
		
		// Calculate other vertical axis labels 
		ymin = ymax / 4;
		ymid1 = ymin * 2;
		ymid2 = ymin * 3;

		c.drawColor(Color.GRAY);
		p.setColor(combine(255, 0, 0));
		black.setColor(combine(0,0,0));
		p.setTextSize(20);
		c.drawText("Avg. Green value = " + avgGreenValue, 22, 20, p);
		c.drawText("Standard Deviation = " + stdDev, 22, 40, p);
		c.drawText("Median value = " + median, centre+30, 20, p);
		c.drawText("Nbins = " + (256 / binwidth), centre+30, 40, p);
		
		// Translate coordinate system to a more convenient one
		c.translate((centre/2), (float) h-30f);
		
		// Draw axis labels
		p.setColor(combine(255, 0, 0));
		
		c.drawText("0", -5, 20, p);
		c.drawText("64", 57*scalex, 20, p);
		c.drawText("128", 120*scalex, 20, p);
		c.drawText("192", 182*scalex, 20, p);
		c.drawText("255", 245*scalex, 20, p);
		c.drawText("0", -29, 5, p);
		c.drawText("" + ymin, -40, -20, p);
		c.drawText("" + ymid1, -40, -45, p);
		c.drawText("" + ymid2, -40, -70, p);
		c.drawText("" + ymax, -40, -95, p);
		c.drawLine(0, 0, -7, 0, black);
		c.drawLine(0, -25, -7, -25, black);
		c.drawLine(0, -50, -7, -50, black);
		c.drawLine(0, -75, -7, -75, black);
		c.drawLine(0, -100, -7, -100, black);
		
		// Reverse y axis
		c.scale(1f, -1f);
		
		// Draw axis
		c.drawLine(0, 0, (256 * scalex) +1, 0, black);
		c.drawLine(0, 0, 0, 100, black);
		
		p.setColor(combine(0, 255, 0));
		
		// Draw bins
		int bw = binwidth * scalex;
		for(int i = 0, j = 0; i < 256 * scalex; i = i + bw, j++){
			if(bins[j] > 0){
				c.drawRect(i, bins[j] * barscale, i+bw, 0, p);
				c.drawLine(i, 0, i, bins[j] * barscale,black);
				c.drawLine(i, bins[j] * barscale, i+bw, bins[j] * barscale, black);
				c.drawLine(i+bw, 0, i+bw, bins[j] * barscale, black);
			}
		}
	}
	
	/*
	 * Setup your environment
	 */
	public void setup(CameraView view) {		
		SeekBar seekBar = (SeekBar) view.activity.findViewById(R.id.seekBar1);
		seekBar.setMax(255);
		seekBar.setOnSeekBarChangeListener(this);
	}
		
	/*
	 * Below are some convenience methods,
	 * like grabbing colors and decoding.
	 */
    
	// Extract the red element from the given color
    private int r(int rgb) {
    	return (rgb & 0xff0000) >> 16;
    }

	// Extract the green element from the given color
    private int g(int rgb) {
    	return (rgb & 0x00ff00) >> 8;
    }

	// Extract the blue element from the given color
    private int b(int rgb) {
    	return (rgb & 0x0000ff);
    }
    
    // Combine red, green and blue into a single color int
    private int combine(int r, int g, int b) {
    	 return 0xff000000 | (r << 16) | (g << 8) | b;
    }
    
    /*
     * Decode the incoming data (YUV format) to a red-green-blue format
     */
	private void decodeYUV420SP(int[] rgb, byte[] yuv420sp) {
		final int width = imageSize.width;
		final int height = imageSize.height;
    	final int frameSize = width * height;
    	
    	for (int j = 0, yp = 0; j < height; j++) {
    		int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    		for (int i = 0; i < width; i++, yp++) {
    			int y = (0xff & ((int) yuv420sp[yp])) - 16;
    			if (y < 0) y = 0;
    			if ((i & 1) == 0) {
    				v = (0xff & yuv420sp[uvp++]) - 128;
    				u = (0xff & yuv420sp[uvp++]) - 128;
    			}
    			
    			int y1192 = 1192 * y;
    			int r = (y1192 + 1634 * v);
    			int g = (y1192 - 833 * v - 400 * u);
    			int b = (y1192 + 2066 * u);
    			
    			if (r < 0) r = 0; else if (r > 262143) r = 262143;
    			if (g < 0) g = 0; else if (g > 262143) g = 262143;
    			if (b < 0) b = 0; else if (b > 262143) b = 262143;
    			
    			rgb[yp] = 0xff000000 | ((r << 6) & 0xff0000) | ((g >> 2) & 0xff00) | ((b >> 10) & 0xff);
    		}
    	}
    }

	public DrawCamera() {
		p = new Paint();
		black = new Paint();
		bins = new int[256];
		greenValuesCount = new int[256];
	}
}
