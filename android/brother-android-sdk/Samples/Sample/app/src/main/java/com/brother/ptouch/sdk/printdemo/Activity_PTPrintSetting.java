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
import com.brother.sdk.lmprinter.setting.PTPrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport;

import java.io.IOException;
import java.util.ArrayList;

public class Activity_PTPrintSetting extends Activity {

    static final int RequestCode_CustomPaperSize = 1000;

    public PTPrintSettings ptPrintSettings;
    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pt_print_setting);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        ptPrintSettings = (PTPrintSettings)intent.getSerializableExtra("ptPrintSettings");
        
        ((TextView)findViewById(R.id.ScaleMode_value)).setText(ptPrintSettings.getScaleMode().name());
        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(ptPrintSettings.getScaleValue()));
        ((TextView)findViewById(R.id.Orientation_value)).setText(ptPrintSettings.getPrintOrientation().name());
        ((TextView)findViewById(R.id.Rotation_value)).setText(ptPrintSettings.getImageRotation().name());
        ((TextView)findViewById(R.id.Halftone_value)).setText(ptPrintSettings.getHalftone().name());
        ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(ptPrintSettings.getHAlignment().name());
        ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(ptPrintSettings.getVAlignment().name());
        ((TextView)findViewById(R.id.CompressMode_value)).setText(ptPrintSettings.getCompress().name());
        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(ptPrintSettings.getHalftoneThreshold()));
        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(ptPrintSettings.getNumCopies()));
        if ( ptPrintSettings.isSkipStatusCheck()==false ) {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.PrintQuality_value)).setText(ptPrintSettings.getPrintQuality().name());
        ((TextView)findViewById(R.id.LabelSize_value)).setText(ptPrintSettings.getLabelSize().name());
        if ( ptPrintSettings.isCutmarkPrint()==false ) {
            ((TextView)findViewById(R.id.CutmarkPrint_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.CutmarkPrint_value)).setText("ON");
        }
        if ( ptPrintSettings.isCutPause()==false ) {
            ((TextView)findViewById(R.id.CutPause_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.CutPause_value)).setText("ON");
        }
        if ( ptPrintSettings.isAutoCut()==false ) {
            ((TextView)findViewById(R.id.AutoCut_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.AutoCut_value)).setText("ON");
        }
        if ( ptPrintSettings.isHalfCut()==false ) {
            ((TextView)findViewById(R.id.HalfCut_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.HalfCut_value)).setText("ON");
        }
        if ( ptPrintSettings.isChainPrint()==false ) {
            ((TextView)findViewById(R.id.ChainPrint_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.ChainPrint_value)).setText("ON");
        }
        if ( ptPrintSettings.isSpecialTapePrint()==false ) {
            ((TextView)findViewById(R.id.SpecialTapePrint_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SpecialTapePrint_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.Resolution_value)).setText(ptPrintSettings.getResolution().name());
        ((TextView)findViewById(R.id.AutoCutForEachPageCount_value)).setText(String.valueOf(ptPrintSettings.getAutoCutForEachPageCount()));
        if ( ptPrintSettings.isForceVanishingMargin()==false ) {
            ((TextView)findViewById(R.id.ForceVanishingMargin_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.ForceVanishingMargin_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.WorkPath_value)).setText(ptPrintSettings.getWorkPath());

        findViewById(R.id.validate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

                ValidatePrintSettingsReport report = ValidatePrintSettings.validate(ptPrintSettings);

                builder.setTitle( "Validate" );
                builder.setMessage(report.description());

                builder.setPositiveButton("OK" , null);

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
        if (ptPrintSettings.getPrinterModel().name().startsWith("PT")) {
            ((Button)findViewById(R.id.validate)).setEnabled(true);
        }
        else {
            ((Button)findViewById(R.id.validate)).setEnabled(false);
        }
    }

    public void onBackPressed() {
        Intent intentSub = new Intent();

        intentSub.putExtra("ptPrintSettings", ptPrintSettings);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }

    public void changeScaleMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeScaleMode" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.ScaleMode e : PTPrintSettings.ScaleMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setScaleMode(PTPrintSettings.ScaleMode.values()[which]);
                ((TextView)findViewById(R.id.ScaleMode_value)).setText(ptPrintSettings.getScaleMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeScaleValue(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

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
                        ptPrintSettings.setScaleValue(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeOrientation" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.Orientation e : PTPrintSettings.Orientation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setPrintOrientation(PTPrintSettings.Orientation.values()[which]);
                ((TextView)findViewById(R.id.Orientation_value)).setText(ptPrintSettings.getPrintOrientation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeRotation" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.Rotation e : PTPrintSettings.Rotation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setImageRotation(PTPrintSettings.Rotation.values()[which]);
                ((TextView)findViewById(R.id.Rotation_value)).setText(ptPrintSettings.getImageRotation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftone(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeHalftone" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.Halftone e : PTPrintSettings.Halftone.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setHalftone(PTPrintSettings.Halftone.values()[which]);
                ((TextView)findViewById(R.id.Halftone_value)).setText(ptPrintSettings.getHalftone().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHorizontalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeHorizontalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.HorizontalAlignment e : PTPrintSettings.HorizontalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setHAlignment(PTPrintSettings.HorizontalAlignment.values()[which]);
                ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(ptPrintSettings.getHAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeVerticalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeVerticalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.VerticalAlignment e : PTPrintSettings.VerticalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setVAlignment(PTPrintSettings.VerticalAlignment.values()[which]);
                ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(ptPrintSettings.getVAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCompressMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeCompressMode" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.CompressMode e : PTPrintSettings.CompressMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setCompress(PTPrintSettings.CompressMode.values()[which]);
                ((TextView)findViewById(R.id.CompressMode_value)).setText(ptPrintSettings.getCompress().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftoneThreshold(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

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
                        ptPrintSettings.setHalftoneThreshold(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

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
                        ptPrintSettings.setNumCopies(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeSkipStatusCheck" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setSkipStatusCheck(false);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setSkipStatusCheck(true);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintQuality(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changePrintQuality" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.PrintQuality e : PTPrintSettings.PrintQuality.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setPrintQuality(PTPrintSettings.PrintQuality.values()[which]);
                ((TextView)findViewById(R.id.PrintQuality_value)).setText(ptPrintSettings.getPrintQuality().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeLabelSize(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeLabelSize" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.LabelSize e : PTPrintSettings.LabelSize.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setLabelSize(PTPrintSettings.LabelSize.values()[which]);
                ((TextView)findViewById(R.id.LabelSize_value)).setText(ptPrintSettings.getLabelSize().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCutmarkPrint(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeCutmarkPrint" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setCutmarkPrint(false);
                    ((TextView)findViewById(R.id.CutmarkPrint_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setCutmarkPrint(true);
                    ((TextView)findViewById(R.id.CutmarkPrint_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeCutPause(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeCutPause" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setCutPause(false);
                    ((TextView)findViewById(R.id.CutPause_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setCutPause(true);
                    ((TextView)findViewById(R.id.CutPause_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeAutoCut(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeAutoCut" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setAutoCut(false);
                    ((TextView)findViewById(R.id.AutoCut_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setAutoCut(true);
                    ((TextView)findViewById(R.id.AutoCut_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeHalfCut(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeHalfCut" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setHalfCut(false);
                    ((TextView)findViewById(R.id.HalfCut_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setHalfCut(true);
                    ((TextView)findViewById(R.id.HalfCut_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeChainPrint(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeChainPrint" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setChainPrint(false);
                    ((TextView)findViewById(R.id.ChainPrint_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setChainPrint(true);
                    ((TextView)findViewById(R.id.ChainPrint_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeSpecialTapePrint(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeSpecialTapePrint" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setSpecialTapePrint(false);
                    ((TextView)findViewById(R.id.SpecialTapePrint_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setSpecialTapePrint(true);
                    ((TextView)findViewById(R.id.SpecialTapePrint_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeResolution(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeResolution" );

        ArrayList<String> list = new ArrayList<>();
        for (PTPrintSettings.Resolution e : PTPrintSettings.Resolution.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                ptPrintSettings.setResolution(PTPrintSettings.Resolution.values()[which]);
                ((TextView)findViewById(R.id.Resolution_value)).setText(ptPrintSettings.getResolution().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeAutoCutForEachPageCount(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

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
                        ptPrintSettings.setAutoCutForEachPageCount(value);
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
    public void changeForceVanishingMargin(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeForceVanishingMargin" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setForceVanishingMargin(false);
                    ((TextView)findViewById(R.id.ForceVanishingMargin_value)).setText("OFF");
                }
                else {
                    ptPrintSettings.setForceVanishingMargin(true);
                    ((TextView)findViewById(R.id.ForceVanishingMargin_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeWorkPath(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PTPrintSetting.this);

        builder.setTitle( "changeWorkPath" );

        ArrayList<String> list = new ArrayList<>();
        list.add("In-app folder");
        list.add("External folder");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    ptPrintSettings.setWorkPath(getFilesDir().getAbsolutePath());
                }
                else {
                    ptPrintSettings.setWorkPath(getExternalFilesDir(null).getAbsolutePath());
                }
                ((TextView)findViewById(R.id.WorkPath_value)).setText(ptPrintSettings.getWorkPath());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }


}