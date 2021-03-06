package com.example.anwender.empaticae4.Configuration;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

public class FabricManager {
    private Callback mCallback;
    private android.os.Handler mHandler;
    private byte[] buffer;
    private final RandomAccessFile hashDevice = null;


    public FabricManager(FabricManager.Callback callback) {
//    public FabricManager() {

        buffer = new byte[128];
        mHandler = new android.os.Handler();

        if (callback instanceof Callback) {
            this.mCallback = (Callback) callback;
        } else {
            throw new RuntimeException(callback.toString()
                    + " must implement NetworkManager.Callback interface");
        }
    }


    /**
     * Calculate HASH from file with the blake2b module
     *
     * @param filename     filename
     * @param driver   replace with "/proc/blake2b"
     * @return
     */
    byte[] calculateHashFromFile(final String filename, final String driver, final String hash) {

        try {
            // open device driver
            RandomAccessFile hashDriver = new RandomAccessFile(driver, "rws"); // will be replaced with the device driver
            // write absolute bitstream filepath to device driver
            hashDriver.writeChars(filename);

            //wait until hash file exists (hash ready)
            File file = new File(hash);
            while (!file.exists()) {
                try {
                    //Thread.Sleep(1000);
                    java.lang.Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            RandomAccessFile hashResult = new RandomAccessFile(hash, "r");

            //read the calculated HASH
            hashResult.read(buffer, 0, 128);

            // release driver
            hashDriver.close();
            hashResult.close();

            //delete hash file, not needed anymore
            file.delete();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return buffer;
    }

    /**
     * load the bitstream into the fabric
     *
     * @param file     filename
     * @param driver   replace with "/proc/..."
     */
    void reconfigureFabric(final String file, final String driver) {

        Runnable reconfigFabric = new Runnable() {
            @Override
            public void run() {
                try {
                    // open device driver
                    RandomAccessFile fabricDriver = new RandomAccessFile(driver, "rws");
                    // write absolute bitstream filepath to device driver
                    fabricDriver.writeChars(file);
                    // release driver
                    fabricDriver.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };

        mHandler.post(reconfigFabric);
        // read the processed image back into the ui
        mCallback.onReconfigureFabricDone();
    }

    public interface Callback {
        public void onReconfigureFabricDone();
    }
}
