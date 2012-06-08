package assignment2.android;

import uvamult.assignment2.R;
import android.app.Activity;
import android.os.Bundle;

public class CameraActivity extends Activity {
    /** A handle to the View that handles camera stuff. */
    private CameraView mCameraView;
    
    
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.camera);
        
        // get handles to the CameraView from XML
        mCameraView = (CameraView) findViewById(R.id.camerafield);
        
        mCameraView.setActivity(this);
    }
}