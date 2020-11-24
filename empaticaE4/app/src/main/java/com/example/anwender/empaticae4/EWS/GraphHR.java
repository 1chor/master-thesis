package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 28/12/2017.
 */

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.LineData;

import java.util.ConcurrentModificationException;

public class GraphHR extends AppCompatActivity {

    private LineChart hrChart;
    private LineChart hr2Chart;
    private TextView hrValueText;
    private TextView hrScoreText;
    float y_value;
    int playgraph=1;
    int hr_last_value = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_graph);
        hrValueText = (TextView) findViewById(R.id.graph_value);
        hrScoreText = (TextView) findViewById(R.id.graph_score);
        TextView hrText = (TextView) findViewById(R.id.graph_text_name);
        updateTextView(hrText,"bpm");

        hrChart = (LineChart) findViewById(R.id.graph);
        hrChart.getDescription().setEnabled(false);
        hrChart.setTouchEnabled(true);
        hrChart.setDragEnabled(false);
        hrChart.setScaleEnabled(false);
        hrChart.setDrawGridBackground(false);
        hrChart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        hrChart.setData(data);

        // legend and axis
        Legend l = hrChart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = hrChart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = hrChart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(140);
        leftAxis.setAxisMinimum(30);

        YAxis rightAxis = hrChart.getAxisRight();
        rightAxis.setEnabled(false);

        hr2Chart = (LineChart) findViewById(R.id.graph2);
        hr2Chart.getDescription().setEnabled(false);
        hr2Chart.setTouchEnabled(true);
        hr2Chart.setDragEnabled(false);
        hr2Chart.setScaleEnabled(false);
        hr2Chart.setDrawGridBackground(false);
        hr2Chart.setBackgroundColor(Color.WHITE);

        LineData data2 = new LineData();
        data2.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        hr2Chart.setData(data2);

        // legend and axis
        Legend l2 = hr2Chart.getLegend();
        l2.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl2 = hr2Chart.getXAxis();
        xl2.setTextColor(Color.parseColor("#C2185B"));
        xl2.setDrawGridLines(false);
        xl2.setAvoidFirstLastClipping(true);

        YAxis leftAxis2 = hr2Chart.getAxisLeft();
        leftAxis2.setTextColor(Color.parseColor("#C2185B"));
        leftAxis2.setDrawGridLines(true);
        leftAxis2.setAxisMaximum(4);
        leftAxis2.setAxisMinimum(-1);

        YAxis rightAxis2 = hr2Chart.getAxisRight();
        rightAxis2.setEnabled(false);

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HistInt = new Intent(GraphHR.this, Historical.class);
                startActivity(HistInt);
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();

        new Thread(new Runnable() {
            @SuppressLint("DefaultLocale")
            @Override
            public void run() {
                while(playgraph==1) try {
                    if (GattOxi.OxiIsConnected) {
                        hr_last_value = ConnectOximeter.hrSamples.size() - 1;
                        y_value = ConnectOximeter.hrSamples.get(hr_last_value).getY();

                        updateTextView(hrValueText, String.format("%.2f", y_value));
                        updateTextView(hrScoreText, String.valueOf((int) ConnectOximeter.hrScores.get(hr_last_value).getY()));
                    }
                    else if(MainActivity.sessionActive && !GattOxi.OxiIsConnected && MainActivity.hrSamples.size()!=0){
                        hr_last_value = MainActivity.hrSamples.size()-1;
                        y_value = MainActivity.hrSamples.get(hr_last_value).getY();

                        updateTextView(hrValueText, String.format("%.2f", y_value));
                        updateTextView(hrScoreText, String.valueOf((int) MainActivity.hrScores.get(hr_last_value).getY()));
                    }
                    else {
                        updateTextView(hrValueText, "--");
                        updateTextView(hrScoreText, "--");
                    }

                    if (ConnectOximeter.hrSamples.size() != 0) {
                        GetData.addEntry(hrChart, ConnectOximeter.hrSamples, "Heart Rate results"); //chart is notified on update in addEntry method
                        GetData.addEntry2(hr2Chart, ConnectOximeter.hrScores, "Heart Rate Score"); //chart is notified on update in addEntry method
                    }

                    else if ((MainActivity.hrSamples.size() != 0)&&(!GattOxi.OxiIsConnected)) {
                        GetData.addEntry(hrChart, MainActivity.hrSamples, "Heart Rate results"); //chart is notified on update in addEntry method
                        GetData.addEntry2(hr2Chart, MainActivity.hrScores, "Heart Rate Score"); //chart is notified on update in addEntry method
                    }
                    Thread.sleep(1000);
                } catch (InterruptedException | ConcurrentModificationException e) {
                    //manage error
                }
            }
        }) .start();
    }

    @Override
    protected void onStop() {
        super.onStop();
        playgraph=0;
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        playgraph=1;
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