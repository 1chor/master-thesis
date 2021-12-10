package com.example.anwender.empaticae4.Configuration;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.method.ScrollingMovementMethod;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;
import com.example.anwender.empaticae4.R;

import org.json.JSONObject;

import java.util.HashMap;

public class ConfigActivity extends AppCompatActivity implements  NetworkManager.Callback, MsgProcessor.Callback, FabricManager.Callback {

    //classes
    private FragmentManager mFragManager;
    private NetworkManager mNetworkFragment;
    private MsgProcessor mMsgProcessor;
    private FabricManager mFabricManager;

    //layout
    private TextView mConsole;
    private TextView mServerIP;
    private CheckBox checkBoxhash;

    private RadioButton radioButtonSDFT;
    private RadioButton radioButtonXDFT;
    private RadioButton radioButtonXFFT;
    private RadioButton radioButtonXFFT_fixed;
    private RadioButton radioButtonINTFFTK;
    private RadioButton radioButtonINTFFT_SPDF;
    private RadioButton radioButtonDBLCLKFFT;

    //filenames
    private String blake2bDriver;
    private String blake2bHash;
    private String reconfigDriver;

    private SharedPreferences mSharedPref;
    private boolean download;
    private Boolean configureExtra = false;

    //public variables
    public static String repo_name = "SDFT"; //set default name of server repository
    public static int windowSize = 100;
    public static boolean enable_hash = false;
    public static String serverIP = "192.168.2.7"; //default value for debug case - delete afterwards

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_configuration);

        //get parameter from MainActivity
        configureExtra = getIntent().getExtras().getBoolean("configure", false);

        mSharedPref = this.getPreferences(Context.MODE_PRIVATE);

        //initialise Textviews
        mConsole = (TextView) findViewById(R.id.console);
        mConsole.setMovementMethod(new ScrollingMovementMethod());
        mServerIP = (TextView) findViewById(R.id.edit_serverIP);

        //initialise Buttons
        Button mButtonConfig = (Button) findViewById(R.id.button_config);
        Button mButtonSave = (Button) findViewById(R.id.button_save_config);

        //initialise RadioButtons
        RadioGroup radioGroupConfig = (RadioGroup) findViewById(R.id.radioGroup);
        radioButtonSDFT = (RadioButton) findViewById(R.id.radioButton_SDFT);
        radioButtonXDFT = (RadioButton) findViewById(R.id.radioButton_XDFT);
        radioButtonXFFT = (RadioButton) findViewById(R.id.radioButton_XFFT);
        radioButtonXFFT_fixed = (RadioButton) findViewById(R.id.radioButton_XFFT_fixed);
        radioButtonINTFFTK = (RadioButton) findViewById(R.id.radioButton_INTFFTK);
        radioButtonINTFFT_SPDF = (RadioButton) findViewById(R.id.radioButton_INTFFT_SPDF);
        radioButtonDBLCLKFFT = (RadioButton) findViewById(R.id.radioButton_DBLCLKFFT);
        
        //When RadioGroup "Configuration" checked change
        radioGroupConfig.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                doOnConfigChanged(group, checkedId);
            }
        });

        //initialise CheckBox
        checkBoxhash = (CheckBox) findViewById(R.id.checkBox_hash);

        //Initialise classes
        mNetworkFragment = new NetworkManager();
        mMsgProcessor = new MsgProcessor(this);
        mFabricManager = new FabricManager(this);
        mFragManager = getSupportFragmentManager();
        mFragManager.beginTransaction().add(mNetworkFragment, "NetworkManager").commit();

        //Set filenames
        blake2bDriver = "blake2b.txt";
        blake2bHash = "hash.txt";
        reconfigDriver = "partial.txt";

        download = false;

        //Configure button
        mButtonConfig.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changeConfiguration();
            }
        });

        mButtonSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                serverIP = mServerIP.getText().toString(); //save IP to variable

                enable_hash = checkBoxhash.isChecked(); //check if hash is enabled and save it to variable
            }
        });

        if (configureExtra) {
            changeConfiguration();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();

        //Set ServerIP
        mServerIP.setText(serverIP);

        //Set checkbox for hash calculation
        checkBoxhash.setChecked(enable_hash);

        //Set current radioButton setting
        switch (repo_name) {
            case "SDFT":
                radioButtonSDFT.setChecked(true);
                break;

            case "XDFT":
                radioButtonXDFT.setChecked(true);
                break;

            case "XFFT":
                radioButtonXFFT.setChecked(true);
                break;

            case "XFFT_fixed":
                radioButtonXFFT_fixed.setChecked(true);
                break;

            case "INTFFTK":
                radioButtonINTFFTK.setChecked(true);
                break;

            case "INTFFT_SPDF":
                radioButtonINTFFT_SPDF.setChecked(true);
                break;

            case "DBLCLKFFT":
                radioButtonDBLCLKFFT.setChecked(true);
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mNetworkFragment.onDetach();
        mNetworkFragment = null;
        mMsgProcessor = null;
        mFragManager = null;
    }


    //--------------------------------------------------------------------------------------------//
    //  FUNCTIONS:
    //--------------------------------------------------------------------------------------------//

    public void changeConfiguration() {
        if (serverIP.isEmpty()) {
            //print with defined text colour
            printColour("Enter Server IP address!", Color.RED);
        } else {
            //Configure Network Manager and connect to server
            mNetworkFragment.configure("http://" + serverIP + ":5000/api/", repo_name);

            if (!download) {
                //MainActivity.mTimer.setStartTime(0); //start Timer
                mNetworkFragment.getUpdate();
            }
        }
    }

    //When RadioGroup "Configuration" checked change
    private void doOnConfigChanged(RadioGroup group, int checkedId) {
        int checkedRadioID = group.getCheckedRadioButtonId();

        switch (checkedRadioID) {
            case R.id.radioButton_SDFT:
                repo_name = "SDFT"; //set name of server repository
                windowSize = 100; //set WindowSize
                break;

            case R.id.radioButton_XDFT:
                repo_name = "XDFT"; //set name of server repository
                windowSize = 108; //set WindowSize
                break;

            case R.id.radioButton_XFFT:
                repo_name = "XFFT"; //set name of server repository
                windowSize = 128; //set WindowSize
                break;

            case R.id.radioButton_XFFT_fixed:
                repo_name = "XFFT_fixed"; //set name of server repository
                windowSize = 128; //set WindowSize
                break;

            case R.id.radioButton_INTFFTK:
                repo_name = "INTFFTK"; //set name of server repository
                windowSize = 128; //set WindowSize
                break;

            case R.id.radioButton_INTFFT_SPDF:
                repo_name = "INTFFT_SPDF"; //set name of server repository
                windowSize = 128; //set WindowSize
                break;

            case R.id.radioButton_DBLCLKFFT:
                repo_name = "DBLCLKFFT"; //set name of server repository
                windowSize = 128; //set WindowSize
                break;

            default: //equals to radioButton_SDFT
                repo_name = "SDFT"; //set name of server repository
                windowSize = 100; //set WindowSize
                break;
        }
    }

    /**
     * save information to persistence storage
     *
     * @param repository
     */
    private void saveConfig(Repository repository) {
        SharedPreferences.Editor editor = mSharedPref.edit();
        editor.putString(Constants.JSON.INDEX, repository.getIndex());
        editor.putString(Constants.JSON.VERSION, repository.getVersion());
        editor.putString(Constants.JSON.DATE, repository.getDate());
        editor.putString(Constants.JSON.CHECKSUM, repository.getChecksum());
        editor.commit();
    }

    /**
     * load information from persistence storage
     *
     * @return
     */
    private HashMap<String, String> getConfig() {
        HashMap<String, String> dict = new HashMap<String, String>();
        dict.put(Constants.JSON.INDEX, mSharedPref.getString(Constants.JSON.INDEX, null));
        dict.put(Constants.JSON.VERSION, mSharedPref.getString(Constants.JSON.VERSION, null));
        dict.put(Constants.JSON.DATE, mSharedPref.getString(Constants.JSON.DATE, null));
        dict.put(Constants.JSON.CHECKSUM, mSharedPref.getString(Constants.JSON.CHECKSUM, null));

        return dict;
    }

    /**
     * print message to user interface
     *
     * @param text
     */
    private void printDebug(String text) {
        mConsole.append("\r\n" + text);
    }


    /**
     * print message to user interface in defined colour
     *
     * @param text
     * @param colour
     */
    private void printColour(String text, int colour) {
        //change text colour only for one print
        Spannable WordtoSpan = new SpannableString("\r\n" + text);
        WordtoSpan.setSpan(new ForegroundColorSpan(colour), 0, WordtoSpan.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        mConsole.append(WordtoSpan);
    }


    //--------------------------------------------------------------------------------------------//
    //  NETWORK MANAGER CALLBACKS:
    //--------------------------------------------------------------------------------------------//

    @Override
    public void onDataAvailable(JSONObject json) {
        mMsgProcessor.process(json);
    }


    @Override
    public void printToTextBox(String text) {
        printColour(text, Color.RED);

        if (configureExtra) {
            //Close activity (no new update available)
            Intent returnIntent = new Intent();
            setResult(Activity.RESULT_CANCELED, returnIntent); //set return code
            finish(); //finishing activity
        }
    }


    @Override
    public void onDownloadComplete(Repository repo) {
        download = false;
        Utility.toastie(getApplicationContext(), "Download complete");
        mConsole.append("\r\nDownload Complete\r\n");
        //MainActivity.mTimer.setStartTime(1); //Start Timer
        mMsgProcessor.verifyBitstream(repo, enable_hash);
    }

    //--------------------------------------------------------------------------------------------//
    //  MESSAGE PROCESSOR CALLBACKS:
    //--------------------------------------------------------------------------------------------//

    @Override
    public void onUpdateAvailable(Repository repo) {
        //init download
        download = true;
        mConsole.append("\r\n" + repo.toString());

        saveConfig(repo);   // disable for debugging
        mNetworkFragment.download(repo, MainActivity.path);
    }

    @Override
    public byte[] calculateHash(String file) {
        return mFabricManager.calculateHashFromFile(file, MainActivity.path + "/" + blake2bDriver, MainActivity.path + "/" + blake2bHash);
    }


    @Override
    public void onVerifiedBitstream(Repository repo, boolean valid) {
        if (valid) {
            if (enable_hash) {
                mConsole.append("Bitstream verified\r\n");
                //MainActivity.mTimer.setEndTime(1); //End Timer
                //printDebug("Hash calculation took " + MainActivity.mTimer.getTimer(1) + " seconds.");
            } else {
                mConsole.append("Bitstream not verified, but it continues anyway\r\n");
            }

            mConsole.append("Reconfigure fabric\r\n");
            //MainActivity.mTimer.setStartTime(2); //Start Timer
            mFabricManager.reconfigureFabric(repo.getFile(), MainActivity.path + "/" + reconfigDriver);
        } else {
            mConsole.append("Bitstream invalid\r\n");
        }
    }


    @Override
    public HashMap<String, String> getCurrentConfig() {
        return getConfig();
    }

    //--------------------------------------------------------------------------------------------//
    //  FABRIC MANAGER CALLBACKS:
    //--------------------------------------------------------------------------------------------//

    @Override
    public void onReconfigureFabricDone() {
        //MainActivity.mTimer.setEndTime(2); //End Timer
        //MainActivity.mTimer.setEndTime(0); //End Timer

        //printDebug("Reconfiguration took " + MainActivity.mTimer.getTimerMilli(2) + " milliseconds.");

        //printDebug("Update process took " + MainActivity.mTimer.getTimer(0) + " seconds.");

        if (configureExtra) {
            //Close activity (configuration was successfull)
            Intent returnIntent = new Intent();
            setResult(Activity.RESULT_OK, returnIntent); //set return code
            finish(); //finishing activity
        }
    }
}
