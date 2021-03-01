package com.example.anwender.empaticae4.Configuration;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MsgProcessor {
    private Callback mCallback;
    private List<String> changelogList = new ArrayList<String>();

    public void process(JSONObject json) {
        try {
            String index = json.getString(Constants.JSON.INDEX);
            String title = json.getString(Constants.JSON.TITLE);
            String version = json.getString(Constants.JSON.VERSION);
            String descp = json.getString(Constants.JSON.DESCRIPTION);

            JSONArray changelogs = json.getJSONArray(Constants.JSON.CHANGELOG);

            for (int i = 0; i < changelogs.length(); i++) {
                changelogList.add(changelogs.getString(i));
            }

            String file = json.getString(Constants.JSON.FILENAME);
            String date = json.getString(Constants.JSON.DATE);
            String checksum = json.getString(Constants.JSON.CHECKSUM);

            // get version from persistence storage
            HashMap<String, String> config = mCallback.getCurrentConfig();

            Repository temp = new Repository(index, title, version, descp, changelogList, file, date, checksum);

            // compare version if there is already a firmware installed
            if (config.get(Constants.JSON.INDEX) != null) {
                // if new; init download
                //mCallback.onUpdateAvailable(temp);

                if (index.equals(config.get(Constants.JSON.INDEX))) { //when INDEX is the same check the version
                    if (Integer.parseInt(version) > Integer.parseInt(config.get(Constants.JSON.VERSION))) {
                        mCallback.onUpdateAvailable(temp);
                    } else {
                        mCallback.printToTextBox("No updates available! \r\n");
                    }
                } else { //otherwise update
                    mCallback.onUpdateAvailable(temp);
                }

            } else {
                mCallback.onUpdateAvailable(temp);
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    public void verifyBitstream(Repository repo, boolean enable_hash) {
        // check if hash calculation is enabled
        if (enable_hash) {
            // calculate hash with the hardware blake2b module
            byte[] hash_buffer = mCallback.calculateHash(repo.getFile());
            String hash = new String(hash_buffer, StandardCharsets.US_ASCII);

            // compare with received hash from the server
            if (hash.equals(repo.getChecksum())) {
                mCallback.onVerifiedBitstream(repo, true);
            } else {
                mCallback.onVerifiedBitstream(repo, false);
            }
        } else {
            // process without hash verification
            mCallback.onVerifiedBitstream(repo, true);
        }
    }


    public MsgProcessor(MsgProcessor.Callback callback) {

        if (callback instanceof Callback) {
            this.mCallback = (Callback) callback;
        } else {
            throw new RuntimeException(callback.toString()
                    + " must implement NetworkManager.Callback interface");
        }
    }

    public void debug(Object o) {
        System.out.println(o.toString());
    }

    public interface Callback {
        void onUpdateAvailable(Repository repo);

        HashMap<String, String> getCurrentConfig();

        void printToTextBox(String text);

        byte[] calculateHash(String path);

        void onVerifiedBitstream(Repository repo, boolean valid);
    }
}
