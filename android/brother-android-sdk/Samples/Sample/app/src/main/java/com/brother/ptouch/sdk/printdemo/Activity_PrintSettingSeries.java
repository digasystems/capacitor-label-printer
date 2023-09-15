package com.brother.ptouch.sdk.printdemo;

import android.app.AlertDialog;
import androidx.cardview.widget.CardView;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.graphics.Color;
import android.widget.TextView;

import com.brother.sdk.lmprinter.PrinterModel;
import com.brother.sdk.lmprinter.setting.QLPrintSettings;
import com.brother.sdk.lmprinter.setting.PTPrintSettings;
import com.brother.sdk.lmprinter.setting.PJPrintSettings;
import com.brother.sdk.lmprinter.setting.MWPrintSettings;
import com.brother.sdk.lmprinter.setting.TDPrintSettings;
import com.brother.sdk.lmprinter.setting.RJPrintSettings;
import com.google.gson.Gson;

public class Activity_PrintSettingSeries extends Activity {

    static final int RequestCode_QL = 1000;
    static final int RequestCode_PT = 1001;
    static final int RequestCode_PJ = 1002;
    static final int RequestCode_MW = 1003;
    static final int RequestCode_TD = 1004;
    static final int RequestCode_RJ = 1005;

    QLPrintSettings qlPrintSettings;
    PTPrintSettings ptPrintSettings;
    PJPrintSettings pjPrintSettings;
    MWPrintSettings mwPrintSettings;
    TDPrintSettings tdPrintSettings;
    RJPrintSettings rjPrintSettings;
    
    Gson gson;
    
    private SharedPreferences sharedPreferences;

    private PrinterModel currentModel() {
        String modelString = sharedPreferences.getString("printerModel", "");
        return PrinterModel.valueOf(modelString);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_print_setting_series);
        
        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);
        
        gson = new Gson();
        final String currentModelString = currentModel().name();

        String qlPrintSettingsJson = sharedPreferences.getString("qlV4PrintSettings", "");
        if( qlPrintSettingsJson == "") {
            qlPrintSettings = new QLPrintSettings(currentModel());
        }
        else {
            qlPrintSettings = gson.fromJson(qlPrintSettingsJson, QLPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("QL")) {
            TextView textView = (TextView) findViewById(R.id.QL_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView QL = (CardView) findViewById(R.id.QL);
        QL.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default QL settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        qlPrintSettings = new QLPrintSettings(currentModel());
                        sharedPreferences.edit().putString("qlV4PrintSettings", gson.toJson(qlPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

        String ptPrintSettingsJson = sharedPreferences.getString("ptV4PrintSettings", "");
        if( ptPrintSettingsJson == "") {
            ptPrintSettings = new PTPrintSettings(currentModel());
        }
        else {
            ptPrintSettings = gson.fromJson(ptPrintSettingsJson, PTPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("PT")) {
            TextView textView = (TextView) findViewById(R.id.PT_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView PT = (CardView) findViewById(R.id.PT);
        PT.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default PT settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        ptPrintSettings = new PTPrintSettings(currentModel());
                        sharedPreferences.edit().putString("ptV4PrintSettings", gson.toJson(ptPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

        String pjPrintSettingsJson = sharedPreferences.getString("pjV4PrintSettings", "");
        if( pjPrintSettingsJson == "") {
            pjPrintSettings = new PJPrintSettings(currentModel());
        }
        else {
            pjPrintSettings = gson.fromJson(pjPrintSettingsJson, PJPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("PJ")) {
            TextView textView = (TextView) findViewById(R.id.PJ_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView PJ = (CardView) findViewById(R.id.PJ);
        PJ.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default PJ settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        pjPrintSettings = new PJPrintSettings(currentModel());
                        sharedPreferences.edit().putString("pjV4PrintSettings", gson.toJson(pjPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

        String mwPrintSettingsJson = sharedPreferences.getString("mwV4PrintSettings", "");
        if( mwPrintSettingsJson == "") {
            mwPrintSettings = new MWPrintSettings(currentModel());
        }
        else {
            mwPrintSettings = gson.fromJson(mwPrintSettingsJson, MWPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("MW")) {
            TextView textView = (TextView) findViewById(R.id.MW_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView MW = (CardView) findViewById(R.id.MW);
        MW.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default MW settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        mwPrintSettings = new MWPrintSettings(currentModel());
                        sharedPreferences.edit().putString("mwV4PrintSettings", gson.toJson(mwPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

        String tdPrintSettingsJson = sharedPreferences.getString("tdV4PrintSettings", "");
        if( tdPrintSettingsJson == "") {
            tdPrintSettings = new TDPrintSettings(currentModel());
        }
        else {
            tdPrintSettings = gson.fromJson(tdPrintSettingsJson, TDPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("TD")) {
            TextView textView = (TextView) findViewById(R.id.TD_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView TD = (CardView) findViewById(R.id.TD);
        TD.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default TD settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        tdPrintSettings = new TDPrintSettings(currentModel());
                        sharedPreferences.edit().putString("tdV4PrintSettings", gson.toJson(tdPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

        String rjPrintSettingsJson = sharedPreferences.getString("rjV4PrintSettings", "");
        if( rjPrintSettingsJson == "") {
            rjPrintSettings = new RJPrintSettings(currentModel());
        }
        else {
            rjPrintSettings = gson.fromJson(rjPrintSettingsJson, RJPrintSettings.class).copyPrintSettings(currentModel());
        }

        if(currentModelString.startsWith("RJ")) {
            TextView textView = (TextView) findViewById(R.id.RJ_caption);
            textView.setTextColor(Color.BLACK);
        }
        
        CardView RJ = (CardView) findViewById(R.id.RJ);
        RJ.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingSeries.this);

                builder.setTitle( "RESET" );
                builder.setMessage( "Reset to Default RJ settings" );

                builder.setPositiveButton("RESET" , new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // reset
                        rjPrintSettings = new RJPrintSettings(currentModel());
                        sharedPreferences.edit().putString("rjV4PrintSettings", gson.toJson(rjPrintSettings));
                    }
                });
                builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // nop
                    }
                });

                AlertDialog dialog = builder.create();
                dialog.show();
                return true;
            }
        });

    }

    public void tap_ql(View view) {
        Intent intent = new Intent(this, Activity_QLPrintSetting.class);
        intent.putExtra("qlPrintSettings", qlPrintSettings);
        startActivityForResult( intent, RequestCode_QL );
    }

    public void tap_pt(View view) {
        Intent intent = new Intent(this, Activity_PTPrintSetting.class);
        intent.putExtra("ptPrintSettings", ptPrintSettings);
        startActivityForResult( intent, RequestCode_PT );
    }

    public void tap_pj(View view) {
        Intent intent = new Intent(this, Activity_PJPrintSetting.class);
        intent.putExtra("pjPrintSettings", pjPrintSettings);
        startActivityForResult( intent, RequestCode_PJ );
    }

    public void tap_mw(View view) {
        Intent intent = new Intent(this, Activity_MWPrintSetting.class);
        intent.putExtra("mwPrintSettings", mwPrintSettings);
        startActivityForResult( intent, RequestCode_MW );
    }

    public void tap_td(View view) {
        Intent intent = new Intent(this, Activity_TDPrintSetting.class);
        intent.putExtra("tdPrintSettings", tdPrintSettings);
        startActivityForResult( intent, RequestCode_TD );
    }

    public void tap_rj(View view) {
        Intent intent = new Intent(this, Activity_RJPrintSetting.class);
        intent.putExtra("rjPrintSettings", rjPrintSettings);
        startActivityForResult( intent, RequestCode_RJ );
    }


    protected void onActivityResult( int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        
        if(resultCode == RESULT_OK && requestCode == RequestCode_QL &&
                null != intent) {
            qlPrintSettings = (QLPrintSettings)intent.getSerializableExtra("qlPrintSettings");
            editor.putString("qlV4PrintSettings", gson.toJson(qlPrintSettings));
        }

        if(resultCode == RESULT_OK && requestCode == RequestCode_PT &&
                null != intent) {
            ptPrintSettings = (PTPrintSettings)intent.getSerializableExtra("ptPrintSettings");
            editor.putString("ptV4PrintSettings", gson.toJson(ptPrintSettings));
        }

        if(resultCode == RESULT_OK && requestCode == RequestCode_PJ &&
                null != intent) {
            pjPrintSettings = (PJPrintSettings)intent.getSerializableExtra("pjPrintSettings");
            editor.putString("pjV4PrintSettings", gson.toJson(pjPrintSettings));
        }

        if(resultCode == RESULT_OK && requestCode == RequestCode_MW &&
                null != intent) {
            mwPrintSettings = (MWPrintSettings)intent.getSerializableExtra("mwPrintSettings");
            editor.putString("mwV4PrintSettings", gson.toJson(mwPrintSettings));
        }

        if(resultCode == RESULT_OK && requestCode == RequestCode_TD &&
                null != intent) {
            tdPrintSettings = (TDPrintSettings)intent.getSerializableExtra("tdPrintSettings");
            editor.putString("tdV4PrintSettings", gson.toJson(tdPrintSettings));
        }

        if(resultCode == RESULT_OK && requestCode == RequestCode_RJ &&
                null != intent) {
            rjPrintSettings = (RJPrintSettings)intent.getSerializableExtra("rjPrintSettings");
            editor.putString("rjV4PrintSettings", gson.toJson(rjPrintSettings));
        }
 
        editor.commit();
    }
    
}