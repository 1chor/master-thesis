package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 13/11/2017.
 */

import android.graphics.Color;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet;

import java.util.ArrayList;
import java.util.List;

final class GetData {

    static void addEntry(LineChart ChartShown, List<Entry> graph_values, String results) {

        LineDataSet setGraph = new LineDataSet(graph_values, results);

        setGraph.setColor(Color.parseColor("#0288D1"));
        setGraph.setDrawCircles(false);
        setGraph.setDrawValues(false);
        setGraph.setAxisDependency(YAxis.AxisDependency.LEFT);
        List<ILineDataSet> dataSets = new ArrayList<>();
        dataSets.add(setGraph);
        LineData data = new LineData(dataSets);

        ChartShown.getXAxis().setValueFormatter(new IndexAxisValueFormatter(ConnectOximeter.XGraphValues));
        ChartShown.setData(data);

        ChartShown.notifyDataSetChanged();
        ChartShown.setVisibleXRange(20, 100);
        ChartShown.moveViewToX(data.getEntryCount()); //move to the last value
    }


    static void addEntry2(LineChart ChartShown2, List<Entry> graph_values2, String results2) {

        LineDataSet setGraph2 = new LineDataSet(graph_values2, results2);

        setGraph2.setColor(Color.parseColor("#0288D1"));
        setGraph2.setDrawCircles(false);
        setGraph2.setDrawValues(false);
        setGraph2.setAxisDependency(YAxis.AxisDependency.LEFT);
        List<ILineDataSet> dataSets2 = new ArrayList<>();
        dataSets2.add(setGraph2);
        LineData data2 = new LineData(dataSets2);

        ChartShown2.getXAxis().setValueFormatter(new IndexAxisValueFormatter(ConnectOximeter.XGraphValues));
        ChartShown2.setData(data2);

        ChartShown2.notifyDataSetChanged();
        ChartShown2.setVisibleXRange(20, 100);
        ChartShown2.moveViewToX(data2.getEntryCount()); //move to the last value
    }
}