package com.example.anwender.empaticae4.EWS;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.LineData;


/*
  Created by angel on 13/11/2017.
 */

public class EWSScore extends AppCompatActivity {

    private LineChart ewsChart;
    private TextView ewsValueText;
    private TextView sbpValueText;
    private TextView tempValueText;
    private TextView hrValueText;
    private TextView spoValueText;
    private TextView rrValueText;
    int temp_score;
    int sbp_score;
    int hr_score;
    int spo2_score;
    int rr_score;
    int ews_score;
    int playgraph = 1;
    int temp_last_value = 0;
    int sbp_last_value = 0;
    int spo2_last_value = 0;
    int hr_last_value = 0;
    int ews_last_value = 0;
    int rr_last_value=0;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ews_score);
        ewsValueText = (TextView) findViewById(R.id.ews_value);
        sbpValueText = (TextView) findViewById(R.id.ews_sbp_value);
        tempValueText = (TextView) findViewById(R.id.ews_temp_value);
        hrValueText = (TextView) findViewById(R.id.ews_hr_value);
        spoValueText = (TextView) findViewById(R.id.ews_oxi_value);
        rrValueText = (TextView) findViewById(R.id.ews_rr_value);

        ewsChart = (LineChart) findViewById(R.id.ews_graph);

        ewsChart.getDescription().setEnabled(false);
        ewsChart.setTouchEnabled(true);
        ewsChart.setPinchZoom(true);
        ewsChart.setDragEnabled(false);
        ewsChart.setScaleEnabled(false);
        ewsChart.setDrawGridBackground(false);
        ewsChart.setBackgroundColor(Color.WHITE);



        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        ewsChart.setData(data);

        // legend and axis
        Legend l = ewsChart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = ewsChart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = ewsChart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(20);
        leftAxis.setAxisMinimum(0);

        YAxis rightAxis = ewsChart.getAxisRight();
        rightAxis.setEnabled(false);

        //SPO2 GRAPH BUTTON
        final Button SPO2_Graph_button = (Button) findViewById(R.id.spo2_button);
        SPO2_Graph_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent SPO2Graph = new Intent(EWSScore.this, GraphSPO2.class);
                startActivity(SPO2Graph);
            }
        });

        //SBP GRAPH BUTTON
        final Button SBP_Graph_button = (Button) findViewById(R.id.sbp_button);
        SBP_Graph_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent SBPGraph = new Intent(EWSScore.this, GraphSBP.class);
                startActivity(SBPGraph);
            }
        });

        //TEMPERATURE GRAPH BUTTON
        final Button Temp_Graph_button = (Button) findViewById(R.id.temperature_button);
        Temp_Graph_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent TempGraph = new Intent(EWSScore.this, GraphTemp.class);
                startActivity(TempGraph);
            }
        });

        //HEART RATE GRAPH BUTTON
        final Button HR_Graph_button = (Button) findViewById(R.id.heart_rate_button);
        HR_Graph_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HRGraph = new Intent(EWSScore.this, GraphHR.class);
                startActivity(HRGraph);
            }
        });
        //RR
        final Button RR_Graph_button = (Button) findViewById(R.id.respiratory_rate_button);
        RR_Graph_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent RRGraph = new Intent(EWSScore.this, GraphRR.class);
                startActivity(RRGraph);
            }
        });

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.EWS_historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                    final Intent HistInt = new Intent(EWSScore.this, Historical.class);
                    startActivity(HistInt);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();

        new Thread(new Runnable() {
            @Override
            public void run() {

                while (playgraph==1) {
                    try {
                        if (MainActivity.sessionActive && MainActivity.sbpSamples.size() > 0){
                            temp_last_value = MainActivity.tempScores.size() - 1;
                            temp_score =(int) MainActivity.tempScores.get(temp_last_value).getY();
                            updateTextView(tempValueText,String.valueOf(temp_score));

                            sbp_last_value = MainActivity.sbpScores.size() - 1;
                            sbp_score = (int) MainActivity.sbpScores.get(sbp_last_value).getY();
                            updateTextView(sbpValueText,String.valueOf(sbp_score));
                        }
                        else{
                            updateTextView(tempValueText,"--");
                            updateTextView(sbpValueText,"--");
                        }

                        if(GattOxi.OxiIsConnected && ConnectOximeter.spo2Samples.size() > 0){
                            spo2_last_value = ConnectOximeter.spo2Scores.size() - 1;
                            spo2_score =(int) ConnectOximeter.spo2Scores.get(spo2_last_value).getY();
                            updateTextView(spoValueText,String.valueOf(spo2_score));

                            hr_last_value = ConnectOximeter.hrScores.size() - 1;
                            hr_score = (int) ConnectOximeter.hrScores.get(hr_last_value).getY();
                            updateTextView(hrValueText,String.valueOf(hr_score));
                        }
                        else{
                            updateTextView(spoValueText,"--");
                            updateTextView(hrValueText,"--");
                        }
                        if(!GattOxi.OxiIsConnected && MainActivity.hrScores.size()>0){
                            hr_last_value = MainActivity.hrScores.size()-1;
                            hr_score = (int) MainActivity.hrScores.get(hr_last_value).getY();
                            updateTextView(hrValueText,String.valueOf(hr_score));
                        }
                        else {
                            updateTextView(hrValueText,"--");
                        }

                        if((MainActivity.sessionActive) && (MainActivity.rrSamples.size()>0)){
                            rr_last_value = MainActivity.rrScores.size()-1;
                            rr_score = (int)MainActivity.rrScores.get(rr_last_value).getY();
                            updateTextView(rrValueText,String.valueOf(rr_score));
                        }

                        else{
                            updateTextView(rrValueText,"--");
                        }

                        if ((GattOxi.OxiIsConnected && MainActivity.sessionActive) &&
                                (ConnectOximeter.spo2Samples.size() > 0 && MainActivity.sbpSamples.size() > 0)){
                            ews_last_value = ConnectOximeter.ewsScores.size() - 1;
                            ews_score = (int) ConnectOximeter.ewsScores.get(ews_last_value).getY();
                            updateTextView(ewsValueText,String.valueOf(ews_score));
                            GetData.addEntry(ewsChart, ConnectOximeter.ewsScores,"EWS Sum"); //chart is notified on update in addEntry method
                        }
                        if(!GattOxi.OxiIsConnected && MainActivity.sessionActive && MainActivity.ewsScores.size()>0){
                            ews_last_value = MainActivity.ewsScores.size() -1;
                            ews_score = (int) MainActivity.ewsScores.get(ews_last_value).getY();
                            updateTextView(ewsValueText,String.valueOf(ews_score));
                            GetData.addEntry(ewsChart, MainActivity.ewsScores,"EWS Sum");
                        }
                        else
                        {
                            updateTextView(ewsValueText,"--");
                        }

                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        //manage error
                    }
                }
            }
        }).start();
    }

    private void updateTextView(final TextView id, final String text) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                id.setText(text);
            }
        });
    }
}

