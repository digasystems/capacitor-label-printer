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
import com.brother.sdk.lmprinter.setting.QLPrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport;

import java.io.IOException;
import java.util.ArrayList;

public class Activity_QLPrintSetting extends Activity {

    static final int RequestCode_CustomPaperSize = 1000;

    public QLPrintSettings qlPrintSettings;
    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ql_print_setting);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        qlPrintSettings = (QLPrintSettings)intent.getSerializableExtra("qlPrintSettings");
        
        ((TextView)findViewById(R.id.ScaleMode_value)).setText(qlPrintSettings.getScaleMode().name());
        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(qlPrintSettings.getScaleValue()));
        ((TextView)findViewById(R.id.Orientation_value)).setText(qlPrintSettings.getPrintOrientation().name());
        ((TextView)findViewById(R.id.Rotation_value)).setText(qlPrintSettings.getImageRotation().name());
        ((TextView)findViewById(R.id.Halftone_value)).setText(qlPrintSettings.getHalftone().name());
        ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(qlPrintSettings.getHAlignment().name());
        ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(qlPrintSettings.getVAlignment().name());
        ((TextView)findViewById(R.id.CompressMode_value)).setText(qlPrintSettings.getCompress().name());
        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(qlPrintSettings.getHalftoneThreshold()));
        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(qlPrintSettings.getNumCopies()));
        if ( qlPrintSettings.isSkipStatusCheck()==false ) {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.PrintQuality_value)).setText(qlPrintSettings.getPrintQuality().name());
        ((TextView)findViewById(R.id.LabelSize_value)).setText(qlPrintSettings.getLabelSize().name());
        if ( qlPrintSettings.isAutoCut()==false ) {
            ((TextView)findViewById(R.id.AutoCut_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.AutoCut_value)).setText("ON");
        }
        if ( qlPrintSettings.isCutAtEnd()==false ) {
            ((TextView)findViewById(R.id.CutAtEnd_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.CutAtEnd_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.Resolution_value)).setText(qlPrintSettings.getResolution().name());
        ((TextView)findViewById(R.id.AutoCutForEachPageCount_value)).setText(String.valueOf(qlPrintSettings.getAutoCutForEachPageCount()));
        ((TextView)findViewById(R.id.BiColorRedEnhancement_value)).setText(String.valueOf(qlPrintSettings.getBiColorRedEnhancement()));
        ((TextView)findViewById(R.id.BiColorGreenEnhancement_value)).setText(String.valueOf(qlPrintSettings.getBiColorGreenEnhancement()));
        ((TextView)findViewById(R.id.BiColorBlueEnhancement_value)).setText(String.valueOf(qlPrintSettings.getBiColorBlueEnhancement()));
        ((TextView)findViewById(R.id.WorkPath_value)).setText(qlPrintSettings.getWorkPath());

        findViewById(R.id.validate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

                ValidatePrintSettingsReport report = ValidatePrintSettings.validate(qlPrintSettings);

                builder.setTitle( "Validate" );
                builder.setMessage(report.description());

                builder.setPositiveButton("OK" , null);

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
        if (qlPrintSettings.getPrinterModel().name().startsWith("QL")) {
            ((Button)findViewById(R.id.validate)).setEnabled(true);
        }
        else {
            ((Button)findViewById(R.id.validate)).setEnabled(false);
        }
    }

    public void onBackPressed() {
        Intent intentSub = new Intent();

        intentSub.putExtra("qlPrintSettings", qlPrintSettings);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }

    public void changeScaleMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeScaleMode" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.ScaleMode e : QLPrintSettings.ScaleMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setScaleMode(QLPrintSettings.ScaleMode.values()[which]);
                ((TextView)findViewById(R.id.ScaleMode_value)).setText(qlPrintSettings.getScaleMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeScaleValue(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

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
                        qlPrintSettings.setScaleValue(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeOrientation" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.Orientation e : QLPrintSettings.Orientation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setPrintOrientation(QLPrintSettings.Orientation.values()[which]);
                ((TextView)findViewById(R.id.Orientation_value)).setText(qlPrintSettings.getPrintOrientation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeRotation" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.Rotation e : QLPrintSettings.Rotation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setImageRotation(QLPrintSettings.Rotation.values()[which]);
                ((TextView)findViewById(R.id.Rotation_value)).setText(qlPrintSettings.getImageRotation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftone(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeHalftone" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.Halftone e : QLPrintSettings.Halftone.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setHalftone(QLPrintSettings.Halftone.values()[which]);
                ((TextView)findViewById(R.id.Halftone_value)).setText(qlPrintSettings.getHalftone().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHorizontalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeHorizontalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.HorizontalAlignment e : QLPrintSettings.HorizontalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setHAlignment(QLPrintSettings.HorizontalAlignment.values()[which]);
                ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(qlPrintSettings.getHAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeVerticalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeVerticalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.VerticalAlignment e : QLPrintSettings.VerticalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setVAlignment(QLPrintSettings.VerticalAlignment.values()[which]);
                ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(qlPrintSettings.getVAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCompressMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeCompressMode" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.CompressMode e : QLPrintSettings.CompressMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setCompress(QLPrintSettings.CompressMode.values()[which]);
                ((TextView)findViewById(R.id.CompressMode_value)).setText(qlPrintSettings.getCompress().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftoneThreshold(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

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
                        qlPrintSettings.setHalftoneThreshold(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

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
                        qlPrintSettings.setNumCopies(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeSkipStatusCheck" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    qlPrintSettings.setSkipStatusCheck(false);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
                }
                else {
                    qlPrintSettings.setSkipStatusCheck(true);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintQuality(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changePrintQuality" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.PrintQuality e : QLPrintSettings.PrintQuality.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setPrintQuality(QLPrintSettings.PrintQuality.values()[which]);
                ((TextView)findViewById(R.id.PrintQuality_value)).setText(qlPrintSettings.getPrintQuality().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeLabelSize(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeLabelSize" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.LabelSize e : QLPrintSettings.LabelSize.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setLabelSize(QLPrintSettings.LabelSize.values()[which]);
                ((TextView)findViewById(R.id.LabelSize_value)).setText(qlPrintSettings.getLabelSize().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeAutoCut(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeAutoCut" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    qlPrintSettings.setAutoCut(false);
                    ((TextView)findViewById(R.id.AutoCut_value)).setText("OFF");
                }
                else {
                    qlPrintSettings.setAutoCut(true);
                    ((TextView)findViewById(R.id.AutoCut_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeCutAtEnd(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeCutAtEnd" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    qlPrintSettings.setCutAtEnd(false);
                    ((TextView)findViewById(R.id.CutAtEnd_value)).setText("OFF");
                }
                else {
                    qlPrintSettings.setCutAtEnd(true);
                    ((TextView)findViewById(R.id.CutAtEnd_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeResolution(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeResolution" );

        ArrayList<String> list = new ArrayList<>();
        for (QLPrintSettings.Resolution e : QLPrintSettings.Resolution.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                qlPrintSettings.setResolution(QLPrintSettings.Resolution.values()[which]);
                ((TextView)findViewById(R.id.Resolution_value)).setText(qlPrintSettings.getResolution().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeAutoCutForEachPageCount(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeAutoCutForEachPageCount" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        value = Math.max(0,Math.min(255,value));
                        qlPrintSettings.setAutoCutForEachPageCount(value);
                        ((TextView)findViewById(R.id.AutoCutForEachPageCount_value)).setText(String.valueOf(value));
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
    public void changeBiColorRedEnhancement(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeBiColorRedEnhancement" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        qlPrintSettings.setBiColorRedEnhancement(value);
                        ((TextView)findViewById(R.id.BiColorRedEnhancement_value)).setText(String.valueOf(value));
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
    public void changeBiColorGreenEnhancement(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeBiColorGreenEnhancement" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        qlPrintSettings.setBiColorGreenEnhancement(value);
                        ((TextView)findViewById(R.id.BiColorGreenEnhancement_value)).setText(String.valueOf(value));
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
    public void changeBiColorBlueEnhancement(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeBiColorBlueEnhancement" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        qlPrintSettings.setBiColorBlueEnhancement(value);
                        ((TextView)findViewById(R.id.BiColorBlueEnhancement_value)).setText(String.valueOf(value));
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
    public void changeWorkPath(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_QLPrintSetting.this);

        builder.setTitle( "changeWorkPath" );

        ArrayList<String> list = new ArrayList<>();
        list.add("In-app folder");
        list.add("External folder");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    qlPrintSettings.setWorkPath(getFilesDir().getAbsolutePath());
                }
                else {
                    qlPrintSettings.setWorkPath(getExternalFilesDir(null).getAbsolutePath());
                }
                ((TextView)findViewById(R.id.WorkPath_value)).setText(qlPrintSettings.getWorkPath());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }


}