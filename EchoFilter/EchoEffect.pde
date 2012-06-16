/*
 * File: EchoEffect.pde
 *
 * This file contains an implementation of an echo effect.
 * The echo effect uses two circular buffers, one for each channel.
 * In this buffer are already played samples stored.
 * When a new sample is processed the sample 'delayLength' samples
 * before this sample is combined with the to processed sample.
 *
 * Author: René Aparicio Saez
 * Student nr.: 10214054
 *
 * Author: Tom Peerdeman
 * Student nr.: 10266186
 *
 * Date: 16/06/2012
 *
 */

public class EchoEffect implements AudioEffect{
	private CircularBuffer bufLeft;
	private CircularBuffer bufRight;
	private int delayLength;
	private float echoVolume;
	private float nonEchoVolume;
	
	public EchoEffect(){
		// Initialize volume & delay
		setDelay(0.2f);
		setEchoVolume(0.3f);

		// Initialize buffers
		bufLeft =	new CircularBuffer(delayLength + 1);
		bufRight =	new CircularBuffer(delayLength + 1);
	}
	
	public void setDelay(float delay){
		delayLength = (int) (44100 * delay);
		if(bufLeft != null){
			// Clear required otherwise older data than we want is mixed in.
			bufLeft.clear();
			bufRight.clear();
		}
	}
	
	public void setEchoVolume(float vol){
		echoVolume = vol;
		nonEchoVolume = 1f - vol;
	}
	
	public void process(float[] samp){
		for(int i = 0; i < samp.length; i++){
			bufLeft.addSample(samp[i]);
			if(bufLeft.fill >= delayLength){
				// Buffer full enough, mix it
				samp[i] = samp[i] * nonEchoVolume;
				samp[i] += bufLeft.getSample() * echoVolume;
			}
		}
	}

	public void process(float[] left, float[] right){
		for(int i = 0; i < left.length; i++){
			bufLeft.addSample(left[i]);
			bufRight.addSample(right[i]);
			
			// Buffer full enough, mix it
			if(bufLeft.fill >= delayLength){
				left[i] = left[i] * nonEchoVolume;
				left[i] += bufLeft.getSample() * echoVolume;
				right[i] = right[i] * nonEchoVolume;
				right[i] += bufRight.getSample() * echoVolume;
			}
		}
	}
}
