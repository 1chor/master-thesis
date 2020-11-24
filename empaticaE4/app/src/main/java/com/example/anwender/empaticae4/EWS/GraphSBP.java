package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 13/11/2017.
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


public class GraphSBP extends AppCompatActivity {

    private LineChart sbpChart;
    private LineChart sbp2Chart;
    private TextView sbpValueText;
    private TextView sbpScoreText;
    float y_value;
    int playgraph=1;
    int sbp_last_value = 0;

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_graph);
        sbpValueText = (TextView) findViewById(R.id.graph_value);
        sbpScoreText = (TextView) findViewById(R.id.graph_score);
        TextView sbpText = (TextView) findViewById(R.id.graph_text_name);
        sbpText.setText("mmHG");

        sbpChart = (LineChart) findViewById(R.id.graph);
        sbpChart.getDescription().setEnabled(false);
        sbpChart.setTouchEnabled(true);
        sbpChart.setDragEnabled(false);
        sbpChart.setScaleEnabled(false);
        sbpChart.setDrawGridBackground(false);
        sbpChart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        sbpChart.setData(data);

        // legend and axis
        Legend l = sbpChart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = sbpChart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = sbpChart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(220);
        leftAxis.setAxisMinimum(70);

        YAxis rightAxis = sbpChart.getAxisRight();
        rightAxis.setEnabled(false);

        sbp2Chart = (LineChart) findViewById(R.id.graph2);
        sbp2Chart.getDescription().setEnabled(false);
        sbp2Chart.setTouchEnabled(true);
        sbp2Chart.setDragEnabled(false);
        sbp2Chart.setScaleEnabled(false);
        sbp2Chart.setDrawGridBackground(false);
        sbp2Chart.setBackgroundColor(Color.WHITE);

        LineData data2 = new LineData();
        data2.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        sbp2Chart.setData(data2);

        // legend and axis
        Legend l2 = sbp2Chart.getLegend();
        l2.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl2 = sbp2Chart.getXAxis();
        xl2.setTextColor(Color.parseColor("#C2185B"));
        xl2.setDrawGridLines(false);
        xl2.setAvoidFirstLastClipping(true);

        YAxis leftAxis2 = sbp2Chart.getAxisLeft();
        leftAxis2.setTextColor(Color.parseColor("#C2185B"));
        leftAxis2.setDrawGridLines(true);
        leftAxis2.setAxisMaximum(4);
        leftAxis2.setAxisMinimum(-1);

        YAxis rightAxis2 = sbp2Chart.getAxisRight();
        rightAxis2.setEnabled(false);

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HistInt = new Intent(GraphSBP.this, Historical.class);
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
                        if(MainActivity.sessionActive && MainActivity.sbpSamples.size()>0){
                            sbp_last_value = MainActivity.sbpSamples.size() - 1;
                            y_value = MainActivity.sbpSamples.get(sbp_last_value).getY();

                            updateTextView(sbpValueText,String.format("%.2f", y_value));
                            updateTextView(sbpScoreText,String.valueOf((int) MainActivity.sbpScores.get(sbp_last_value).getY()));
                        }
                        else{
                            updateTextView(sbpValueText,"--");
                            updateTextView(sbpScoreText,"--");
                        }

                        if (MainActivity.sbpSamples.size() !=0){
                            GetData.addEntry(sbpChart, MainActivity.sbpSamples, "SBP results"); //chart is notified on update in addEntry method
                            GetData.addEntry2(sbp2Chart, MainActivity.sbpScores,"SBP Score"); //chart is notified on update in addEntry method
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



