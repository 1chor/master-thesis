package com.example.anwender.empaticae4.Main;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.TimePicker;

import com.example.anwender.empaticae4.R;

import java.io.File;
import java.util.Calendar;
import java.util.Locale;

public class LogEmotionActivity extends AppCompatActivity {

    private static final String LOG_TAG = TagEmotion.class.getSimpleName();;  //debug purposes
    private final String filenameTag = "LogEmotion.csv";   //Name of the file where tags will be stored
    private File path;  //Location where file will be stored
    private String sIntensity;
    private String sEmotion;
    private String sConfidence;
    long unixTime;
    private String date;
    private String start_time;
    private String end_time;

    private TextView View_date;
    private TextView View_start;
    private TextView View_end;
    private DatePickerDialog.OnDateSetListener DateSetListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_log_emotion);

        path = (File) getIntent().getExtras().get("sessionPath");

        //Spinner for emotions
        Spinner spinner = (Spinner) findViewById(R.id.spinner_emotion);  // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.array_emotions, android.R.layout.simple_spinner_item);  // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            //Avoid Event through initialization
            int check = 0;
            @Override
            public void onItemSelected(AdapterView<?> arg0, View arg1, int position, long id) {
                if (++check > 1) {
                    sEmotion=arg0.getItemAtPosition(position).toString();
                }
            }
            @Override
            public void onNothingSelected(AdapterView<?> arg0) {

            }
        });

        //Intensity Seekbar
        SeekBar skb_intensity = (SeekBar) findViewById(R.id.seekBar_intensity);
        skb_intensity.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress,boolean fromUser) {
                sIntensity=String.valueOf(++progress);
            }
        });

        //Confidence Seekbar
        SeekBar skb_confidence = (SeekBar) findViewById(R.id.seekBar_confidence);
        skb_confidence.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress,boolean fromUser) {
                //adjust 0-9 scal to 1-10 with ++
                sConfidence=String.valueOf(++progress);
            }
        });

        //Date TextView
        View_date = (TextView) findViewById(R.id.text_date);

        //Date Button
        Button button_date = (Button) findViewById(R.id.button_date);
        button_date.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Calendar calendar = Calendar.getInstance();
                int year = calendar.get(Calendar.YEAR);
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog dialog = new DatePickerDialog(
                        LogEmotionActivity.this,
                        android.R.style.Theme_Holo_Light_Dialog_MinWidth,
                        DateSetListener,
                        year,month,day);
                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                dialog.show();

            }
        });

        //Override to change Date Format
        DateSetListener = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker datePicker, int year, int month, int day) {
                month = month + 1;
                Log.d(LOG_TAG, "onDateSet: mm/dd/yyy: " + day + "/" + month + "/" + year);

                date =   year + "/" + String.format(Locale.getDefault(),"%02d", month) + "/" + String.format(Locale.getDefault(),"%02d", day);
                View_date.setText(date);
            }
        };

        //Start TextView
        View_start = (TextView) findViewById(R.id.text_start_time);

        //Start Button
        Button button_start = (Button) findViewById(R.id.button_start_time);
        button_start.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Calendar timeCalendar = Calendar.getInstance();
                int hour = timeCalendar.get(Calendar.HOUR_OF_DAY);
                int minute = timeCalendar.get(Calendar.MINUTE);
                TimePickerDialog timePicker = new TimePickerDialog(
                        LogEmotionActivity.this,
                        android.R.style.Theme_Holo_Light_Dialog_MinWidth, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker timePicker, int selectedHour, int selectedMinute) {
                        View_start.setText( String.format(Locale.getDefault(), "%02d:%02d", selectedHour, selectedMinute));
                        start_time = String.format(Locale.getDefault(), "%02d:%02d", selectedHour, selectedMinute);
                    }
                }, hour, minute, true);//True for 24h format
                timePicker.setTitle("Select Start Time");
                timePicker.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                timePicker.show();
            }
        });

        //End time TextView
        View_end = (TextView) findViewById(R.id.text_end_time);

        //End time Button
        Button button_end = (Button) findViewById(R.id.button_end_time);
        button_end.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Calendar timeCalendar = Calendar.getInstance();
                int hour = timeCalendar.get(Calendar.HOUR_OF_DAY);
                int minute = timeCalendar.get(Calendar.MINUTE);
                TimePickerDialog timePicker = new TimePickerDialog(
                        LogEmotionActivity.this,
                        android.R.style.Theme_Holo_Light_Dialog_MinWidth, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker timePicker, int selectedHour, int selectedMinute) {
                        View_end.setText( String.format(Locale.getDefault(), "%02d:%02d", selectedHour, selectedMinute));
                        end_time = String.format(Locale.getDefault(), "%02d:%02d", selectedHour, selectedMinute);
                    }
                }, hour, minute, true);//True for 24h format
                timePicker.setTitle("Select End Time");
                timePicker.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                timePicker.show();
            }
        });

        //Submit Button
        Button btn_submit = (Button)findViewById(R.id.button_submit);
        btn_submit.setOnClickListener(new View.OnClickListener() {
            //Additional Emotion input
            EditText input = (EditText) findViewById(R.id.text_hint);
            @Override
            public void onClick(View v) {

                //Add all missing inputs to display which fields need to be updated
                String missingInput= null;
                int test=0;
                if(sEmotion==null) {
                    missingInput = "Emotion" + "\n";
                    test=1;
                }
                if(sConfidence==null){
                    String temp = "Confidence" + "\n";
                    if(test==0)
                        missingInput = temp;
                    else
                        missingInput = missingInput + temp;
                    test=1;
                }
                if(sIntensity==null){
                    String temp = "Intensity" + "\n";
                    if(test==0)
                        missingInput = temp;
                    else
                        missingInput = missingInput + temp;
                    test=1;
                }
                if(date==null){
                    String temp = "Date" + "\n";
                    if(test==0)
                        missingInput = temp;
                    else
                        missingInput = missingInput + temp;
                    test=1;
                }
                if(start_time==null){
                    String temp = "Start time" + "\n";
                    if(test==0)
                        missingInput = temp;
                    else
                        missingInput = missingInput + temp;
                    test=1;
                }
                if(end_time==null){
                    String temp = "End Time" + "\n";
                    if(test==0)
                        missingInput = temp;
                    else
                        missingInput = missingInput + temp;
                }

                if( missingInput!=null ) {
                    new AlertDialog.Builder(LogEmotionActivity.this)
                            .setTitle("Incomplete Input")
                            .setMessage("Incomplete input!\nPlease update the following fields:\n"
                                    + missingInput + "\nPress OK to finish without saving or CANCEL to review the input.")
                            .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    finish();
                                }
                            })
                            .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // do nothing
                                }
                            })
                            .setIcon(android.R.drawable.ic_dialog_alert)
                            .show();
                }
                else {

                    String sInput = input.getText().toString();
                    if(sInput.isEmpty()) sInput="N/A";

                    unixTime = System.currentTimeMillis() / 1000L;
                    String row = sEmotion + ',' + sIntensity + ',' + sConfidence + ',' + sInput + ',' + date + ',' + start_time + ','+ end_time +'\n';
                    Utility.writetoCSV(getApplicationContext(),path, filenameTag, row);
                    Utility.toastie(getApplicationContext(), "Entry saved");
                    finish();
                }
            }
        });

        //Cancel Button
        Button btn_cancel = (Button)findViewById(R.id.button_cancel);
        btn_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)            {
                //Close the current activity
                finish();
            }
        });
    }
}
