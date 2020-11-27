package com.example.anwender.empaticae4.Usermanagment;


import com.android.volley.Response;
import com.android.volley.toolbox.StringRequest;

import java.util.HashMap;
import java.util.Map;

public class LoginRequest extends StringRequest {


   // private static final String LOGIN_REQUEST_URL = "http://192.168.0.220:80/emact/Login.php";
    private static final String LOGIN_REQUEST_URL = "https://ictsrv023.ict.tuwien.ac.at/Login.php";
    private Map<String, String> params;

    public LoginRequest(String email, String password, Response.Listener<String> listener) {
        super(Method.POST, LOGIN_REQUEST_URL, listener, null);
        params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);
    }

    @Override
    public Map<String, String> getParams() {
        return params;
    }
}