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
import android.widget.Spinner;

import com.example.anwender.empaticae4.R;

import java.io.File;

public class TagActivity extends AppCompatActivity {

    private static final String LOG_TAG = TagEmotion.class.getSimpleName();;  //debug purposes
    private final String filenameTag = "TagActivity.csv";   //Name of the file where tags will be stored
    private File path;                                     //Location where file will be stored
    private String sActivity;
    private long unixTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tag_activity);

        path = (File) getIntent().getExtras().get("sessionPath");

        Spinner spinner = (Spinner) findViewById(R.id.spinner_activity);
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.array_activities, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            //Avoid Event through initialization
            int check = 0;
            @Override
            public void onItemSelected(AdapterView<?> arg0, View arg1, int position, long id) {
                if (++check > 1) {
                    sActivity=arg0.getItemAtPosition(position).toString();
                }
            }
            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                //TODO Auto-generated method stub
            }
        });
        Button button_cancel = (Button)findViewById(R.id.button_cancel);
        button_cancel.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                //Close the current activity
                finish();
            }
        });

        //Create Submit Button and define onClick action
        Button button_submit = (Button)findViewById(R.id.button_submit);
        button_submit.setOnClickListener(new View.OnClickListener()
        {
            EditText input = (EditText) findViewById(R.id.text_hint_activity);

            @Override
            public void onClick(View v)
            {
                if( sActivity==null ) {
                    new AlertDialog.Builder(TagActivity.this)
                            .setTitle("Incomplete Input")
                            .setMessage("Please select an Activity to submit your data.\nPress OK to finish without saving or CANCEL to review the input.")
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
                    String row = sActivity + ',' + sInput + ',' + unixTime + '\n';
                    Utility.writetoCSV(getApplicationContext(),path, filenameTag, row);
                    Utility.toastie(getApplicationContext(), "Entry saved");
                    finish();
                }
            }
        });
    }
}
