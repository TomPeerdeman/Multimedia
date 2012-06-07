package assignment1;

import android.graphics.Canvas;
import uvamult.assignment1.R;
import android.graphics.Color;
import android.graphics.Paint;
import android.hardware.Camera.Size;
import android.util.Log;
import android.view.View;
import assignment1.android.CameraView;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;

public class DrawCamera implements SeekBar.OnSeekBarChangeListener{
	
	/*
	 * This class is the only file that needs changes to show
	 * the histogram of the green values.
	 */
	
	public int[] rgb;			// the array of integers
	public Size imageSize;
	public Paint p, black;
	
	private int binwidth = 256;
	private int avgGreenValue;
	private int stdDev;
	private int[] greenValues;
	private int[] bins;
	
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
			greenValues[i] = 0;
		}
		
		long total = 0;
		for(int i = 0; i < arraySize; i++){
			greenValues[g(rgb[i])]++;
			total += g(rgb[i]);
		}
		
		avgGreenValue = (int) ((double) total / (double) arraySize);
		
		total = 0;
		for(int i = 0; i < arraySize; i++){
			total += Math.pow((g(rgb[i]) - avgGreenValue), 2);
		}
		stdDev = (int) Math.sqrt((double) total / arraySize);
		
		for(int i = 0; i < 256; i++){	
			bins[i/binwidth] += greenValues[i];
		}
		
		// Calculate frequency
		for(int i = 0; i < 256; i++){
			bins[i] = (int) ((double) bins[i] / (double) arraySize * 100.0d);
		}
		
	}
	
	public void draw(Canvas c) {
		int w = c.getWidth();
		int h = c.getHeight();
		
		// here you should draw the histogram. The number of bins should be user selectable.
		// note that at this point the canvas origin is in the top left corner of the surface 
		// just below the preview window.
		
		// you could translate translate an reflect the coordinate system to make
		// into a standard coordinate system.
		
		// please not that the canvas height is larger then what can be seen on the screen. 
		// For hints/tips why that is the case..... please mail Rein vd Boomgaard
		
		// instead of drawing the histogram below we draw the origin, put some text in it
		// and draw a line.

		c.drawColor(Color.GRAY);
		p.setColor(combine(255, 0, 0));
		black.setColor(combine(0,0,0));
		c.drawText("Avg. Green value = " + avgGreenValue, 22, 12, p);
		c.drawText("Standard Deviation = " + stdDev, 22, 27, p);
		c.drawText("Median value = " + binwidth, 182, 12, p);
		c.drawText("Nbins = " + (256 / binwidth), 182, 27, p);
		c.translate(32f, 130f);
		c.scale(1f, -1f);
		c.drawLine(0, 0, w-64f, 0, black);
		c.drawLine(0, 0, 0, 90f, black);
		p.setColor(combine(0, 255, 0));
		
		int scale = 100;
		for(int i = 0; i < (256 / binwidth); i++){
			if(100.0d / (double) bins[i] < scale){
				scale = (int) Math.floor(100.0d / (double) bins[i]);
			}
		}
		
		for(int i = 0, j = 0; i < 256; i = i + binwidth, j++){
			if(bins[j] > 0){
				c.drawRect(i, bins[j] * scale, i+binwidth, 0, p);
				c.drawLine(i, 0, i, bins[j] * scale,black);
				c.drawLine(i, bins[j] * scale, i+binwidth, bins[j] * scale,black);
				c.drawLine(i+binwidth, 0, i+binwidth, bins[j] * scale,black);
			}
		}
		p.setColor(combine(255, 0, 0));
		c.scale(1f, -1f);
		c.drawText("0                  64                128               192              255", -5, 12, p);
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
		greenValues = new int[256];
		bins = new int[256];
	}
}
