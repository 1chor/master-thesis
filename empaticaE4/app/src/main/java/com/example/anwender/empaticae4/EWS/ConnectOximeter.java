package com.example.anwender.empaticae4.EWS;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;
import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.data.Entry;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.ConcurrentModificationException;
import java.util.List;

public class ConnectOximeter extends AppCompatActivity {

    public static final int REQUEST_ENABLE_BT = 1;

    static public TextView oxi_Name;
    private TextView oxi_Status;
    private Button  oxi_Connect;

    private ScanOxi BTNoninScanner;

    static public List<Entry> spo2Samples = new ArrayList<>();
    static public List<Entry> hrSamples = new ArrayList<>();
    static public List<Entry> spo2Scores = new ArrayList<>();
    static public List<Entry> hrScores = new ArrayList<>();
    static public List<Float> spo2Hist = new ArrayList<>();
    static public List<Float> hrHist = new ArrayList<>();
    static public List<Integer> spo2HistScore = new ArrayList<>();
    static public List<Integer> hrHistScores = new ArrayList<>();
    ArrayList<Float> minMaxMed = new ArrayList<>();
    int save_hist = 5;
    private boolean flagHR;

    int temp_score;
    int sbp_score;
    int hr_score;
    int spo2_score;
    int ews_score;
    int temp_last_value = 0;
    int sbp_last_value = 0;
    static public List<Entry> ewsScores = new ArrayList<>();
    static public ArrayList<String> XGraphValues = new ArrayList<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_connect_oximeter);

        BTNoninScanner = new ScanOxi(this, 5000, -75);

        oxi_Name = (TextView) findViewById(R.id.text_oxi_name);
        oxi_Status = (TextView) findViewById(R.id.text__oxi_status);
        TextView oxi_ID = (TextView) findViewById(R.id.text_oxi_ID_number);
        oxi_ID.setText(MainActivity.userID);

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

        //EWS Score button
        final Button EWSScore_button = (Button) findViewById(R.id.oxi_continue_button);
        EWSScore_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent EWSScore = new Intent(ConnectOximeter.this, com.example.anwender.empaticae4.EWS.EWSScore.class);
                startActivity(EWSScore);
            }
        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_ENABLE_BT) {
            // Make sure the request was successful
            if (resultCode == RESULT_CANCELED)
                Utility.toastie(getApplicationContext(), "Please turn on Bluetooth");
        }
    }

    public void updateData(byte[] data){
        String observed = "0";
        String conductor = "00";

        oxi_Connect.setClickable(false);
        oxi_Connect.setEnabled(false);
        oxi_Connect.setVisibility(View.GONE);
        oxi_Status.setText("Connected");


        //SpO2 corresponds to the seventh value of the byte, 127 means error getting the data
        float spO = data[7];
        if(spO != 127 && spO >= 0) {
            Utility.writetoCSV(this, MainActivity.sessionPath, "SPO2_Nonin3230_" + conductor + observed + "_" + MainActivity.startTime + "_" + MainActivity.userID +".csv", Float.toString(spO) + '\n');
            spo2Samples.add(new Entry(MainActivity.timestp,spO));
            spo2Scores.add(new Entry(MainActivity.timestp,getSPO2EWScore(spO)));
            spo2Hist.add(spO);
            spo2HistScore.add(getSPO2EWScore(spO));
        }

        //Heart Rate corresponds to the eighth and nineth value of the byte, 511 means error getting the data
        float heartrate = (data[8] << 8) | data[9];
        if(heartrate != 511 && heartrate >= 0 )        {
            if( !flagHR ){
                Utility.writetoCSV(this, MainActivity.sessionPath, "HR_Nonin3230_" + conductor + observed + "_" + MainActivity.startTime
                        + "_" + MainActivity.userID +".csv", Float.toString(MainActivity.sbpSamples.size()-2)  + '\n' );
                flagHR=true;
            }
            Utility.writetoCSV(this, MainActivity.sessionPath, "HR_Nonin3230_" + conductor + observed + "_" + MainActivity.startTime + "_" + MainActivity.userID +".csv", Float.toString(heartrate) + '\n');
            hrSamples.add(new Entry (MainActivity.timestp,heartrate));
            hrScores.add(new Entry(MainActivity.timestp,getHREWScore(heartrate)));
            hrHist.add(heartrate);
            hrHistScores.add(getHREWScore(heartrate));
        }

        //Getting the last score values for each measure, and calculating the absolute value
        temp_last_value = MainActivity.tempScores.size() - 1;
        temp_score =(int) MainActivity.tempScores.get(temp_last_value).getY();
        sbp_last_value = MainActivity.sbpScores.size() - 1;
        sbp_score = (int) MainActivity.sbpScores.get(sbp_last_value).getY();

        ews_score = sbp_score + temp_score + spo2_score + hr_score;
        ewsScores.add(new Entry(MainActivity.timestp,ews_score));

        Calendar calendar=Calendar.getInstance();
        XGraphValues.add(String.valueOf(calendar.get(Calendar.HOUR)) + ":" + String.valueOf(calendar.get(Calendar.MINUTE)) +
                ":" + String.valueOf(calendar.get(Calendar.SECOND)));

        // Main Data updated each 5 iterations.
        if (save_hist >= 5) {
            save_hist = 0;
            minMaxMed.clear();
            try{
                if((MainActivity.sbpSamples.size() > 0 && MainActivity.tempSamples.size() > 0) &&
                        (ConnectOximeter.hrSamples.size() > 0 && ConnectOximeter.spo2Samples.size() > 0)){
                    minMaxMed.add(Collections.min(MainActivity.sbpHist));
                    minMaxMed.add(Collections.min(MainActivity.tempHist));
                    minMaxMed.add(Collections.min(ConnectOximeter.hrHist));
                    minMaxMed.add(Collections.min(ConnectOximeter.spo2Hist));
                    minMaxMed.add(Collections.max(MainActivity.sbpHist));
                    minMaxMed.add(Collections.max(MainActivity.tempHist));
                    minMaxMed.add(Collections.max(ConnectOximeter.hrHist));
                    minMaxMed.add(Collections.max(ConnectOximeter.spo2Hist));

                    File file = new File(MainActivity.path,"Historic_" + conductor + observed +
                            "_" + MainActivity.userID + ".csv");
                    if(!file.exists()){
                        Utility.writetoCSV(this, MainActivity.path, "Historic_" + conductor + observed +
                                "_" + MainActivity.userID + ".csv", ScanOxi.dateStart.get(0) + "," + ScanOxi.dateStart.get(1) + "," +
                                minMaxMed.get(0) + "," + minMaxMed.get(1) + "," + minMaxMed.get(2) + "," +
                                minMaxMed.get(3) + "," + minMaxMed.get(4) + "," + minMaxMed.get(5) + "," +
                                minMaxMed.get(6) + "," + minMaxMed.get(7));
                    }
                    else{
                        Utility.editCSV(MainActivity.path, "Historic_" + conductor + observed +
                                "_" + MainActivity.userID + ".csv", minMaxMed, ScanOxi.dateStart);
                    }
                }
            }
            catch (ConcurrentModificationException e){
                //manage error
            }
        }
        save_hist++;
    }

    @SuppressLint("SetTextI18n")
    public void stopEverything(){
        BTNoninScanner.stop();
        oxi_Status.setText("Oximeter not found");
        oxi_Connect.setClickable(true);
        oxi_Connect.setEnabled(true);
        oxi_Connect.setVisibility(View.VISIBLE);
    }

    //EARLY WARNING SCORE VALUES

    //HR CORRESPONDING VALUE
    private int getHREWScore(float ewsvalue) {
        if (ewsvalue > 130 || ewsvalue <= 40)
            return hr_score = 3;
        else if (130 >= ewsvalue && ewsvalue > 110)
            return hr_score = 2;
        else if ((110 >= ewsvalue && ewsvalue > 90) || (50 > ewsvalue && ewsvalue > 40))
            return hr_score = 1;
        else if (90 >= ewsvalue && ewsvalue >= 50)
            return hr_score = 0;
        else {
            return hr_score = Integer.parseInt(null);
        }
    }

    //SPO2 CORRESPONDING VALUE
    private int getSPO2EWScore(float ewsvalue) {
        if (ewsvalue < 92)
            return spo2_score = 3;
        else if (94 > ewsvalue && ewsvalue >=92)
            return spo2_score = 2;
        else if (95 >= ewsvalue && ewsvalue >= 94)
            return spo2_score = 1;
        else if (ewsvalue > 95)
            return spo2_score = 0;
        else {
            return spo2_score = Integer.parseInt(null);
        }
    }
}