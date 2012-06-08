package assignment2;

import android.graphics.Canvas;
import uvamult.assignment2.R;
import android.graphics.Color;
import android.graphics.Paint;
import android.hardware.Camera.Size;
import assignment2.android.CameraView;
import android.widget.SeekBar;

public class DrawCamera implements SeekBar.OnSeekBarChangeListener{
	public Size imageSize;
	
	private int[] rgb;			// the array of integers
	private Paint p;
	private int angle;

	
	public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser){
		angle = progress;
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
		
	}
	
	public void draw(Canvas c) {
		int w = c.getWidth();
		int h = c.getHeight();
		
		
	}
	
	/*
	 * Setup your environment
	 */
	public void setup(CameraView view) {		
		SeekBar seekBar = (SeekBar) view.activity.findViewById(R.id.seekBar1);
		seekBar.setMax(360);
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
	}
}
