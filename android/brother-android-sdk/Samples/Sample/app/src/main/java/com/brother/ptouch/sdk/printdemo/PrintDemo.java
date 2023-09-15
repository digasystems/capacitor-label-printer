package com.brother.ptouch.sdk.printdemo;

import android.app.Application;
import android.content.Context;

public final class PrintDemo extends Application {

    private static Context appContext;

    @Override
    public void onCreate() {
        super.onCreate();
        PrintDemo.appContext = getApplicationContext();
    }

    public static Context getAppContext() {

        return PrintDemo.appContext;
    }
}
