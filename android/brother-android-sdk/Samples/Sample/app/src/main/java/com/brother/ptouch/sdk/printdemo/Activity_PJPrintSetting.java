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
import com.brother.sdk.lmprinter.setting.PJPrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings;
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport;

import java.io.IOException;
import java.util.ArrayList;

public class Activity_PJPrintSetting extends Activity {

    static final int RequestCode_CustomPaperSize = 1000;

    public PJPrintSettings pjPrintSettings;
    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pj_print_setting);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        pjPrintSettings = (PJPrintSettings)intent.getSerializableExtra("pjPrintSettings");
        
        ((TextView)findViewById(R.id.ScaleMode_value)).setText(pjPrintSettings.getScaleMode().name());
        ((TextView)findViewById(R.id.ScaleValue_value)).setText(String.valueOf(pjPrintSettings.getScaleValue()));
        ((TextView)findViewById(R.id.Orientation_value)).setText(pjPrintSettings.getPrintOrientation().name());
        ((TextView)findViewById(R.id.Rotation_value)).setText(pjPrintSettings.getImageRotation().name());
        ((TextView)findViewById(R.id.Halftone_value)).setText(pjPrintSettings.getHalftone().name());
        ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(pjPrintSettings.getHAlignment().name());
        ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(pjPrintSettings.getVAlignment().name());
        ((TextView)findViewById(R.id.CompressMode_value)).setText(pjPrintSettings.getCompress().name());
        ((TextView)findViewById(R.id.HalftoneThreshold_value)).setText(String.valueOf(pjPrintSettings.getHalftoneThreshold()));
        ((TextView)findViewById(R.id.NumCopies_value)).setText(String.valueOf(pjPrintSettings.getNumCopies()));
        if ( pjPrintSettings.isSkipStatusCheck()==false ) {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.PrintQuality_value)).setText(pjPrintSettings.getPrintQuality().name());
        ((TextView)findViewById(R.id.PaperSize_value)).setText(pjPrintSettings.getPaperSize().getPaperSize().name());
        ((TextView)findViewById(R.id.PaperType_value)).setText(pjPrintSettings.getPaperType().name());
        ((TextView)findViewById(R.id.PaperInsertionPosition_value)).setText(pjPrintSettings.getPaperInsertionPosition().name());
        ((TextView)findViewById(R.id.FeedMode_value)).setText(pjPrintSettings.getFeedMode().name());
        ((TextView)findViewById(R.id.ExtraFeedDots_value)).setText(String.valueOf(pjPrintSettings.getExtraFeedDots()));
        ((TextView)findViewById(R.id.Density_value)).setText(pjPrintSettings.getDensity().name());
        ((TextView)findViewById(R.id.RollCase_value)).setText(pjPrintSettings.getRollCase().name());
        ((TextView)findViewById(R.id.PrintSpeed_value)).setText(pjPrintSettings.getPrintSpeed().name());
        if ( pjPrintSettings.isUsingCarbonCopyPaper()==false ) {
            ((TextView)findViewById(R.id.UsingCarbonCopyPaper_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.UsingCarbonCopyPaper_value)).setText("ON");
        }
        if ( pjPrintSettings.isPrintDashLine()==false ) {
            ((TextView)findViewById(R.id.PrintDashLine_value)).setText("OFF");
        }
        else {
            ((TextView)findViewById(R.id.PrintDashLine_value)).setText("ON");
        }
        ((TextView)findViewById(R.id.WorkPath_value)).setText(pjPrintSettings.getWorkPath());
        ((TextView)findViewById(R.id.ForceStretchPrintableArea_value)).setText(String.valueOf(pjPrintSettings.getForceStretchPrintableArea()));

        findViewById(R.id.validate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

                ValidatePrintSettingsReport report = ValidatePrintSettings.validate(pjPrintSettings);

                builder.setTitle( "Validate" );
                builder.setMessage(report.description());

                builder.setPositiveButton("OK" , null);

                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
        if (pjPrintSettings.getPrinterModel().name().startsWith("PJ")) {
            ((Button)findViewById(R.id.validate)).setEnabled(true);
        }
        else {
            ((Button)findViewById(R.id.validate)).setEnabled(false);
        }
    }

    public void onBackPressed() {
        Intent intentSub = new Intent();

        intentSub.putExtra("pjPrintSettings", pjPrintSettings);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }

    public void changeScaleMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeScaleMode" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.ScaleMode e : PJPrintSettings.ScaleMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setScaleMode(PJPrintSettings.ScaleMode.values()[which]);
                ((TextView)findViewById(R.id.ScaleMode_value)).setText(pjPrintSettings.getScaleMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeScaleValue(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

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
                        pjPrintSettings.setScaleValue(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeOrientation" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.Orientation e : PJPrintSettings.Orientation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setPrintOrientation(PJPrintSettings.Orientation.values()[which]);
                ((TextView)findViewById(R.id.Orientation_value)).setText(pjPrintSettings.getPrintOrientation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRotation(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeRotation" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.Rotation e : PJPrintSettings.Rotation.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setImageRotation(PJPrintSettings.Rotation.values()[which]);
                ((TextView)findViewById(R.id.Rotation_value)).setText(pjPrintSettings.getImageRotation().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftone(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeHalftone" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.Halftone e : PJPrintSettings.Halftone.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setHalftone(PJPrintSettings.Halftone.values()[which]);
                ((TextView)findViewById(R.id.Halftone_value)).setText(pjPrintSettings.getHalftone().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHorizontalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeHorizontalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.HorizontalAlignment e : PJPrintSettings.HorizontalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setHAlignment(PJPrintSettings.HorizontalAlignment.values()[which]);
                ((TextView)findViewById(R.id.HorizontalAlignment_value)).setText(pjPrintSettings.getHAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeVerticalAlignment(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeVerticalAlignment" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.VerticalAlignment e : PJPrintSettings.VerticalAlignment.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setVAlignment(PJPrintSettings.VerticalAlignment.values()[which]);
                ((TextView)findViewById(R.id.VerticalAlignment_value)).setText(pjPrintSettings.getVAlignment().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeCompressMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeCompressMode" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.CompressMode e : PJPrintSettings.CompressMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setCompress(PJPrintSettings.CompressMode.values()[which]);
                ((TextView)findViewById(R.id.CompressMode_value)).setText(pjPrintSettings.getCompress().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeHalftoneThreshold(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

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
                        pjPrintSettings.setHalftoneThreshold(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

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
                        pjPrintSettings.setNumCopies(value);
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
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeSkipStatusCheck" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    pjPrintSettings.setSkipStatusCheck(false);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("OFF");
                }
                else {
                    pjPrintSettings.setSkipStatusCheck(true);
                    ((TextView)findViewById(R.id.SkipStatusCheck_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintQuality(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changePrintQuality" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.PrintQuality e : PJPrintSettings.PrintQuality.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setPrintQuality(PJPrintSettings.PrintQuality.values()[which]);
                ((TextView)findViewById(R.id.PrintQuality_value)).setText(pjPrintSettings.getPrintQuality().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changePaperSize(View view) {
        Intent intent = new Intent(this, Activity_PrintSettingPJPaperSize.class);
        intent.putExtra("pjPaperSize", pjPrintSettings.getPaperSize());
        startActivityForResult( intent, RequestCode_CustomPaperSize );
    }
    protected void onActivityResult( int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if(resultCode == RESULT_OK && requestCode == RequestCode_CustomPaperSize &&
               null != intent) {
            pjPrintSettings.setPaperSize((PJPaperSize)intent.getSerializableExtra("pjPaperSize"));
            ((TextView)findViewById(R.id.PaperSize_value)).setText(pjPrintSettings.getPaperSize().getPaperSize().name());
        }
    }
    public void changePaperType(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changePaperType" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.PaperType e : PJPrintSettings.PaperType.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setPaperType(PJPrintSettings.PaperType.values()[which]);
                ((TextView)findViewById(R.id.PaperType_value)).setText(pjPrintSettings.getPaperType().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changePaperInsertionPosition(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changePaperInsertionPosition" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.PaperInsertionPosition e : PJPrintSettings.PaperInsertionPosition.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setPaperInsertionPosition(PJPrintSettings.PaperInsertionPosition.values()[which]);
                ((TextView)findViewById(R.id.PaperInsertionPosition_value)).setText(pjPrintSettings.getPaperInsertionPosition().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeFeedMode(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeFeedMode" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.FeedMode e : PJPrintSettings.FeedMode.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setFeedMode(PJPrintSettings.FeedMode.values()[which]);
                ((TextView)findViewById(R.id.FeedMode_value)).setText(pjPrintSettings.getFeedMode().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeExtraFeedDots(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeExtraFeedDots" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        pjPrintSettings.setExtraFeedDots(value);
                        ((TextView)findViewById(R.id.ExtraFeedDots_value)).setText(String.valueOf(value));
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
    public void changeDensity(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeDensity" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.Density e : PJPrintSettings.Density.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setDensity(PJPrintSettings.Density.values()[which]);
                ((TextView)findViewById(R.id.Density_value)).setText(pjPrintSettings.getDensity().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeRollCase(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeRollCase" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.RollCase e : PJPrintSettings.RollCase.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setRollCase(PJPrintSettings.RollCase.values()[which]);
                ((TextView)findViewById(R.id.RollCase_value)).setText(pjPrintSettings.getRollCase().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changePrintSpeed(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changePrintSpeed" );

        ArrayList<String> list = new ArrayList<>();
        for (PJPrintSettings.PrintSpeed e : PJPrintSettings.PrintSpeed.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                pjPrintSettings.setPrintSpeed(PJPrintSettings.PrintSpeed.values()[which]);
                ((TextView)findViewById(R.id.PrintSpeed_value)).setText(pjPrintSettings.getPrintSpeed().name());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeUsingCarbonCopyPaper(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeUsingCarbonCopyPaper" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    pjPrintSettings.setUsingCarbonCopyPaper(false);
                    ((TextView)findViewById(R.id.UsingCarbonCopyPaper_value)).setText("OFF");
                }
                else {
                    pjPrintSettings.setUsingCarbonCopyPaper(true);
                    ((TextView)findViewById(R.id.UsingCarbonCopyPaper_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changePrintDashLine(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changePrintDashLine" );

        ArrayList<String> list = new ArrayList<>();
        list.add("OFF");
        list.add("ON");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    pjPrintSettings.setPrintDashLine(false);
                    ((TextView)findViewById(R.id.PrintDashLine_value)).setText("OFF");
                }
                else {
                    pjPrintSettings.setPrintDashLine(true);
                    ((TextView)findViewById(R.id.PrintDashLine_value)).setText("ON");
                }
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeWorkPath(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        builder.setTitle( "changeWorkPath" );

        ArrayList<String> list = new ArrayList<>();
        list.add("In-app folder");
        list.add("External folder");

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                if ( which == 0 ) {
                    pjPrintSettings.setWorkPath(getFilesDir().getAbsolutePath());
                }
                else {
                    pjPrintSettings.setWorkPath(getExternalFilesDir(null).getAbsolutePath());
                }
                ((TextView)findViewById(R.id.WorkPath_value)).setText(pjPrintSettings.getWorkPath());
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }
    public void changeForceStretchPrintableArea(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PJPrintSetting.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeForceStretchPrintableArea" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(valueString);
                        pjPrintSettings.setForceStretchPrintableArea(value);
                        ((TextView)findViewById(R.id.ForceStretchPrintableArea_value)).setText(String.valueOf(value));
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


}