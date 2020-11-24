package com.example.anwender.empaticae4.Main;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.example.anwender.empaticae4.R;

public class AboutActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
    }

    @Override
    protected void onPause() {
        super.onPause();
        finish();
    }
}
