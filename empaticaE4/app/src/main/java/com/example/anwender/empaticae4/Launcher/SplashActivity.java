package com.example.anwender.empaticae4.Launcher;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Usermanagment.LoginActivity;



public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SharedPreferences pref = null;

        try {
            pref = getSharedPreferences("Login_status", Context.MODE_PRIVATE);
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        //Todo this session management could be made better/more secure with something like OAuth tokens
        //if the value exists, skip the log in screen and jump to the MainActivity
        if (pref.getBoolean("user_loggedIn", false)) {
            Log.d("Splash Activity", "User is logged in");
            final Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
            finish();
        // if the shared preference does not exist the user is not logged in => send him to the loginAcitivty
        } else {
            Log.d("Splash Activity", "User is not logged in");

            /*
            // out-commented by Andreas Dejmek, as no login is available
                //final Intent intent = new Intent(this, LoginActivity.class);
            */
            final Intent intent = new Intent(this, MainActivity.class); //use MainActivity instead

            startActivity(intent);
            finish();

        }
    }
}
