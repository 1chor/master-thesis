package com.example.anwender.empaticae4.EWS;

/*
 * Created by angel on 15/11/2017.
 */

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.widget.CalendarView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.anwender.empaticae4.Main.MainActivity;
import com.example.anwender.empaticae4.Main.Utility;
import com.example.anwender.empaticae4.R;

public class Historical extends AppCompatActivity {

    private static final int REQUEST_PERMISSION_READ_EXTERNAL_STORAGE = 3;
    private final String conductor = "00"; //00 for server
    private final String observed = "0";  //0 = not observed, 1 = observed
    CalendarView histCalendar;
    private TextView histTitleText;
    private TextView histValueText;
    private String textValue;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_historical_values);

        histCalendar = (CalendarView) findViewById(R.id.calendar);
        histTitleText = (TextView) findViewById(R.id.historicalTitle_text);
        histValueText = (TextView) findViewById(R.id.historicalValues_text);

        // Confirm permissions have not stop being allowed.
        checkExternalStorageReadPermissions();

        // Look for data available on the selected date
        histCalendar.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @SuppressLint("SetTextI18n")
            @Override
            public void onSelectedDayChange(@NonNull CalendarView calendarView, int year, int month, int day) {

                String date_clicked = day + "/" + (month + 1) + "/" + year;
                histTitleText.setText("Date pressed: " + date_clicked);
                textValue = Utility.scanCSV(MainActivity.path, "Historic_" + conductor + observed + "_" + MainActivity.userID +".csv", date_clicked);
                if (textValue.equals(""))
                    histValueText.setText("No data available.");
                else
                    histValueText.setText(textValue);
            }
            });
    }

    @Override
    protected void onPause() {
        super.onPause();
        finish();
    }

    public void checkExternalStorageReadPermissions() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)
            Utility.toastie(this, "Read Allowed");
        else {
            explainPermissionUsage();
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    REQUEST_PERMISSION_READ_EXTERNAL_STORAGE);
        }
    }

    private void explainPermissionUsage() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
            Toast.makeText(this, "This permission is needed for LOADING data", Toast.LENGTH_SHORT).show();
            // Explain why the permission is requested
            basicAlertDialog();
        }
    }

    public void basicAlertDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage("Permission required for running the app normally");
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {

            }
        });
        builder.show();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case REQUEST_PERMISSION_READ_EXTERNAL_STORAGE:
                if (grantResults.length <= 0 || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "App will not run properly", Toast.LENGTH_SHORT).show();
                }
        }
    }
}
