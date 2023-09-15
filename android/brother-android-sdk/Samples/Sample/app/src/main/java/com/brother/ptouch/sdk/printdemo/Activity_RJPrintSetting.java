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
import com.brother.sdk.lmprinter.setting.RJPrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport;

import java.io.IOException;
import java.util.ArrayList;

public class Activity_RJPrintSetting extends Activity {

    static final int RequestCode_CustomPaperSize = 1000;

    public RJPrintSettings rjPrintSettings;
    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rj_print_setting);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        rjPrintSettings = (RJPrintSettings)intent.getSerializableExtra("rjPrintSettings");
        
        ((TextView)findViewById(R.id.ScaleMode_value)).setText(rjPrintSettings.getScaleMode().name());
        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(rjPrintSettings.getScaleValue()));
        ((TextView)findViewById(R.id.Orientation_value)).setText(rjPrintSettings.getPrintOrientation().name());
        ((TextView)findViewById(R.id.Rotation_value)).setText(rjPrintSettings.getImageRotation().name());
        ((TextView)findViewById(R.id.Halftone_value)).setText(rjPrintSettings.getHalftone().name());
        ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(rjPrintSettings.getHAlignment().name());
        ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(rjPrintSettings.getVAlignment().name());
        ((TextView)findViewById(R.id.CompressMode_value)).setText(rjPrintSettings.getCompress().name());
        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(rjPrintSettings.getHalftoneThreshold()));
        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(rjPrintSettings.getNumCopies()));
        if ( rjPrintSettings.isSkipStatusCheck()==false ) {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.PrintQuality_value)).setText(rjPrintSettings.getPrintQuality().name());
        ((TextView)findViewById(R.id.CustomPaperSize_value)).setText(rjPrintSettings.getCustomPaperSize().getPaperKind().name());
        ((TextView)findViewById(R.id.Density_value)).setText(rjPrintSettings.getDensity().name());
        if ( rjPrintSettings.isRotate180degrees()==false ) {
            ((TextView)findViewById(R.id.Rotate180degrees_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.Rotate180degrees_value)).setText("ON");
        }
        if ( rjPrintSettings.isPeelLabel()==false ) {
            ((TextView)findViewById(R.id.PeelLabel_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.PeelLabel_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.WorkPath_value)).setText(rjPrintSettings.getWorkPath());

        findViewById(R.id.validate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

                ValidatePrintSettingsReport report = ValidatePrintSettings.validate(rjPrintSettings);

                builder.setTitle( "Validate" );
                builder.setMessage(report.description());

                builder.setPositiveButton("OK" , null);

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
        if (rjPrintSettings.getPrinterModel().name().startsWith("RJ")) {
            ((Button)findViewById(R.id.validate)).setEnabled(true);
        }
        else {
            ((Button)findViewById(R.id.validate)).setEnabled(false);
        }
    }

    public void onBackPressed() {
        Intent intentSub = new Intent();

        intentSub.putExtra("rjPrintSettings", rjPrintSettings);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }

    public void changeScaleMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeScaleMode" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.ScaleMode e : RJPrintSettings.ScaleMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setScaleMode(RJPrintSettings.ScaleMode.values()[which]);
                ((TextView)findViewById(R.id.ScaleMode_value)).setText(rjPrintSettings.getScaleMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeScaleValue(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

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
                        rjPrintSettings.setScaleValue(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeOrientation" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.Orientation e : RJPrintSettings.Orientation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setPrintOrientation(RJPrintSettings.Orientation.values()[which]);
                ((TextView)findViewById(R.id.Orientation_value)).setText(rjPrintSettings.getPrintOrientation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeRotation" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.Rotation e : RJPrintSettings.Rotation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setImageRotation(RJPrintSettings.Rotation.values()[which]);
                ((TextView)findViewById(R.id.Rotation_value)).setText(rjPrintSettings.getImageRotation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftone(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeHalftone" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.Halftone e : RJPrintSettings.Halftone.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setHalftone(RJPrintSettings.Halftone.values()[which]);
                ((TextView)findViewById(R.id.Halftone_value)).setText(rjPrintSettings.getHalftone().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHorizontalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeHorizontalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.HorizontalAlignment e : RJPrintSettings.HorizontalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setHAlignment(RJPrintSettings.HorizontalAlignment.values()[which]);
                ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(rjPrintSettings.getHAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeVerticalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeVerticalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.VerticalAlignment e : RJPrintSettings.VerticalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setVAlignment(RJPrintSettings.VerticalAlignment.values()[which]);
                ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(rjPrintSettings.getVAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCompressMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeCompressMode" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.CompressMode e : RJPrintSettings.CompressMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setCompress(RJPrintSettings.CompressMode.values()[which]);
                ((TextView)findViewById(R.id.CompressMode_value)).setText(rjPrintSettings.getCompress().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftoneThreshold(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

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
                        rjPrintSettings.setHalftoneThreshold(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

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
                        rjPrintSettings.setNumCopies(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeSkipStatusCheck" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    rjPrintSettings.setSkipStatusCheck(false);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
                }
                else {
                    rjPrintSettings.setSkipStatusCheck(true);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintQuality(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changePrintQuality" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.PrintQuality e : RJPrintSettings.PrintQuality.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setPrintQuality(RJPrintSettings.PrintQuality.values()[which]);
                ((TextView)findViewById(R.id.PrintQuality_value)).setText(rjPrintSettings.getPrintQuality().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCustomPaperSize(View view) {
        Intent intent = new Intent(this, Activity_PrintSettingCustomPaper.class);
        intent.putExtra("customPaperSize", rjPrintSettings.getCustomPaperSize());
        startActivityForResult( intent, RequestCode_CustomPaperSize );
    }
    protected void onActivityResult( int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if(resultCode == RESULT_OK && requestCode == RequestCode_CustomPaperSize &&
               null != intent) {
            rjPrintSettings.setCustomPaperSize((CustomPaperSize)intent.getSerializableExtra("customPaperSize"));
            ((TextView)findViewById(R.id.CustomPaperSize_value)).setText(rjPrintSettings.getCustomPaperSize().getPaperKind().name());
        }
    }
    public void changeDensity(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeDensity" );

        ArrayList<String> list = new ArrayList<>();
        for (RJPrintSettings.Density e : RJPrintSettings.Density.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                rjPrintSettings.setDensity(RJPrintSettings.Density.values()[which]);
                ((TextView)findViewById(R.id.Density_value)).setText(rjPrintSettings.getDensity().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotate180degrees(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeRotate180degrees" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    rjPrintSettings.setRotate180degrees(false);
                    ((TextView)findViewById(R.id.Rotate180degrees_value)).setText("OFF");
                }
                else {
                    rjPrintSettings.setRotate180degrees(true);
                    ((TextView)findViewById(R.id.Rotate180degrees_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePeelLabel(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changePeelLabel" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    rjPrintSettings.setPeelLabel(false);
                    ((TextView)findViewById(R.id.PeelLabel_value)).setText("OFF");
                }
                else {
                    rjPrintSettings.setPeelLabel(true);
                    ((TextView)findViewById(R.id.PeelLabel_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeWorkPath(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_RJPrintSetting.this);

        builder.setTitle( "changeWorkPath" );

        ArrayList<String> list = new ArrayList<>();
        list.add("In-app folder");
        list.add("External folder");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    rjPrintSettings.setWorkPath(getFilesDir().getAbsolutePath());
                }
                else {
                    rjPrintSettings.setWorkPath(getExternalFilesDir(null).getAbsolutePath());
                }
                ((TextView)findViewById(R.id.WorkPath_value)).setText(rjPrintSettings.getWorkPath());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }


}