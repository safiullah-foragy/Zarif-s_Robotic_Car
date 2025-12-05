package com.zarifscar.controller;

import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    private static final String BASE_URL = "http://192.168.4.1";
    
    private Switch modeSwitch;
    private Button btnForward, btnBackward, btnLeft, btnRight;
    private TextView tvStatus, tvTimer, tvTitle;
    private ImageView ivCar;
    private View manualControlPanel;
    
    private RequestQueue requestQueue;
    private Handler handler;
    private Handler commandHandler;
    private Runnable statusRunnable;
    private Runnable commandRunnable;
    
    private boolean isManualMode = false;
    private boolean isSendingCommand = false;
    private String currentCommand = "STOP";
    
    private ObjectAnimator carAnimator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Initialize views
        initViews();
        
        // Initialize request queue
        requestQueue = Volley.newRequestQueue(this);
        handler = new Handler(Looper.getMainLooper());
        commandHandler = new Handler(Looper.getMainLooper());
        
        // Setup listeners
        setupListeners();
        
        // Start status updates
        startStatusUpdates();
        
        // Start title animation
        startTitleAnimation();
    }
    
    private void initViews() {
        tvTitle = findViewById(R.id.tvTitle);
        modeSwitch = findViewById(R.id.modeSwitch);
        btnForward = findViewById(R.id.btnForward);
        btnBackward = findViewById(R.id.btnBackward);
        btnLeft = findViewById(R.id.btnLeft);
        btnRight = findViewById(R.id.btnRight);
        tvStatus = findViewById(R.id.tvStatus);
        tvTimer = findViewById(R.id.tvTimer);
        ivCar = findViewById(R.id.ivCar);
        manualControlPanel = findViewById(R.id.manualControlPanel);
        
        // Initially hide manual controls
        manualControlPanel.setVisibility(View.GONE);
        tvTimer.setVisibility(View.GONE);
    }
    
    private void setupListeners() {
        // Mode switch listener
        modeSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                switchToManualMode();
            } else {
                switchToAutoMode();
            }
        });
        
        // Forward button - continuous while pressed
        btnForward.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("FORWARD");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Backward button - continuous while pressed
        btnBackward.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("BACKWARD");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Left button - continuous while pressed
        btnLeft.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("LEFT");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
        
        // Right button - continuous while pressed
        btnRight.setOnTouchListener((v, event) -> {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    startContinuousCommand("RIGHT");
                    v.setPressed(true);
                    return true;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    stopContinuousCommand();
                    v.setPressed(false);
                    return true;
            }
            return false;
        });
    }
    
    private void startTitleAnimation() {
        // Animate title with fade and scale
        ObjectAnimator fadeAnimator = ObjectAnimator.ofFloat(tvTitle, "alpha", 0.5f, 1.0f);
        fadeAnimator.setDuration(1500);
        fadeAnimator.setRepeatCount(ValueAnimator.INFINITE);
        fadeAnimator.setRepeatMode(ValueAnimator.REVERSE);
        fadeAnimator.start();
        
        // Animate car image rotation
        carAnimator = ObjectAnimator.ofFloat(ivCar, "rotation", -5f, 5f);
        carAnimator.setDuration(2000);
        carAnimator.setRepeatCount(ValueAnimator.INFINITE);
        carAnimator.setRepeatMode(ValueAnimator.REVERSE);
        carAnimator.start();
    }
    
    private void switchToManualMode() {
        String url = BASE_URL + "/mode";
        
        StringRequest request = new StringRequest(Request.Method.POST, url,
                response -> {
                    isManualMode = true;
                    manualControlPanel.setVisibility(View.VISIBLE);
                    tvTimer.setVisibility(View.VISIBLE);
                    tvStatus.setText("Mode: MANUAL");
                    Toast.makeText(this, "Manual mode activated", Toast.LENGTH_SHORT).show();
                },
                error -> {
                    modeSwitch.setChecked(false);
                    Toast.makeText(this, "Failed to switch mode", Toast.LENGTH_SHORT).show();
                }) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> params = new HashMap<>();
                params.put("mode", "MANUAL");
                return params;
            }
        };
        
        requestQueue.add(request);
    }
    
    private void switchToAutoMode() {
        String url = BASE_URL + "/mode";
        
        StringRequest request = new StringRequest(Request.Method.POST, url,
                response -> {
                    isManualMode = false;
                    manualControlPanel.setVisibility(View.GONE);
                    tvTimer.setVisibility(View.GONE);
                    tvStatus.setText("Mode: AUTO");
                    stopContinuousCommand();
                    Toast.makeText(this, "Auto mode activated", Toast.LENGTH_SHORT).show();
                },
                error -> {
                    modeSwitch.setChecked(true);
                    Toast.makeText(this, "Failed to switch mode", Toast.LENGTH_SHORT).show();
                }) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> params = new HashMap<>();
                params.put("mode", "AUTO");
                return params;
            }
        };
        
        requestQueue.add(request);
    }
    
    private void startContinuousCommand(String command) {
        currentCommand = command;
        isSendingCommand = true;
        
        commandRunnable = new Runnable() {
            @Override
            public void run() {
                if (isSendingCommand && isManualMode) {
                    sendCommand(currentCommand);
                    commandHandler.postDelayed(this, 50); // Send every 50ms
                }
            }
        };
        
        commandHandler.post(commandRunnable);
    }
    
    private void stopContinuousCommand() {
        isSendingCommand = false;
        if (commandRunnable != null) {
            commandHandler.removeCallbacks(commandRunnable);
        }
        sendCommand("STOP");
    }
    
    private void sendCommand(String command) {
        String url = BASE_URL + "/control";
        
        StringRequest request = new StringRequest(Request.Method.POST, url,
                response -> {
                    // Command sent successfully
                },
                error -> {
                    // Handle error silently for continuous commands
                }) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> params = new HashMap<>();
                params.put("command", command);
                return params;
            }
        };
        
        requestQueue.add(request);
    }
    
    private void startStatusUpdates() {
        statusRunnable = new Runnable() {
            @Override
            public void run() {
                updateStatus();
                handler.postDelayed(this, 1000); // Update every second
            }
        };
        
        handler.post(statusRunnable);
    }
    
    private void updateStatus() {
        String url = BASE_URL + "/status";
        
        StringRequest request = new StringRequest(Request.Method.GET, url,
                response -> {
                    try {
                        JSONObject json = new JSONObject(response);
                        String mode = json.getString("mode");
                        int timeout = json.getInt("timeout");
                        
                        if (mode.equals("AUTO") && isManualMode) {
                            // Server switched to auto mode (timeout)
                            runOnUiThread(() -> {
                                isManualMode = false;
                                modeSwitch.setChecked(false);
                                manualControlPanel.setVisibility(View.GONE);
                                tvTimer.setVisibility(View.GONE);
                                tvStatus.setText("Mode: AUTO (Timeout)");
                                Toast.makeText(MainActivity.this, 
                                    "Auto mode: 5 min timeout", Toast.LENGTH_LONG).show();
                            });
                        }
                        
                        if (isManualMode && timeout > 0) {
                            int minutes = timeout / 60;
                            int seconds = timeout % 60;
                            tvTimer.setText(String.format("Time remaining: %d:%02d", minutes, seconds));
                        }
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                },
                error -> {
                    tvStatus.setText("Status: Disconnected");
                });
        
        requestQueue.add(request);
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (handler != null && statusRunnable != null) {
            handler.removeCallbacks(statusRunnable);
        }
        if (commandHandler != null && commandRunnable != null) {
            commandHandler.removeCallbacks(commandRunnable);
        }
        if (carAnimator != null) {
            carAnimator.cancel();
        }
    }
}
