package com.example.anwender.empaticae4.Usermanagment;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.toolbox.Volley;
import com.example.anwender.empaticae4.R;

import org.json.JSONException;
import org.json.JSONObject;

public class LoginActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_activity);

        final EditText etEmail = (EditText) findViewById(R.id.etEmail1);
        final EditText etPassword = (EditText) findViewById(R.id.etPassword);
        final TextView tvRegisterLink = (TextView) findViewById(R.id.tvRegisterHere);
        final Button bLogin = (Button) findViewById(R.id.bLogin);

        tvRegisterLink.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent registerIntent = new Intent(LoginActivity.this, RegisterActivity.class);
                LoginActivity.this.startActivity(registerIntent);
            }
        });
        bLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String email = etEmail.getText().toString();
                final String password = etPassword.getText().toString();

                // Response received from the server
                Response.Listener<String> responseListener = new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            boolean success = jsonResponse.getBoolean("success");

                            if (success) {
                                Log.i("Login", "success");
                                final String id = jsonResponse.getString("id");

                                new AlertDialog.Builder(LoginActivity.this)
                                        .setTitle("Terms of use")
                                        .setMessage(LoginActivity.this.getString(R.string.about))
                                        .setPositiveButton("Accept", new DialogInterface.OnClickListener() {
                                            public void onClick(DialogInterface dialog, int which) {
                                                Log.d("LoginActivityLocal", "ToS accepted");
                                                //Upon accepting save the User ID and change the user login status and start the main activity
                                                SharedPreferences login_status = getSharedPreferences("Login_status", Context.MODE_PRIVATE);
                                                SharedPreferences.Editor editor = login_status.edit();
                                                editor.putBoolean("user_loggedIn", true);
                                                editor.putString("userID", id);
                                                editor.apply();

                                                final Intent MainActivity= new Intent(LoginActivity.this, com.example.anwender.empaticae4.Main.MainActivity.class);
                                                //MainActivity.putExtra("id", id);
                                                startActivity(MainActivity);
                                                finish();
                                            }
                                        })
                                        .setNegativeButton("Decline", new DialogInterface.OnClickListener() {
                                            public void onClick(DialogInterface dialog, int which) {
                                                Log.d("LoginActivityLocal", "ToS declined");
                                                //Without accepting the Activity will finish
                                                finish();
                                            }
                                        })
                                        //.setIcon(android.R.drawable.ic_dialog_alert)
                                        .show();

                            } else {
                                //Login was unsuccessful
                                Log.i("Login", "error");
                                AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this);
                                builder.setMessage("Login Failed")
                                        .setNegativeButton("Retry", null)
                                        .create()
                                        .show();
                            }

                        } catch (JSONException e) {

                            e.printStackTrace();
                        }
                    }
                };

                //Send sogin quest to the server
                LoginRequest loginRequest = new LoginRequest(email, password, responseListener);
                RequestQueue queue = Volley.newRequestQueue(LoginActivity.this);
                queue.add(loginRequest);
            }
        });
    }


}