package com.kdsuneraavinash.dengueapp;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.provider.MediaStore;

import java.io.FileOutputStream;
import java.io.IOException;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.kdsuneraavinash.dengueapp/thumbnail";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("retrieveVideoFrameFromVideo")) {
                            String videoFrame = "";
                            try {
                                videoFrame = retrieveVideoFrameFromVideo((String) call.argument("video"), (String) call.argument("thumbnail"));
                            } catch (Throwable throwable) {
                                throwable.printStackTrace();
                            }
                            if (videoFrame.length() == 0) {
                                result.success(videoFrame);
                            } else {
                                result.error("UNAVAILABLE", "Video Frame not available.", null);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    public String retrieveVideoFrameFromVideo(String videoPath, String thumbnailPath) throws Throwable
    {
        System.out.println("VIDEO:"  +videoPath);
        System.out.println("THUMBNAIL:" + thumbnailPath);
        Bitmap bitmap =  ThumbnailUtils.createVideoThumbnail(videoPath, MediaStore.Video.Thumbnails.MINI_KIND);

        FileOutputStream out = null;
        try {
            out = new FileOutputStream(thumbnailPath);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out); // bmp is your Bitmap instance
            // PNG is a loss-less format, the compression factor (100) is ignored
        } catch (IOException e) {
            e.printStackTrace();
            throw new Throwable("Couldn't save file in " + thumbnailPath + " :" + e.getMessage());
        } finally {
            if (out != null){
                out.close();
            }
        }
        return thumbnailPath;
    }

}
