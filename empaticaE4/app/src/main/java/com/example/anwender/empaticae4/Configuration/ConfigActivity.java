package com.example.anwender.empaticae4.Configuration;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.method.ScrollingMovementMethod;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.Button;
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

    private SharedPreferences mSharedPref;
    private boolean download;

    //public variables
    public static String repo_name = "SDFT"; //set default name of server repository
    public static int windowSize = 100;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_configuration);

        mSharedPref = this.getPreferences(Context.MODE_PRIVATE);

        //initialise Textviews
        mConsole = (TextView) findViewById(R.id.console);
        mConsole.setMovementMethod(new ScrollingMovementMethod());
        mServerIP = (TextView) findViewById(R.id.edit_serverIP);

        //initialise Buttons
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
                if (mServerIP.getText().toString().isEmpty()) {
                    //print with defined text colour
                    printColour("Enter Server IP address!", Color.RED);
                } else {
                    //Configure Network Manager and connect to server
                    mNetworkFragment.configure("http://" + mServerIP.getText() + ":5000/api/", repo_name);

                    if (!download) {
                        mNetworkFragment.getUpdate();
                    }
                }
            }
        });
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

    //When RadioGroup "Configuration" checked change
    private void doOnConfigChanged(RadioGroup group, int checkedId) {
        int checkedRadioID = group.getCheckedRadioButtonId();

        switch (checkedRadioID) {
            case R.id.radioButton_SDFT:
                repo_name = "SDFT"; //set name of server repository
                break;

            case R.id.radioButton_HDFT:
                repo_name = "HDFT"; //set name of server repository
                break;

            case R.id.radioButton_HFFT:
                repo_name = "HFFT"; //set name of server repository
                break;

            case R.id.radioButton_custom_FFT:
                repo_name = "custom_FFT"; //set name of server repository
                break;

            default: //equals to radioButton_SDFT
                repo_name = "SDFT"; //set name of server repository
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
        printDebug(text);
    }


    @Override
    public void onDownloadComplete(Repository repo) {
        download = false;
        Utility.toastie(getApplicationContext(), "Download complete");
        mConsole.append("\r\nDownload Complete\r\n");
        mMsgProcessor.verifyBitstream(repo);
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
        return mFabricManager.calculateHashFromFile(MainActivity.path + "/" + file, MainActivity.path + "/" + blake2bDriver, MainActivity.path + "/" + blake2bHash);
    }


    @Override
    public void onVerifiedBitstream(Repository repo, boolean valid) {
        if (valid) {
            mConsole.append("Bitstream verified\r\n");
            mConsole.append("Reconfigure fabric\r\n");
            mFabricManager.reconfigureFabric(MainActivity.path + "/" + repo.getFile(), MainActivity.path + "/" + reconfigDriver);
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
    public void onFilterApplied() {
        //change
    }



}
