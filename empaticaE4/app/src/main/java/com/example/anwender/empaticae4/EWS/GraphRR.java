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

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.R;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.LineData;

import java.util.ConcurrentModificationException;

public class GraphRR extends AppCompatActivity {
    private LineChart rrChart;
    private LineChart rr2Chart;
    private TextView rrValueText;
    private TextView rrScoreText;
    double y_value;
    int playgraph=1;
    int rr_last_value = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_graph);
        rrValueText = (TextView) findViewById(R.id.graph_value);
        rrScoreText = (TextView) findViewById(R.id.graph_score);
        TextView tempText = (TextView) findViewById(R.id.graph_text_name);
        tempText.setText("BPM");

        rrChart = (LineChart) findViewById(R.id.graph);
        rrChart.getDescription().setEnabled(false);
        rrChart.setTouchEnabled(true);
        rrChart.setDragEnabled(false);
        rrChart.setScaleEnabled(false);
        rrChart.setDrawGridBackground(false);
        rrChart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        rrChart.setData(data);

        // legend and axis
        Legend l = rrChart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = rrChart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = rrChart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(60);
        leftAxis.setAxisMinimum(0);

        YAxis rightAxis = rrChart.getAxisRight();
        rightAxis.setEnabled(false);

        rr2Chart = (LineChart) findViewById(R.id.graph2);
        rr2Chart.getDescription().setEnabled(false);
        rr2Chart.setTouchEnabled(true);
        rr2Chart.setDragEnabled(false);
        rr2Chart.setScaleEnabled(false);
        rr2Chart.setDrawGridBackground(false);
        rr2Chart.setBackgroundColor(Color.WHITE);

        LineData data2 = new LineData();
        data2.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        rr2Chart.setData(data2);

        // legend and axis
        Legend l2 = rr2Chart.getLegend();
        l2.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl2 = rr2Chart.getXAxis();
        xl2.setTextColor(Color.parseColor("#C2185B"));
        xl2.setDrawGridLines(false);
        xl2.setAvoidFirstLastClipping(true);

        YAxis leftAxis2 = rr2Chart.getAxisLeft();
        leftAxis2.setTextColor(Color.parseColor("#C2185B"));
        leftAxis2.setDrawGridLines(true);
        leftAxis2.setAxisMaximum(4);
        leftAxis2.setAxisMinimum(-1);

        YAxis rightAxis2 = rr2Chart.getAxisRight();
        rightAxis2.setEnabled(false);

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HistInt = new Intent(GraphRR.this, Historical.class);
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
                //add 50000 entries

                while(playgraph==1) {
                    try {
                        if(MainActivity.sessionActive && MainActivity.rrSamples.size()>0){
                            rr_last_value = MainActivity.rrSamples.size() - 1;
                            y_value = MainActivity.rrSamples.get(rr_last_value).getY();

                            updateTextView(rrValueText,String.format("%.2f", y_value));
                            updateTextView(rrScoreText,String.valueOf(MainActivity.rrScores.get(rr_last_value).getY()));
                        }
                        else{
                            updateTextView(rrValueText,"--");
                            updateTextView(rrScoreText,"--");
                        }

                        if(MainActivity.rrSamples.size() != 0){
                            //TODO Cayetano outcommented this part due to an incompatibility
                            GetData.addEntry(rrChart, MainActivity.rrSamples,"Respiratory Rate Results"); //chart is notified on update in addEntry method
                            GetData.addEntry2(rr2Chart, MainActivity.rrScores,"Respiratory Rate Score"); //chart is notified on update in addEntry method
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
