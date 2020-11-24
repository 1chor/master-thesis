package com.example.anwender.empaticae4.Main;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Spinner;

import com.example.anwender.empaticae4.R;

import java.io.File;


public class TagEmotion extends AppCompatActivity {

    private static final String LOG_TAG = TagEmotion.class.getSimpleName();;  //debug purposes
    private final String filenameTag = "TagEmotion.csv";   //Name of the file where tags will be stored
    private File path;  //Location where file will be stored
    private String sIntensity;
    private String sEmotion;
    private String sConfidence;
    private long unixTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tag_emotion);

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
                //TODO Auto-generated method stub
            }
        });

        //Intensity Seekbar
        SeekBar skb_intensity = (SeekBar) findViewById(R.id.seekBar_intensity);
        skb_intensity.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                // TODO Auto-generated method stub
            }
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                // TODO Auto-generated method stub
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
                // TODO Auto-generated method stub
            }
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                // TODO Auto-generated method stub
            }
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress,boolean fromUser) {
                //adjust 0-9 scale to 1-10 with ++
                sConfidence=String.valueOf(++progress);
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
                    test = 1;
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
                }

                if( missingInput!=null ) {
                    new AlertDialog.Builder(TagEmotion.this)
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
                    //Create entry from parameters
                    String row = sEmotion + ',' + sIntensity + ',' + sConfidence + ',' + sInput + ',' + unixTime + '\n';
                    //write entry to file
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
            public void onClick(View v)
            {
                //Close the current activity
                finish();
            }
        });
    }
}