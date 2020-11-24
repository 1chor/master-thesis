package com.example.anwender.empaticae4.EWS;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.LineData;

import java.util.ConcurrentModificationException;

public class GraphSPO2 extends AppCompatActivity {

    private LineChart spo2Chart;
    private LineChart spo2Chart2;
    private TextView spo2ValueText;
    private TextView spo2ScoreText;
    float y_value;
    int playgraph=1;
    int spo2_last_value = 0;


    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_graph);
        spo2ValueText = (TextView) findViewById(R.id.graph_value);
        spo2ScoreText = (TextView) findViewById(R.id.graph_score);
        TextView spo2Text = (TextView) findViewById(R.id.graph_text_name);
        spo2Text.setText("SpO2");

        spo2Chart = (LineChart) findViewById(R.id.graph);
        spo2Chart.getDescription().setEnabled(false);
        spo2Chart.setTouchEnabled(true);
        spo2Chart.setDragEnabled(false);
        spo2Chart.setScaleEnabled(false);
        spo2Chart.setDrawGridBackground(false);
        spo2Chart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        spo2Chart.setData(data);

        // legend and axis
        Legend l = spo2Chart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = spo2Chart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = spo2Chart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(110);
        leftAxis.setAxisMinimum(50);

        YAxis rightAxis = spo2Chart.getAxisRight();
        rightAxis.setEnabled(false);

        spo2Chart2 = (LineChart) findViewById(R.id.graph2);
        spo2Chart2.getDescription().setEnabled(false);
        spo2Chart2.setTouchEnabled(true);
        spo2Chart2.setDragEnabled(false);
        spo2Chart2.setScaleEnabled(false);
        spo2Chart2.setDrawGridBackground(false);
        spo2Chart2.setBackgroundColor(Color.WHITE);

        LineData data2 = new LineData();
        data2.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        spo2Chart2.setData(data2);

        // legend and axis
        Legend l2 = spo2Chart2.getLegend();
        l2.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl2 = spo2Chart2.getXAxis();
        xl2.setTextColor(Color.parseColor("#C2185B"));
        xl2.setDrawGridLines(false);
        xl2.setAvoidFirstLastClipping(true);

        YAxis leftAxis2 = spo2Chart2.getAxisLeft();
        leftAxis2.setTextColor(Color.parseColor("#C2185B"));
        leftAxis2.setDrawGridLines(true);
        leftAxis2.setAxisMaximum(4);
        leftAxis2.setAxisMinimum(-1);

        YAxis rightAxis2 = spo2Chart2.getAxisRight();
        rightAxis2.setEnabled(false);

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HistInt = new Intent(GraphSPO2.this, Historical.class);
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
                while(playgraph==1) {

                    try {
                        if(GattOxi.OxiIsConnected){
                            spo2_last_value = ConnectOximeter.spo2Samples.size() - 1;
                            y_value = ConnectOximeter.spo2Samples.get(spo2_last_value).getY();

                            updateTextView(spo2ValueText,String.format("%.2f", y_value));
                            updateTextView(spo2ScoreText,String.valueOf((int) ConnectOximeter.spo2Scores.get(spo2_last_value).getY()));
                        }
                        else{
                            updateTextView(spo2ValueText,"--");
                            updateTextView(spo2ScoreText,"--");
                        }

                        if (ConnectOximeter.spo2Samples.size() != 0){
                            GetData.addEntry(spo2Chart,ConnectOximeter.spo2Samples,"SpO2 results"); //chart is notified on update in addEntry method
                            GetData.addEntry2(spo2Chart2,ConnectOximeter.spo2Scores,"SpO2 Score"); //chart is notified on update in addEntry method
                        }
                        Thread.sleep(1000);
                    } catch (InterruptedException | ConcurrentModificationException e) {
                        //manage error
                    }
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

