package com.example.anwender.empaticae4.Usermanagment;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Toast;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.toolbox.Volley;
import com.example.anwender.empaticae4.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Objects;

public class RegisterActivity extends AppCompatActivity {

    private int hand;// 1=right 2=left
    private boolean bEmail;
    private String dominantHand;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        final EditText etAge = (EditText) findViewById(R.id.etAge);
        final EditText etName = (EditText) findViewById(R.id.etName);
        final EditText etEmail = (EditText) findViewById(R.id.etEmail);
        final EditText etPassword = (EditText) findViewById(R.id.etPassword);
        final EditText etPasswordRepeat = (EditText) findViewById(R.id.etPasswordRepeat);
        final Button bRegister = (Button) findViewById(R.id.bRegister);

        bRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String name = etName.getText().toString();
                final String email = etEmail.getText().toString();
                final String password = etPassword.getText().toString();
                final String passwordRepeat = etPasswordRepeat.getText().toString();

                int age;
                if( etAge.getText().toString().isEmpty()){
                    age=0;
                } else{
                    age = Integer.parseInt( etAge.getText().toString());
                }

                //TODO Like in Tagemotion, tell the user what is missing
                if(name==null || email==null || password==null || passwordRepeat==null || (age>99 || age<18) || hand==0 ) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(RegisterActivity.this);
                    builder.setMessage("Incomplete Input")
                            .setNegativeButton("Retry", null)
                            .create()
                            .show();
                } else{
                    bEmail=isValidEmail(email);
                    if (bEmail && (hand == 1 || hand == 2) && Objects.equals(password, passwordRepeat)) {
                        if (hand == 1) {
                            dominantHand = "right";
                        } else {
                            dominantHand = "left";
                        }

                        Response.Listener<String> responseListener = new Response.Listener<String>() {
                            @Override
                            public void onResponse(String response) {
                                try {
                                    Log.i("response =", response);
                                    JSONObject jsonResponse = new JSONObject(response);
                                   // Log.i("crash happens here", "");
                                    boolean success = jsonResponse.getBoolean("success");

                                    if (success) {
                                        Toast.makeText(RegisterActivity.this, "Registration successful!", Toast.LENGTH_SHORT).show();
                                        Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
                                        startActivity(intent);
                                    } else {
                                        AlertDialog.Builder builder = new AlertDialog.Builder(RegisterActivity.this);
                                        builder.setMessage("Register Failed")
                                                .setNegativeButton("Retry", null)
                                                .create()
                                                .show();
                                    }

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        };

                        RegisterRequest registerRequest = new RegisterRequest(name, email, age, dominantHand, password, responseListener);
                        RequestQueue queue = Volley.newRequestQueue(RegisterActivity.this);
                        queue.add(registerRequest);
                    } else {
                        Toast.makeText(RegisterActivity.this, "Invalid Input", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

    }

    private final static boolean isValidEmail(CharSequence email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    public void onRadioButtonClicked(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();

        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.radioRight:
                if (checked)
                    hand=1;
                    break;
            case R.id.radioLeft:
                if (checked)
                    hand=2;

                    break;
        }
    }

}
