package assignment2;

import android.graphics.Canvas;
import android.graphics.Color;
import uvamult.assignment2.R;
import android.hardware.Camera.Size;
import assignment2.android.CameraView;
import android.widget.SeekBar;

public class DrawCamera implements SeekBar.OnSeekBarChangeListener{
	public final double DEGTORAD = 180.0d / Math.PI;
	
	public Size imageSize;
	
	private int[] rgb;			// the array of integers
	private int[] rgbout;
	private double angle = Math.toRadians(90);
	private double sin = 1;
	private double cos = 0;
	
	public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser){
		angle = Math.toRadians(progress + 90);
		sin = Math.sin(angle);
		cos = Math.cos(angle);
	}
	
	public void onStartTrackingTouch(SeekBar seekBar){
	}
	
	public void onStopTrackingTouch(SeekBar seekBar){
	}
	
	public void imageReceived(byte[] data) {
		// Allocate the image as an array of integers if needed.
		// Then, decode the raw image data in YUV420SP format into a red-green-blue array (rgb array)
		int arraySize = imageSize.width*imageSize.height;
		if(rgb == null){
			rgb = new int[arraySize];
			rgbout = new int[arraySize];
		}
		decodeYUV420SP(rgb, data);

		double rx, ry, dx, dy;
		// Center
		double cx = (double) imageSize.width / 2.0d;
		double cy = (double) imageSize.height / 2.0d;
		
		for(int y = 0; y < imageSize.height; y++){
			dy = y - cy;
			for(int x = 0; x < imageSize.width; x++){
				dx = x - cx;
				
				rx = (dx * cos) + (dy * sin) + cx;
				ry = (-1 * dx * sin) + (dy * cos) + cy;
				
				rgbout[xyToIdx(x, y)] = interpolate(rx, ry, rgb);
			}
		}	
	}
	
	private int interpolate(double x, double y, int[] rgb){
		x = Math.round(x);
		y = Math.round(y);
		int idx = xyToIdx((int) x, (int) y);
		if(x < 0 || x > imageSize.width || y < 0 || y > imageSize.height || idx >= rgb.length || idx < 0){
			return 0;
		}
		return rgb[idx];
	}
	
	private int xyToIdx(int x, int y){
		return y * imageSize.width + x;
	}
	
	public void draw(Canvas c) {	
		int centrex = c.getWidth() - imageSize.width;
		c.drawColor(Color.GRAY);
		centrex = centrex / 2;
		c.translate(centrex,0);
		drawImage(c);
	}
	
	/*
	 * Setup your environment
	 */
	public void setup(CameraView view) {		
		SeekBar seekBar = (SeekBar) view.activity.findViewById(R.id.seekBar1);
		seekBar.setMax(360);
		seekBar.setOnSeekBarChangeListener(this);
	}
    
    private void drawImage(Canvas c) {
		c.drawBitmap(rgbout, 0, imageSize.width, 0f, 0f, imageSize.width, imageSize.height, true, null);
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
}
