package com.example.anwender.empaticae4.Main;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.empatica.empalink.ConnectionNotAllowedException;
import com.empatica.empalink.EmpaDeviceManager;
import com.empatica.empalink.config.EmpaSensorStatus;
import com.empatica.empalink.config.EmpaSensorType;
import com.empatica.empalink.config.EmpaStatus;
import com.empatica.empalink.delegate.EmpaDataDelegate;
import com.empatica.empalink.delegate.EmpaStatusDelegate;
import com.example.anwender.empaticae4.Configuration.ConfigActivity;
import com.example.anwender.empaticae4.EWS.RRScore;
import com.example.anwender.empaticae4.EWS.SBP;
import com.example.anwender.empaticae4.HttpUpload.FileUpload;
import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.data.Entry;

import org.w3c.dom.Text;

import java.io.File;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.ConcurrentModificationException;
import java.util.List;
import java.util.Locale;


public class MainActivity extends AppCompatActivity implements EmpaDataDelegate, EmpaStatusDelegate, View.OnClickListener {

    private final String LOG_TAG = MainActivity.class.getSimpleName();

    private static final long SCANNING_TIME = 5000;
    private static final int REQUEST_ENABLE_BT = 1;
    private static final int REQUEST_PERMISSION_ACCESS_COARSE_LOCATION = 1;
    private static final int REQUEST_PERMISSION_WRITE_EXTERNAL_STORAGE = 2;
    private static final String EMPATICA_API_KEY = "ad5909035e124e388e2fa83802c57513"; //Unique API key needed for development
    public static final File path = Utility.getStorageDir("E4");          //Name of the Subdirectory in Documents
    private final String URL = "https://ictsrv023.ict.tuwien.ac.at/upload.php";     //note, http and https have a different root directory//note, http and https have a different root directory
    private final String conductor = "00"; //00 for server
    private final String observed = "0";  //0 = not observed, 1 = observed

    private final NumberFormat formatter = new DecimalFormat("##########.###");  //format timestamps to: 10 digits for unixtime in seconds + 3 digits for millisseconds



    public static File sessionPath;                               //Path to session specific folder E4/...
    public static boolean sessionActive = false;                  //Define Session status
    public static String userID;
    public static String startTime;


    private EmpaDeviceManager deviceManager = null;
    private static EmpaStatus empaStatus;

    private TextView connectionStatus;
    private TextView batteryLevel;
    private TextView connectedDevice;
    private TextView configuration;
    private TextView configuration_name;

    private ProgressBar progressBar;
    private Handler handler = new Handler();

    private Intent serviceSession;
    private BluetoothReceiver bluetoothReceiver;

    private ArrayList<String> bluetoothList = new ArrayList<>();
    private ArrayAdapter<String> bluetoothAdapter;

    private Button btnStart;

    private boolean flagBVP;
    private boolean flagACC;
    private boolean flagGSR;
    private boolean flagTEMP;

    static public List<Entry> tempSamples = new ArrayList<>();
    static public List<Entry> tempScores = new ArrayList<>();
    static public List<Float> tempHist = new ArrayList<>();
    static public List<Integer> tempHistScore = new ArrayList<>();
    static public List<Entry> sbpSamples = new ArrayList<>();
    static public List<Entry> sbpScores = new ArrayList<>();
    static public List<Float> sbpHist = new ArrayList<>();
    static public List<Integer> sbpHistScore = new ArrayList<>();
    static public List<Entry> rrSamples = new ArrayList<>();
    static public List<Entry> rrScores = new ArrayList<>();
    static public List<Float> rrHist = new ArrayList<>();
    static public List<Integer> rrHistScore = new ArrayList<>();
    static public List<Entry> hrSamples = new ArrayList<>();
    static public List<Entry> hrScores = new ArrayList<>();
    static public List<Float> hrHist = new ArrayList<>();
    static public List<Integer> hrHistScore = new ArrayList<>();
    static public List<Entry> ewsScores = new ArrayList<>();


    static public ArrayList<String> XGraphValues = new ArrayList<>();
    static public float timestp;
    int temp_score;
    int sbp_score;
    int rr_score;
    int hr_score;
    int save_hist = 5;

    private FilterBVPData filters = new FilterBVPData();
    private int filtersInit = 0;
    boolean firstWindow=true;
    public List<Float> bvpSamples = new ArrayList<>();



    @SuppressLint("DefaultLocale")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.acitivity_main);

        initializeLayout();

        //Make sure the app can write to external storage
        checkExternalStoragePermissions();

        //Get user id from shared preferences
        SharedPreferences login_status = getSharedPreferences("Login_status", Context.MODE_PRIVATE);

        /*
        // out-commented by Andreas Dejmek, as no login is available
            //userID = (login_status.getString("userID", ""));
        */
        userID = "1"; //use pseudo ID instead

        userID=String.format("%010d", Integer.parseInt(userID)); //Pad idNumber with 0s for a constant length
        Log.i("MainActivity", "userID= " + userID);

        //Register Broadcast Receiver to detect Bluetooth status change
        bluetoothReceiver = new BluetoothReceiver();
        IntentFilter filter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        registerReceiver(bluetoothReceiver, filter);

        //Intent to start the service (foreground)
        serviceSession = new Intent(this, MyService.class);

        /*
        // out-commented by Andreas Dejmek, as no device is available
            //Initialize the device manager to communicate with the E4
            //initEmpaticaDeviceManager();
        */
    }

    private  void initializeLayout(){

        //initialize Textviews
        connectionStatus = (TextView) findViewById(R.id.text_connection_status);
        batteryLevel = (TextView) findViewById(R.id.text_battery_level);
        connectedDevice = (TextView) findViewById(R.id.text_device_name);
        configuration = (TextView) findViewById(R.id.text_config);
        configuration_name = (TextView) findViewById(R.id.text_config_name);

        updateTextView(configuration_name, ConfigActivity.repo_name);

        //Initialize Buttons
        btnStart = findViewById(R.id.button_start);
        btnStart.setOnClickListener(this);

        Button btnStop = findViewById(R.id.button_stop);
        btnStop.setOnClickListener(this);

        Button btnEmotion = findViewById(R.id.button_emotion);
        btnEmotion.setOnClickListener(this);

        Button btnActivity = findViewById(R.id.button_activity);
        btnActivity.setOnClickListener(this);

        Button btnLogEmotion = findViewById(R.id.button_log_emotion);
        btnLogEmotion.setOnClickListener(this);

        Button btnLogActivity = findViewById(R.id.button_log_activity);
        btnLogActivity.setOnClickListener(this);

        Button btnEWSActivity = findViewById(R.id.button_EWS_Score);
        btnEWSActivity.setOnClickListener(this);

        Button btnTestRR = findViewById(R.id.button_test_RR);
        btnTestRR.setOnClickListener(this);

        Button btnConfigRR = findViewById(R.id.button_config_RR);
        btnConfigRR.setOnClickListener(this);

        progressBar = findViewById(R.id.progressBar);
    }


    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.button_start:
                connectDevice();
                break;
            case R.id.button_stop:
                onDisconnect();
                break;
            case R.id.button_emotion:
                if(sessionActive){
                    final Intent TagEmotion = new Intent(MainActivity.this, com.example.anwender.empaticae4.Main.TagEmotion.class);
                    TagEmotion.putExtra("sessionPath", sessionPath); // Send the Path to save to
                    startActivity(TagEmotion);
                }
                else{
                    Utility.toastie(getApplicationContext(),"Device must be Connected");
                }
                break;
            case R.id.button_log_emotion:
                if(sessionActive){
                    final Intent LogEmotion = new Intent(MainActivity.this, LogEmotionActivity.class);
                    LogEmotion.putExtra("sessionPath", sessionPath); // Send the Path to save to
                    startActivity(LogEmotion);
                }
                else{
                    Utility.toastie(getApplicationContext(),"Device must be Connected");
                }
                break;
            case R.id.button_activity:
                if(sessionActive){
                    final Intent TagActivity = new Intent(MainActivity.this, com.example.anwender.empaticae4.Main.TagActivity.class);
                    TagActivity.putExtra("sessionPath", sessionPath); // Send the Path to save to
                    startActivity(TagActivity);
                }
                else{
                    Utility.toastie(getApplicationContext(),"Device must be Connected");
                }
                break;
            case R.id.button_log_activity:
                if(sessionActive){
                    final Intent LogActivity = new Intent(MainActivity.this, com.example.anwender.empaticae4.Main.LogActivity.class);
                    LogActivity.putExtra("sessionPath", sessionPath); // Send the Path to save to
                    startActivity(LogActivity);
                }
                else{
                    Utility.toastie(getApplicationContext(),"Device must be Connected");
                }
                break;
            case R.id.button_EWS_Score:
                final Intent ConnectOximeter = new Intent(MainActivity.this, com.example.anwender.empaticae4.EWS.ConnectOximeter.class);
                ConnectOximeter.putExtra("Path", path); // Send the Path to save to
                startActivity(ConnectOximeter);
                break;
            case R.id.button_logout:
                Log.d("MainAcitivty", "Logout");
                onDisconnect();
                logout();

                final Intent LoginActivity = new Intent(MainActivity.this, com.example.anwender.empaticae4.Usermanagment.LoginActivity.class);
                startActivity(LoginActivity);
                finish();
                break;
            case R.id.button_test_RR:
                Log.i("Start RR Test", "Use " + ConfigActivity.repo_name + " method");
                //Start test
                test_didReceiveBVP();
                Utility.toastie(getApplicationContext(),"RR Test started!");
                break;
            case R.id.button_config_RR:
                final Intent ConfigActivity = new Intent(MainActivity.this, com.example.anwender.empaticae4.Configuration.ConfigActivity.class);
                ConfigActivity.putExtra("Path", path); // Send the Path to save to
                startActivity(ConfigActivity);
                break;
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main, menu);
        return true;
    }
    @Override
    protected void onPause() {
        super.onPause();
        if (deviceManager != null) {
            deviceManager.stopScanning();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(bluetoothReceiver);
        if (deviceManager != null) {
            deviceManager.cleanUp();
            onDisconnect();
        }
    }

    @Override
    public void onBackPressed() {
        moveTaskToBack(true);
    }

    @Override
    public void onRestart() {
        super.onRestart();
        updateTextView(configuration_name, ConfigActivity.repo_name);
    }

    @Override
    public void didReceiveAcceleration(int x, int y, int z, double timestamp) {

        //When called for the first time, write sample frequency (=32Hz) and start timestamp in the first 2 rows
        if( !flagACC ){
            Utility.writetoCSV(this, sessionPath, "ACC_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", "32"  + '\n' + formatter.format(timestamp) + '\n');
            flagACC=true;
        } else{
            Utility.writetoCSV(this, sessionPath, "ACC_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", Integer.toString(x) + ',' +
                    Integer.toString(y) + ',' + Integer.toString(z)  + '\n');

        }
    }

    public void test_didReceiveBVP() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                final int max = 9297;
                float bvp = 0;

                for (int i = 0; i < max; i++) {
                    final int progress = i + 1;

                    bvp = Utility.readfromCSV(getApplicationContext(), path, "BVP1.csv", i);

                    //When called for the first time, write sample frequency (= 64Hz) and start timestamp in the first 2 rows
                    if (!flagBVP) {
                        flagBVP = true;
                        firstWindow = true;
                        //Clear all elements in the array
                        bvpSamples.clear();

                    } else {

                        //Here we need to skip (to avoid problems, the first 8 samples (zeros)
                        filtersInit++;
                        if (filtersInit > 9 || !firstWindow) {
                            bvpSamples.add(filters.filteredData(bvp));
                            //if (bvpSamples.size() == 1728) {
                            if (bvpSamples.size() == 1878) { // needed for XFFT
                                RRScore analyze = new RRScore(bvpSamples);
                                rrSamples.add(new Entry(rrSamples.size(), analyze.runAnalysis()));
                                rrScores.add(new Entry(rrScores.size(), getRREWScore(analyze.runAnalysis())));
                                rrHist.add((float) analyze.runAnalysis());
                                rrHistScore.add(getRREWScore(analyze.runAnalysis()));
                                setEWSValue();
                                setHistFiles();
                                Log.i("RR-Ready", "RR analysis finished!, Ready to show!");
                                bvpSamples.clear();
                                analyze.clearBuffer();
                                firstWindow = false;
                            }
                        }
                    }

                    //Update the progress bar
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            //Set progress bar
                            progressBar.setProgress((progress * 100) / max);

                            if ( progressBar.getProgress() == progressBar.getMax())
                                Utility.toastie(getApplicationContext(),"RR Test finished!");
                        }
                    });
                }
                Log.i("RR-Finish", "RR Test finished!");
            }
        });
        thread.start();
    }

    int bvpFreq=64;
    int addBVP=0; //Temperature frequency is 4Hz, bvp is 64 Hz, i is used to add to the graph the same number of values of both data
    @Override
    public void didReceiveBVP(float bvp, double timestamp)
    {

        //When called for the first time, write sample frequency (= 64Hz) and start timestamp in the first 2 rows
        if( !flagBVP ){
            Utility.writetoCSV(this, sessionPath, "BVP_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", "64"  + '\n' + formatter.format(timestamp) + '\n');
            flagBVP=true;
            firstWindow = true;

        } else{
            Utility.writetoCSV(this, sessionPath, "BVP_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", Float.toString(bvp) + '\n');
            //Here we need to skip (to avoid problems, the first 8 samples (zeros)
            filtersInit++;
            if(filtersInit >9 || !firstWindow){
                bvpSamples.add(filters.filteredData(bvp));
                if(bvpSamples.size() == 1728){
                    RRScore analyze = new RRScore(bvpSamples);
                    rrSamples.add(new Entry(rrSamples.size(),analyze.runAnalysis()));
                    rrScores.add(new Entry(rrScores.size(),getRREWScore(analyze.runAnalysis())));
                    rrHist.add((float) analyze.runAnalysis());
                    rrHistScore.add(getRREWScore(analyze.runAnalysis()));
                    setEWSValue();
                    setHistFiles();
                    Log.i("RR-Ready","RR analysis finished!, Ready to show!");
                    bvpSamples.clear();
                    analyze.clearBuffer();
                    firstWindow=false;
                }
            }
        }
    }

    @Override
    public void didReceiveBatteryLevel(float battery, double timestamp) {
        //display battery level properly formatted
        updateTextView(batteryLevel, String.format(Locale.getDefault(), "%2.0f" , battery*100 )+ '%');
    }

    @Override
    public void didReceiveGSR(float gsr, double timestamp) {

        //When called for the first time, write sample frequency (= 4Hz) and start timestamp in the first 2 rows
        if( !flagGSR ){
            Utility.writetoCSV(this, sessionPath, "GSR_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", "4"  + '\n' + formatter.format(timestamp) + '\n');
            flagGSR=true;
        } else{
            Utility.writetoCSV(this, sessionPath, "GSR_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", Float.toString(gsr) + '\n');
        }
    }

    @Override
    public void didReceiveIBI(float ibi, double timestamp) {
        //IBI does not have a fixed intervall, because of that the format is different
        Utility.writetoCSV(this, sessionPath, "IBI_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", Float.toString(ibi) + ',' + formatter.format(timestamp) +'\n');
        SBP sbp = new SBP(bvpSamples,ibi);
        sbpSamples.add(new Entry(sbpSamples.size(),sbp.getSbp()));
        sbpScores.add(new Entry(sbpScores.size(),getSBPEWScore(sbp.getSbp())));
        sbpHist.add(sbp.getSbp());
        sbpHistScore.add(getSBPEWScore(sbp.getSbp()));
        hrSamples.add(new Entry(hrSamples.size(),(float)(60.0/ibi)));
        hrScores.add(new Entry(hrScores.size(),getHREWScore((float)(60.0/ibi))));
        hrHist.add((float)(60.0/ibi));
        hrHistScore.add(getHREWScore((float)(60.0/ibi)));
        setEWSValue();
        setHistFiles();
        Log.i("SBP-Ready","SBP is ready to analyze");
    }

    int tempFreq = 4;
    int addTemp = 0;
    float absZero = (float) -273.15;
    @Override
    public void didReceiveTemperature(float temp, double timestamp) {

        //When called for the first time, write sample frequency (= 4Hz) and start timestamp in the first 2 rows
        if( !flagTEMP ){
            Utility.writetoCSV(this, sessionPath, "TEMP_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", "4"  + '\n' + formatter.format(timestamp) + '\n');
            flagTEMP=true;
        }
        else{
            Utility.writetoCSV(this, sessionPath, "TEMP_E4_" + conductor + observed + "_" + startTime + "_" + userID +".csv", Float.toString(temp) + '\n');
            //Data will be graphed only once per second and the absolute zero will be not considered (usually get as the initial value).
            if ((addTemp%tempFreq == 0) && (temp !=absZero)) {
                tempSamples.add(new Entry(tempSamples.size(), temp));
                tempScores.add(new Entry(tempScores.size(), getTempEWScore(temp)));
                tempHist.add(temp);
                tempHistScore.add(getTempEWScore(temp));
                setEWSValue();
                setHistFiles();
            }
            addTemp++;
        }
    }

    @Override
    public void didUpdateStatus(EmpaStatus eStatus) {
        // Update the UI
        updateTextView(connectionStatus, eStatus.name());
        empaStatus=eStatus;
        Log.i(LOG_TAG, "Current Status " + eStatus.toString());

        // The device manager is ready for use
        if (eStatus == EmpaStatus.READY) {
            //When the device manager is ready to use, enable the start button
            readyToConnect();

            // The device manager has established a connection
        } else if (eStatus == EmpaStatus.CONNECTED && !sessionActive) {

            //Create temporary directory for session
           // String out = userID + System.currentTimeMillis();
            startTime=System.currentTimeMillis()+"";
            sessionPath = new File(path + File.separator + userID + "_"+ startTime );
            if (!sessionPath.mkdir()) {
                Log.e(LOG_TAG, "Session Directory not created");
            }
            else {
                Log.i(LOG_TAG, "Session Directory created");
                sessionActive = true;
                startService(serviceSession);
            }
            // The device manager disconnected from a device
        } else if (eStatus == EmpaStatus.DISCONNECTED) {
            if(sessionActive){
                stopService(serviceSession);
                Log.i("didUpdateStatus", "Service stopped");
                sessionActive = false;
            }
           //Todo consider uploading files here
            Handler handler = new Handler(Looper.getMainLooper());
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                   readyToConnect();
                    updateTextView(connectedDevice,"-");
                    updateTextView(batteryLevel,"-");
                    if(bluetoothList!=null && bluetoothAdapter!=null){
                        bluetoothList.clear();
                        bluetoothAdapter.clear();
                    }
                    //TODO not sure if this works well in a separated Handler
                    //Upload all Files in the E4 directory
                    //TODO Cayetano Lopez Leiva: out-commented to avoid uploading to TU servers
                    //uploadAll();

                }
            }, 100 );
        }
    }

    @Override
    public void didUpdateSensorStatus(EmpaSensorStatus empaSensorStatus, EmpaSensorType empaSensorType) {
        //TODO ?only write to csv in dependence of empaSensorStatus?
        //DEAD, NOT_ON_WRIST, ON_WRIST
    }

    @Override
    public void didDiscoverDevice( BluetoothDevice bluetoothDevice, String deviceName, int rssi, boolean allowed) {
        //rssi = Received Signal Strength
        // Check if the discovered device can be used with your API key. If allowed is always false,
        // the device is not linked with your API key.
        if (allowed) {
            if(!bluetoothList.contains(bluetoothDevice.getAddress() + "\n" + deviceName)) {
               Log.i("DidDiscoverDevice", bluetoothDevice + "\n" + deviceName);
                // If the connection is allowed and the device is not on the list add it
                bluetoothList.add(bluetoothDevice.getAddress() + "\n" + deviceName);
            }
        }
    }

    private void initEmpaticaDeviceManager() {
        // Android 6 (API level 23) now require ACCESS_COARSE_LOCATION permission to use BLE
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.ACCESS_COARSE_LOCATION }, REQUEST_PERMISSION_ACCESS_COARSE_LOCATION);
        } else {
            // Create a new EmpaDeviceManager. MainActivity is both its data and status delegate.
            deviceManager = new EmpaDeviceManager(getApplicationContext(), this, this);

            if (TextUtils.isEmpty(EMPATICA_API_KEY)) {
                new AlertDialog.Builder(this)
                        .setTitle("Warning")
                        .setMessage("Please insert your API KEY")
                        .setNegativeButton("Close", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                // without permission exit is the only way
                                finish();
                            }
                        })
                        .show();
                return;
            }
            // Initialize the Device Manager using your API key. You need to have Internet access at this point.
            deviceManager.authenticateWithAPIKey(EMPATICA_API_KEY);
        }
    }

    public void updateTextView(final TextView id, final String text) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                id.setText(text);
            }
        });
    }

    @Override
    public void didRequestEnableBluetooth() {
        // Request the user to enable Bluetooth
        Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
    }

    public void checkExternalStoragePermissions() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    REQUEST_PERMISSION_WRITE_EXTERNAL_STORAGE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        //Handle Bluetooth for API level 23+ / Android 6+
        switch (requestCode) {
            case REQUEST_PERMISSION_ACCESS_COARSE_LOCATION:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission was granted, yay!
                    initEmpaticaDeviceManager();
                } else {
                    // Permission denied, boo!
                    final boolean needRationale = ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_COARSE_LOCATION);
                    new AlertDialog.Builder(this)
                            .setTitle("Permission required")
                            .setMessage("Without this permission bluetooth low energy devices cannot be found, allow it in order to connect to the device.")
                            .setPositiveButton("Retry", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // try again
                                    if (needRationale) {
                                        // the "never ask again" flash is not set, try again with permission request
                                        initEmpaticaDeviceManager();
                                    } else {
                                        // the "never ask again" flag is set so the permission requests is disabled, try open app settings to enable the permission
                                        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                                        Uri uri = Uri.fromParts("package", getPackageName(), null);
                                        intent.setData(uri);
                                        startActivity(intent);
                                    }
                                }
                            })
                            .setNegativeButton("Exit application", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // without permission exit is the only way
                                    finish();
                                }
                            })
                            .show();
                }
                break;
            case REQUEST_PERMISSION_WRITE_EXTERNAL_STORAGE:
                if (grantResults.length <= 0 || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    // Permission denied, boo!
                    final boolean needRationale = ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE);
                    new AlertDialog.Builder(this)
                            .setTitle("Permission required")
                            .setMessage("Without this permission data will not be saved or loaded, allow it in order to run the app properly.")
                            .setPositiveButton("Retry", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // try again
                                    if (needRationale) {
                                        // the "never ask again" flash is not set, try again with permission request
                                        checkExternalStoragePermissions();

                                    } else {
                                        // the "never ask again" flag is set so the permission requests is disabled, try open app settings to enable the permission
                                        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                                        Uri uri = Uri.fromParts("package", getPackageName(), null);
                                        intent.setData(uri);
                                        startActivity(intent);
                                    }
                                }
                            })
                            .setNegativeButton("Exit application", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // without permission exit is the only way
                                    finish();
                                }
                            })
                            .show();
                }
        }
    }

    private void connectDevice(){
        Log.i("DidDiscoverDevice", "Let the search begin");

        if(empaStatus==EmpaStatus.READY || empaStatus==EmpaStatus.DISCONNECTED ){
            //avoid multiple searches at the same time by disabling the connect button
            btnStart.setClickable(false);
            btnStart.setEnabled(false);
            updateTextView(connectionStatus, "Searching...");
            // Start scanning
            deviceManager.startScanning();
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            //Stop scanning after SCANNING_TIME and display devices if found
                            deviceManager.stopScanning();
                            bluetoothAdapter = new ArrayAdapter<>(
                                    MainActivity.this,
                                    android.R.layout.select_dialog_singlechoice,
                                    bluetoothList );

                            if(!bluetoothList.isEmpty()){
                                AlertDialog.Builder bluetoothDevices = new AlertDialog.Builder(MainActivity.this);
                                bluetoothDevices.setTitle("Select your Device");
                                bluetoothDevices.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        //If no device is selected, another search is possible
                                        readyToConnect();
                                        dialog.dismiss();
                                    }
                                });

                                //Set the adapter with the Devices for this dialog
                                bluetoothDevices.setAdapter(bluetoothAdapter, new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {

                                        //Devices are Stored in bluetoothList and bluetoothAdapter as (adress + '\n' + name)
                                        //to get name and Adress the entry needs to be split
                                        String[] devices = bluetoothAdapter.getItem(which).split("\\n");
                                        String deviceAddress =devices[0];
                                        String deviceName =devices[1];
                                        try {
                                            //Create a Bluetooth device with the address found while scanning and connect to it
                                            deviceManager.connectDevice(BluetoothAdapter.getDefaultAdapter().getRemoteDevice(deviceAddress));

                                        } catch (ConnectionNotAllowedException | NullPointerException e) {
                                            // This should happen only if you try to connect when allowed == false.
                                            e.printStackTrace();
                                            Toast.makeText(MainActivity.this, "Sorry, you can't connect to this device", Toast.LENGTH_SHORT).show();
                                        }
                                        updateTextView(connectedDevice, deviceName);
                                    }
                                });
                                bluetoothDevices.setOnCancelListener( new DialogInterface.OnCancelListener() {
                                    @Override
                                    public void onCancel(DialogInterface dialog) {
                                        readyToConnect();
                                    }
                                });
                                bluetoothDevices.show();

                            }
                            else{
                                AlertDialog.Builder builderNotFound= new AlertDialog.Builder(MainActivity.this);
                                builderNotFound.setTitle("No device found");
                                builderNotFound.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        dialog.dismiss();

                                    }
                                });
                                builderNotFound.show();
                                readyToConnect();
                            }
                        }
                    }, SCANNING_TIME);
                }
            });

        }
        else{
            Utility.toastie(getApplicationContext(),"Not ready");
        }
    }

    // cleanup function
    private void onDisconnect (){
        if (empaStatus == EmpaStatus.CONNECTED) {
            deviceManager.disconnect();
            Log.i("onDisconnect", "deviceManager disconnected");
            updateTextView(connectedDevice,"-");
            updateTextView(batteryLevel,"-");
            Log.i("onDisconnect", "TextViews updated");
            bluetoothList.clear();
            bluetoothAdapter.clear();
            Log.i("onDisconnect", "Adapter and list cleared");
        } else {
           Log.i("onDisconnect", "Not connected");
        }
    }

    //set sharedpreferences to reflect user has logged out
    private void logout (){
        SharedPreferences pref = getSharedPreferences("Login_status", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putBoolean("user_loggedIn", false);
        editor.apply();
    }

    //enable the Connectbutton and the TextView to reflect that a connection is possible
    private void readyToConnect(){
        //final Button btn_start = (Button)findViewById(R.id.button_start);
        btnStart.setClickable(true);
        btnStart.setEnabled(true);
        updateTextView(connectionStatus, "Ready");
    }



    //Launches the about activity with info about the project
    public void startAboutActivity(MenuItem item) {
        final Intent AboutActivity = new Intent(MainActivity.this, com.example.anwender.empaticae4.Main.AboutActivity.class);
        startActivity(AboutActivity);
    }

    //uploads all files in the given Path and deletes them after a succesful upload
    private void uploadAll() {
        FileUpload upload = new FileUpload(path.toString(), URL);
        upload.main();
    }


    //detect Bluetooth status change and display a warning if bluetooth is turned off
    public class BluetoothReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            final String action = intent.getAction();

            if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,
                        BluetoothAdapter.ERROR);
                switch (state) {
                    case BluetoothAdapter.STATE_OFF:
                        new android.app.AlertDialog.Builder(MainActivity.this)
                            .setTitle("Bluetooth turned off")
                            .setMessage("Session stopped enable Bluetooth to record another one.")
                            .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    dialog.dismiss();
                                }
                            })
                            .setIcon(android.R.drawable.ic_dialog_alert)
                            .show();
                        updateTextView(connectionStatus, "Enable Bluetooth");

                        break;
                    case BluetoothAdapter.STATE_TURNING_OFF:
                        if (empaStatus == EmpaStatus.CONNECTED) {
                            //If a device is connected disconnect from it
                            deviceManager.disconnect();
                            updateTextView(connectedDevice, "-");
                            updateTextView(batteryLevel, "-");
                            bluetoothList.clear();
                            bluetoothAdapter.clear();
                        }
                        break;
                    case BluetoothAdapter.STATE_ON:
                        //initialize deviceManager when Blutetooth is turned on
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                new Handler().postDelayed(new Runnable() {
                                    @Override
                                    public void run() {
                                        deviceManager.authenticateWithAPIKey(EMPATICA_API_KEY);
                                    }
                                }, SCANNING_TIME/2);
                            }
                        });
                        break;
                    case BluetoothAdapter.STATE_TURNING_ON:

                        break;
                }
            }
        }
    }


    /**
     *EARLY WARNING SCORE VALUES
     * */

    private int getTempEWScore(float ewsvalue) {
        if (ewsvalue <= 35)
            return temp_score = 3;
        else if (ewsvalue > 39)
            return temp_score = 2;
        else if ((36 >= ewsvalue && ewsvalue > 35) || (39 >= ewsvalue && ewsvalue > 38))
            return temp_score = 1;
        else if (38 >= ewsvalue && ewsvalue > 36)
            return temp_score = 0;
        else {
            return temp_score = Integer.parseInt(null);
        }
    }

    private int getRREWScore(float ewsvalue){
        if(ewsvalue <= 8 )
            return rr_score=2;
        else if((ewsvalue == 9)|| (ewsvalue < 15))
            return rr_score = 0;
        else if ((ewsvalue == 15) || (ewsvalue < 20))
            return rr_score =1;
        else if ((ewsvalue == 21) || (ewsvalue<29))
            return rr_score = 2;
        else if ((ewsvalue == 30 ) || (ewsvalue > 30 ))
            return  rr_score =3;
        else{
            return rr_score = Integer.parseInt(null);
        }

    }

    private int getSBPEWScore(float ewsvalue) {
        if (ewsvalue >= 220 || ewsvalue <= 90)
            return sbp_score = 3;
        else if (100 >= ewsvalue && ewsvalue > 90)
            return sbp_score = 2;
        else if (110 >= ewsvalue && ewsvalue > 100)
            return sbp_score = 1;
        else if (220 > ewsvalue && ewsvalue > 110)
            return sbp_score = 0;
        else {
            return sbp_score = Integer.parseInt(null);
        }
    }

    private int getHREWScore (float ewsvalue){
        if((ewsvalue < 40) || (ewsvalue == 40))
            return hr_score = 3;
        else if((ewsvalue == 41) || ((ewsvalue > 41) && (ewsvalue < 50))|| (ewsvalue == 50))
            return hr_score = 1;
        else if((ewsvalue == 51) || ((ewsvalue > 51) && (ewsvalue < 90))|| (ewsvalue == 90))
            return hr_score =0;
        else if((ewsvalue == 91) || ((ewsvalue > 91) && (ewsvalue < 110))|| (ewsvalue == 110))
            return hr_score = 1;
        else if((ewsvalue == 111) || ((ewsvalue > 111) && (ewsvalue < 130))|| (ewsvalue == 130))
            return hr_score = 2;
        else if((ewsvalue == 131)||(ewsvalue > 131))
            return hr_score = 3;
        else{
            return hr_score = Integer.parseInt(null);
        }
    }

    private void setEWSValue(){
        int hr_last_score = 0;
        int temp_last_score = 0;
        int sbp_last_score = 0;
        int rr_last_score = 0;
        if(hrScores.size()>0) {
             hr_last_score = (int) hrScores.get(hrScores.size() - 1).getY();
        }
        if(tempScores.size()>0){
            temp_last_score = (int) tempScores.get(tempScores.size()-1).getY();
        }
        if(sbpScores.size()>0){
            sbp_last_score = (int) sbpScores.get(sbpScores.size()-1).getY();
        }
        if(rrScores.size()>0){
            rr_last_score = (int) rrScores.get(rrScores.size()-1).getY();
        }

        int total = hr_last_score + temp_last_score + sbp_last_score + rr_last_score;
        ewsScores.add(new Entry(ewsScores.size(),total));
    }

    private void setHistFiles(){
        Calendar calendar = Calendar.getInstance();
        ArrayList<String> dateStart = new ArrayList<>();
        dateStart.add(String.valueOf(calendar.get(Calendar.DAY_OF_MONTH) + "/" +(calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR)));
        dateStart.add(String.valueOf(calendar.get(Calendar.HOUR) + ":" +calendar.get(Calendar.MINUTE)));
        ArrayList<Float> minMaxMed = new ArrayList<>();
        if(save_hist>=5){
            save_hist=0;
            minMaxMed.clear();
            try {
                if(hrSamples.size()>0 && sbpSamples.size()>0 && rrSamples.size()>0 && tempSamples.size()>0){
                    minMaxMed.add(Collections.min(sbpHist));
                    minMaxMed.add(Collections.min(tempHist));
                    minMaxMed.add(Collections.min(hrHist));
                    minMaxMed.add(Collections.min(rrHist));
                    minMaxMed.add(Collections.max(sbpHist));
                    minMaxMed.add(Collections.max(tempHist));
                    minMaxMed.add(Collections.max(hrHist));
                    minMaxMed.add(Collections.max(rrHist));
                    File file = new File(path,"Historic_" + conductor + observed +
                            "_" + userID + ".csv");
                    if(!file.exists()){
                        Utility.writetoCSV(this, path, "Historic_" + conductor + observed +
                                "_" + userID + ".csv", dateStart.get(0) + "," + dateStart.get(1) + "," +
                                minMaxMed.get(0) + "," + minMaxMed.get(1) + "," + minMaxMed.get(2) + "," +
                                minMaxMed.get(3) + "," + minMaxMed.get(4) + "," + minMaxMed.get(5) + "," +
                                minMaxMed.get(6) + "," + minMaxMed.get(7));
                    }
                    else{
                        Utility.editCSV(path, "Historic_" + conductor + observed +
                                "_" + userID + ".csv", minMaxMed, dateStart);
                    }
                }
                dateStart.clear();

            }catch (ConcurrentModificationException e){

            }
        }
        save_hist++;
    }


}
