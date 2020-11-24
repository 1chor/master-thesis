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

public class GraphTemp extends AppCompatActivity {

    private LineChart tempChart;
    private LineChart temp2Chart;
    private TextView tempValueText;
    private TextView tempScoreText;
    float y_value;
    int playgraph=1;
    int temp_last_value = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_graph);
        tempValueText = (TextView) findViewById(R.id.graph_value);
        tempScoreText = (TextView) findViewById(R.id.graph_score);
        TextView tempText = (TextView) findViewById(R.id.graph_text_name);
        tempText.setText("T(ºC)");

        tempChart = (LineChart) findViewById(R.id.graph);
        tempChart.getDescription().setEnabled(false);
        tempChart.setTouchEnabled(true);
        tempChart.setDragEnabled(false);
        tempChart.setScaleEnabled(false);
        tempChart.setDrawGridBackground(false);
        tempChart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        tempChart.setData(data);

        // legend and axis
        Legend l = tempChart.getLegend();
        l.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl = tempChart.getXAxis();
        xl.setTextColor(Color.parseColor("#C2185B"));
        xl.setDrawGridLines(false);
        xl.setAvoidFirstLastClipping(true);

        YAxis leftAxis = tempChart.getAxisLeft();
        leftAxis.setTextColor(Color.parseColor("#C2185B"));
        leftAxis.setDrawGridLines(true);
        leftAxis.setAxisMaximum(50);
        leftAxis.setAxisMinimum(30);

        YAxis rightAxis = tempChart.getAxisRight();
        rightAxis.setEnabled(false);

        temp2Chart = (LineChart) findViewById(R.id.graph2);
        temp2Chart.getDescription().setEnabled(false);
        temp2Chart.setTouchEnabled(true);
        temp2Chart.setDragEnabled(false);
        temp2Chart.setScaleEnabled(false);
        temp2Chart.setDrawGridBackground(false);
        temp2Chart.setBackgroundColor(Color.WHITE);

        LineData data2 = new LineData();
        data2.setValueTextColor(Color.parseColor("#C2185B"));

        // add empty data
        temp2Chart.setData(data2);

        // legend and axis
        Legend l2 = temp2Chart.getLegend();
        l2.setTextColor(Color.parseColor("#C2185B"));

        XAxis xl2 = temp2Chart.getXAxis();
        xl2.setTextColor(Color.parseColor("#C2185B"));
        xl2.setDrawGridLines(false);
        xl2.setAvoidFirstLastClipping(true);

        YAxis leftAxis2 = temp2Chart.getAxisLeft();
        leftAxis2.setTextColor(Color.parseColor("#C2185B"));
        leftAxis2.setDrawGridLines(true);
        leftAxis2.setAxisMaximum(4);
        leftAxis2.setAxisMinimum(-1);

        YAxis rightAxis2 = temp2Chart.getAxisRight();
        rightAxis2.setEnabled(false);

        //Historical SPO2 button
        final Button Hist_button = (Button) findViewById(R.id.historical_button);
        Hist_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Intent HistInt = new Intent(GraphTemp.this, Historical.class);
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
                        if(MainActivity.sessionActive && MainActivity.tempSamples.size()>0){
                            temp_last_value = MainActivity.tempSamples.size() - 1;
                            y_value = MainActivity.tempSamples.get(temp_last_value).getY();

                            updateTextView(tempValueText,String.format("%.2f", y_value));
                            updateTextView(tempScoreText,String.valueOf((int) MainActivity.tempScores.get(temp_last_value).getY()));
                        }
                        else{
                            updateTextView(tempValueText,"--");
                            updateTextView(tempScoreText,"--");
                        }

                        if(MainActivity.tempSamples.size() != 0){
                            GetData.addEntry(tempChart, MainActivity.tempSamples,"Temperature Results"); //chart is notified on update in addEntry method
                            GetData.addEntry2(temp2Chart, MainActivity.tempScores,"Temperature Score"); //chart is notified on update in addEntry method
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

