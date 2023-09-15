package com.brother.ptouch.sdk.printdemo;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import android.app.AlertDialog;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.brother.sdk.lmprinter.setting.CustomPaperSize;
import com.brother.sdk.lmprinter.setting.PJPaperSize;
import com.brother.sdk.lmprinter.setting.MWPrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport;

import java.io.IOException;
import java.util.ArrayList;

public class Activity_MWPrintSetting extends Activity {

    static final int RequestCode_CustomPaperSize = 1000;

    public MWPrintSettings mwPrintSettings;
    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mw_print_setting);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        mwPrintSettings = (MWPrintSettings)intent.getSerializableExtra("mwPrintSettings");
        
        ((TextView)findViewById(R.id.ScaleMode_value)).setText(mwPrintSettings.getScaleMode().name());
        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(mwPrintSettings.getScaleValue()));
        ((TextView)findViewById(R.id.Orientation_value)).setText(mwPrintSettings.getPrintOrientation().name());
        ((TextView)findViewById(R.id.Rotation_value)).setText(mwPrintSettings.getImageRotation().name());
        ((TextView)findViewById(R.id.Halftone_value)).setText(mwPrintSettings.getHalftone().name());
        ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(mwPrintSettings.getHAlignment().name());
        ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(mwPrintSettings.getVAlignment().name());
        ((TextView)findViewById(R.id.CompressMode_value)).setText(mwPrintSettings.getCompress().name());
        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(mwPrintSettings.getHalftoneThreshold()));
        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(mwPrintSettings.getNumCopies()));
        if ( mwPrintSettings.isSkipStatusCheck()==false ) {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.PrintQuality_value)).setText(mwPrintSettings.getPrintQuality().name());
        ((TextView)findViewById(R.id.PaperSize_value)).setText(mwPrintSettings.getPaperSize().name());
        ((TextView)findViewById(R.id.WorkPath_value)).setText(mwPrintSettings.getWorkPath());

        findViewById(R.id.validate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

                ValidatePrintSettingsReport report = ValidatePrintSettings.validate(mwPrintSettings);

                builder.setTitle( "Validate" );
                builder.setMessage(report.description());

                builder.setPositiveButton("OK" , null);

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
        if (mwPrintSettings.getPrinterModel().name().startsWith("MW")) {
            ((Button)findViewById(R.id.validate)).setEnabled(true);
        }
        else {
            ((Button)findViewById(R.id.validate)).setEnabled(false);
        }
    }

    public void onBackPressed() {
        Intent intentSub = new Intent();

        intentSub.putExtra("mwPrintSettings", mwPrintSettings);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }

    public void changeScaleMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeScaleMode" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.ScaleMode e : MWPrintSettings.ScaleMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setScaleMode(MWPrintSettings.ScaleMode.values()[which]);
                ((TextView)findViewById(R.id.ScaleMode_value)).setText(mwPrintSettings.getScaleMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeScaleValue(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeScaleValue" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        mwPrintSettings.setScaleValue(value);
                        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(value));
                    }
                    catch (NumberFormatException e) {
                        // nop
                    }
                }
            }
        });
        builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                // nop
            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();

    }
    public void changeOrientation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeOrientation" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.Orientation e : MWPrintSettings.Orientation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setPrintOrientation(MWPrintSettings.Orientation.values()[which]);
                ((TextView)findViewById(R.id.Orientation_value)).setText(mwPrintSettings.getPrintOrientation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeRotation" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.Rotation e : MWPrintSettings.Rotation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setImageRotation(MWPrintSettings.Rotation.values()[which]);
                ((TextView)findViewById(R.id.Rotation_value)).setText(mwPrintSettings.getImageRotation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftone(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeHalftone" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.Halftone e : MWPrintSettings.Halftone.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setHalftone(MWPrintSettings.Halftone.values()[which]);
                ((TextView)findViewById(R.id.Halftone_value)).setText(mwPrintSettings.getHalftone().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHorizontalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeHorizontalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.HorizontalAlignment e : MWPrintSettings.HorizontalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setHAlignment(MWPrintSettings.HorizontalAlignment.values()[which]);
                ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(mwPrintSettings.getHAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeVerticalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeVerticalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.VerticalAlignment e : MWPrintSettings.VerticalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setVAlignment(MWPrintSettings.VerticalAlignment.values()[which]);
                ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(mwPrintSettings.getVAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCompressMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeCompressMode" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.CompressMode e : MWPrintSettings.CompressMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setCompress(MWPrintSettings.CompressMode.values()[which]);
                ((TextView)findViewById(R.id.CompressMode_value)).setText(mwPrintSettings.getCompress().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftoneThreshold(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeHalftoneThreshold" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        value = Math.max(0,Math.min(255,value));
                        mwPrintSettings.setHalftoneThreshold(value);
                        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(value));
                    }
                    catch (NumberFormatException e) {
                        // nop
                    }
                }
            }
        });
        builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                // nop
            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();

    }
    public void changeNumCopies(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeNumCopies" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        mwPrintSettings.setNumCopies(value);
                        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(value));
                    }
                    catch (NumberFormatException e) {
                        // nop
                    }
                }
            }
        });
        builder.setNeutralButton( "CANCEL", new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                // nop
            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();

    }
    public void changeSkipStatusCheck(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeSkipStatusCheck" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    mwPrintSettings.setSkipStatusCheck(false);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
                }
                else {
                    mwPrintSettings.setSkipStatusCheck(true);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintQuality(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changePrintQuality" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.PrintQuality e : MWPrintSettings.PrintQuality.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setPrintQuality(MWPrintSettings.PrintQuality.values()[which]);
                ((TextView)findViewById(R.id.PrintQuality_value)).setText(mwPrintSettings.getPrintQuality().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changePaperSize(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changePaperSize" );

        ArrayList<String> list = new ArrayList<>();
        for (MWPrintSettings.PaperSize e : MWPrintSettings.PaperSize.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                mwPrintSettings.setPaperSize(MWPrintSettings.PaperSize.values()[which]);
                ((TextView)findViewById(R.id.PaperSize_value)).setText(mwPrintSettings.getPaperSize().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeWorkPath(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_MWPrintSetting.this);

        builder.setTitle( "changeWorkPath" );

        ArrayList<String> list = new ArrayList<>();
        list.add("In-app folder");
        list.add("External folder");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    mwPrintSettings.setWorkPath(getFilesDir().getAbsolutePath());
                }
                else {
                    mwPrintSettings.setWorkPath(getExternalFilesDir(null).getAbsolutePath());
                }
                ((TextView)findViewById(R.id.WorkPath_value)).setText(mwPrintSettings.getWorkPath());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }


}