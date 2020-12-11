package com.example.anwender.empaticae4.Configuration;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.example.anwender.empaticae4.EWS.EWSScore;
import com.example.anwender.empaticae4.EWS.GraphHR;
import com.example.anwender.empaticae4.EWS.GraphRR;
import com.example.anwender.empaticae4.EWS.GraphSBP;
import com.example.anwender.empaticae4.EWS.GraphSPO2;
import com.example.anwender.empaticae4.EWS.GraphTemp;
import com.example.anwender.empaticae4.EWS.Historical;
import com.example.anwender.empaticae4.Main.Utility;
import com.example.anwender.empaticae4.R;

public class ConfigActivity extends AppCompatActivity {

    //classes
    private FragmentManager mFragManager;
    private NetworkManager mNetworkFragment;
    private MsgProcessor mMsgProcessor;
    private FabricManager mFabricManager;
    private Util mUtil;

    //layout
    private TextView mConsole;
    private TextView mServerIP;
    private Button mButtonConnect;
    private Button mButtonConfig;
    private RadioGroup radioGroupConfig;
    private RadioButton radioButtonSDFT;
    private RadioButton radioButtonHDFT;
    private RadioButton radioButtonHFFT;
    private RadioButton radioButtonCustomFFT;

    //filenames
    private String blake2bDriver;
    private String blake2bHash;
    private String reconfigDriver;

    private boolean download;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_configuration);

        //initialise Textviews
        mConsole = (TextView) findViewById(R.id.console);
        mConsole.setMovementMethod(new ScrollingMovementMethod());
        mServerIP = (TextView) findViewById(R.id.edit_serverIP);

        //initialise Buttons
        mButtonConnect = (Button) findViewById(R.id.button_connect);
        mButtonConfig = (Button) findViewById(R.id.button_config);

        //initialise RadioButtons
        radioGroupConfig = (RadioGroup) findViewById(R.id.radioGroup);
        radioButtonSDFT = (RadioButton) findViewById(R.id.radioButton_SDFT);
        radioButtonHDFT = (RadioButton) findViewById(R.id.radioButton_HDFT);
        radioButtonHFFT = (RadioButton) findViewById(R.id.radioButton_HFFT);
        radioButtonCustomFFT = (RadioButton) findViewById(R.id.radioButton_custom_FFT);
        radioButtonSDFT.setChecked(true); //default value

        //When RadioGroup "Configuration" checked change
        radioGroupConfig.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                doOnConfigChanged(group, checkedId);
            }
        });

        //Initialise classes
        mNetworkFragment = new NetworkManager();
        mMsgProcessor = new MsgProcessor(this);
        mFabricManager = new FabricManager(this);
        mUtil = new Util(this);
        mFragManager = getSupportFragmentManager();
        mFragManager.beginTransaction().add(mNetworkFragment, "NetworkManager").commit();

        //Set filenames
        blake2bDriver = "blake2b.txt";
        blake2bHash = "hash.txt";
        reconfigDriver = "partial.txt";

        download = false;

        //SPO2 GRAPH BUTTON
        oxi_Connect = (Button) findViewById(R.id.oxi_connect_button);
        oxi_Connect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!BTNoninScanner.isScanning()) {
                    stopEverything();
                    Utility.toastie(getApplicationContext(), "Scanning");
                    BTNoninScanner.start();
                } else {
                    BTNoninScanner.stop();
                }
            }
        });
    }

    //When RadioGroup "Configuration" checked change
    private void doOnConfigChanged(RadioGroup group, int checkedId) {
        int checkedRadioID = group.getCheckedRadioButtonId();

        switch (checkedRadioID) {
            case R.id.radioButton_SDFT:
                break;

            case R.id.radioButton_HDFT:
                break;

            case R.id.radioButton_HFFT:
                break;

            case R.id.radioButton_custom_FFT:
                break;

            default: //equals to radioButton_SDFT
                break;
        }
    }


}
