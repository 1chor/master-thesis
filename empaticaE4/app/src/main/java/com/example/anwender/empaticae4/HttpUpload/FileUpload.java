package com.example.anwender.empaticae4.HttpUpload;
import android.util.Log;

import java.io.File;
import java.io.IOException;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


public class FileUpload {

    private String URL ;
    private String path;

    public FileUpload(String path, String URL) {
        this.path = path;
        this.URL = URL;
    }

        public void main() {
            Log.d("Files", "Path: " + path);
            File directory = new File(path);
            File[] directories = directory.listFiles();

            for (int i = 0; i < directories.length; i++) {
                if (directories[i].isDirectory()) {

                    //TODO verify that the directory is a legitimate session - store sessions in shared preference?
                    File session = new File(directories[i].toString());
                    File[] files = session.listFiles();
                    String[] stringFiles = new String[files.length];
                    for (int j = 0; j < files.length; j++) {
                        stringFiles[j] = files[j].toString();
                        Log.d("FILE : ", stringFiles[j]);
                    }
                    uploadFiles(stringFiles, directories[i].toString());
                }
            }
        }


    private void uploadFiles(final String[] filePaths, final String folderName) {

        //run on separate thread as to not freeze the Main thread
       final Thread t = new Thread(new Runnable() {
            @Override
            public void run() {

                OkHttpClient client = new OkHttpClient();
                String content_type = "text/csv"; //mime type for csv

                //As there are several files (with a variable amount) in a session, we need a MultipartBody to upload them all at once
                MultipartBody.Builder buildernew = new MultipartBody.Builder()
                        .setType(MultipartBody.FORM)
                        .addFormDataPart("sess_id", folderName.substring(folderName.lastIndexOf("/")));
                        //add files dynamically to the Multipartbody
                        for (int i = 0; i < filePaths.length; i++) {
                            File f = new File(filePaths[i]);
                            String file_path = f.getAbsolutePath();
                            RequestBody file_body = RequestBody.create(MediaType.parse(content_type), f);
                            buildernew.addFormDataPart("uploaded_file" + i, file_path.substring(file_path.lastIndexOf("/") + 1), file_body);
                        }
                RequestBody request_body = buildernew.build();
                Request request = new Request.Builder()
                        .url(URL)
                        .post(request_body)
                        .build();

                try {
                    Response response = client.newCall(request).execute();

                    if (!response.isSuccessful()) {
                        //Todo Retry Management
                        Log.e("HTTP response", response.toString());
                        throw new IOException("Error : " + response);
                    } else {

                        //if the upload was successful, delete the directory and the files inside
                        Log.d("HTTP response", response.toString());
                        File directory = new File(folderName);
                        //TODO deleted to keep the files.
                        //deleteRecursive(directory);
                        response.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
        t.start();

    }

    private static void deleteRecursive(File fileOrDirectory) {
        try{
            if (fileOrDirectory.isDirectory()) {
                for (File child : fileOrDirectory.listFiles()) {
                    deleteRecursive(child);
                }
            }
            if(fileOrDirectory.delete()){
                Log.d("deleteRecursive", fileOrDirectory.toString() + " has been deleted successfully");
            } else{
                Log.e("deleteRecursive", fileOrDirectory.toString() + " could not be deleted");
            }
        }
        catch(NullPointerException e){
            e.printStackTrace();
        }
    }

}