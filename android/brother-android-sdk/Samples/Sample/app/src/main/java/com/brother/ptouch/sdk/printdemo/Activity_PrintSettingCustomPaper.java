package com.brother.ptouch.sdk.printdemo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import android.app.AlertDialog;

import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.brother.ptouch.sdk.CustomPaperInfo;
import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.printdemo.common.Common;
import com.brother.sdk.lmprinter.setting.CustomPaperSize;
import com.brother.sdk.lmprinter.setting.PTPrintSettings;

import java.util.ArrayList;

public class Activity_PrintSettingCustomPaper extends Activity {

    public CustomPaperSize.PaperKind paperKind;
    public CustomPaperSize.Unit unit;
    public CustomPaperSize.Margins margins;
    public float width;
    public float length;
    public float gapLength;
    public float markVerticalOffset;
    public float markLength;
    public String filePath;

    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_print_setting_custom_paper);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        CustomPaperSize customPaperSize = (CustomPaperSize)intent.getSerializableExtra("customPaperSize");
        
        paperKind = customPaperSize.getPaperKind();
        unit = customPaperSize.getUnit();
        margins = customPaperSize.getMargins();
        width = customPaperSize.getWidth();
        length = customPaperSize.getLength();
        gapLength = customPaperSize.getGapLength();
        markVerticalOffset = customPaperSize.getMarkVerticalOffset();
        markLength = customPaperSize.getMarkLength();
        filePath = customPaperSize.getPaperBinFilePath();

        if (width == 0) {
            width = 2;
        }
        if (length == 0) {
            length = 2;
        }
        if (gapLength == 0) {
            gapLength = 0.28f;
        }
        if (markLength == 0) {
            markLength = 0.4f;
        }

        refreshLayout(paperKind);

        int id = getResources().getIdentifier(paperKind.name(), "id", getPackageName());
        RadioGroup radioGroup_paperKind = ((RadioGroup)findViewById(R.id.PaperKind));
        radioGroup_paperKind.check(id);
        radioGroup_paperKind.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                // チェックされた状態の時の処理を記述
                if (checkedId != -1) {
                    switch (checkedId) {
                        case R.id.Roll:
                            paperKind = CustomPaperSize.PaperKind.Roll; break;
                        case R.id.DieCut:
                            paperKind = CustomPaperSize.PaperKind.DieCut; break;
                        case R.id.MarkRoll:
                            paperKind = CustomPaperSize.PaperKind.MarkRoll; break;
                        case R.id.ByFile:
                            paperKind = CustomPaperSize.PaperKind.ByFile; break;
                    }
                    refreshLayout(paperKind);
                }
            }
        });

    }

    public void onBackPressed() {
        Intent intentSub = new Intent();
        CustomPaperSize customPaperSize = null;
        switch (paperKind) {
            case Roll:
                customPaperSize = CustomPaperSize.newRollPaperSize(width, margins, unit); break;
            case DieCut:
                customPaperSize = CustomPaperSize.newDieCutPaperSize(width, length, margins, gapLength, unit); break;
            case MarkRoll:
                customPaperSize = CustomPaperSize.newMarkRollPaperSize(width, length, margins, markVerticalOffset, markLength, unit); break;
            case ByFile:
                customPaperSize = CustomPaperSize.newFile(filePath); break;
        }
        intentSub.putExtra("customPaperSize", customPaperSize);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }


    public String StringOfMargins(CustomPaperSize.Margins margins) {
        return String.format("(%.2f, %.2f, %.2f, %.2f)", margins.top, margins.left, margins.bottom, margins.right);
    }

    public void refreshLayout(CustomPaperSize.PaperKind paperKind) {
        LinearLayout layout = (LinearLayout)findViewById(R.id.layout);
        switch (paperKind) {
            case Roll:
                layout.removeAllViews();
                layoutInflater.inflate(R.layout.custom_paper_tape_width, layout);
                layoutInflater.inflate(R.layout.custom_paper_margins, layout);
                layoutInflater.inflate(R.layout.custom_paper_unit, layout);
                ((TextView)findViewById(R.id.TapeWidth_value)).setText(String.valueOf(width));
                ((TextView)findViewById(R.id.Margins_value)).setText(StringOfMargins(margins));
                ((TextView)findViewById(R.id.Unit_value)).setText(String.valueOf(unit));
                break;
            case DieCut:
                layout.removeAllViews();
                layoutInflater.inflate(R.layout.custom_paper_tape_width, layout);
                layoutInflater.inflate(R.layout.custom_paper_tape_length, layout);
                layoutInflater.inflate(R.layout.custom_paper_margins, layout);
                layoutInflater.inflate(R.layout.custom_paper_gap_length, layout);
                layoutInflater.inflate(R.layout.custom_paper_unit, layout);
                ((TextView)findViewById(R.id.TapeWidth_value)).setText(String.valueOf(width));
                ((TextView)findViewById(R.id.TapeLength_value)).setText(String.valueOf(length));
                ((TextView)findViewById(R.id.Margins_value)).setText(StringOfMargins(margins));
                ((TextView)findViewById(R.id.GapLength_value)).setText(String.valueOf(gapLength));
                ((TextView)findViewById(R.id.Unit_value)).setText(String.valueOf(unit));
                break;
            case MarkRoll:
                layout.removeAllViews();
                layoutInflater.inflate(R.layout.custom_paper_tape_width, layout);
                layoutInflater.inflate(R.layout.custom_paper_tape_length, layout);
                layoutInflater.inflate(R.layout.custom_paper_margins, layout);
                layoutInflater.inflate(R.layout.custom_paper_mark_vertical_offset, layout);
                layoutInflater.inflate(R.layout.custom_paper_mark_length, layout);
                layoutInflater.inflate(R.layout.custom_paper_unit, layout);
                ((TextView)findViewById(R.id.TapeWidth_value)).setText(String.valueOf(width));
                ((TextView)findViewById(R.id.TapeLength_value)).setText(String.valueOf(length));
                ((TextView)findViewById(R.id.Margins_value)).setText(StringOfMargins(margins));
                ((TextView)findViewById(R.id.MarkVerticalOffset_value)).setText(String.valueOf(markVerticalOffset));
                ((TextView)findViewById(R.id.MarkLength_value)).setText(String.valueOf(markLength));
                ((TextView)findViewById(R.id.Unit_value)).setText(String.valueOf(unit));
                break;
            case ByFile:
                layout.removeAllViews();
                layoutInflater.inflate(R.layout.custom_paper_file_path, layout);
                ((TextView)findViewById(R.id.FilePath_value)).setText(filePath);
                break;
        }
    }


    public void changeTapeWidth(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeTapeWidth" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        width = value;
                        ((TextView)findViewById(R.id.TapeWidth_value)).setText(String.valueOf(value));
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

    public void changeTapeLength(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeTapeLength" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        length = value;
                        ((TextView)findViewById(R.id.TapeLength_value)).setText(String.valueOf(value));
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

    public void changeGapLength(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeGapLength" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        gapLength = value;
                        ((TextView)findViewById(R.id.GapLength_value)).setText(String.valueOf(value));
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

    public void changeMarkVerticalOffset(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeMarkVerticalOffset" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        markVerticalOffset = value;
                        ((TextView)findViewById(R.id.MarkVerticalOffset_value)).setText(String.valueOf(value));
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

    public void changeMarkLength(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_number = layoutInflater.inflate( R.layout.input_dialog_number, null );

        final EditText valueText = (EditText) input_dialog_number.findViewById(R.id.value);

        builder.setTitle( "changeMarkLength" );
        builder.setView( input_dialog_number );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String valueString = valueText.getText().toString();
                if (valueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(valueString);
                        markLength = value;
                        ((TextView)findViewById(R.id.MarkLength_value)).setText(String.valueOf(value));
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

    public void changeUnit(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        builder.setTitle( "changeUnit" );

        ArrayList<String> list = new ArrayList<>();
        for (CustomPaperSize.Unit e : CustomPaperSize.Unit.values()) {
            list.add(e.name());
        }

        builder.setItems(list.toArray(new CharSequence[list.size()])
                , new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        unit = CustomPaperSize.Unit.values()[which];
                        ((TextView)findViewById(R.id.Unit_value)).setText(unit.name());
                    }
                });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeMargins(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingCustomPaper.this);

        View input_dialog_margins = layoutInflater.inflate( R.layout.input_dialog_margins, null );

        final EditText topValueText = (EditText) input_dialog_margins.findViewById(R.id.top_value);
        final EditText bottomValueText = (EditText) input_dialog_margins.findViewById(R.id.bottom_value);
        final EditText leftValueText = (EditText) input_dialog_margins.findViewById(R.id.left_value);
        final EditText rightValueText = (EditText) input_dialog_margins.findViewById(R.id.right_value);

        topValueText.setHint(String.valueOf(margins.top));
        bottomValueText.setHint(String.valueOf(margins.bottom));
        leftValueText.setHint(String.valueOf(margins.left));
        rightValueText.setHint(String.valueOf(margins.right));

        builder.setTitle( "changeMargins" );
        builder.setView( input_dialog_margins );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String topValueString = topValueText.getText().toString();
                String bottomValueString = bottomValueText.getText().toString();
                String leftValueString = leftValueText.getText().toString();
                String rightValueString = rightValueText.getText().toString();
                if (topValueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(topValueString);
                        margins.top = value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                if (bottomValueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(bottomValueString);
                        margins.bottom= value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                if (leftValueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(leftValueString);
                        margins.left = value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                if (rightValueString.length() > 0 ) {
                    try {
                        float value = Float.parseFloat(rightValueString);
                        margins.right = value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                ((TextView)findViewById(R.id.Margins_value)).setText(StringOfMargins(margins));
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


    public void changeFilePath(View view) {

        // call File Explorer Activity to select a image or prn file
        final Intent fileList = new Intent(Activity_PrintSettingCustomPaper.this,
                Activity_FileList.class);
        fileList.putExtra(Common.INTENT_TYPE_FLAG, Common.FILE_SELECT_PRN_IMAGE);
        fileList.putExtra(Common.INTENT_FILE_NAME, filePath);
        startActivityForResult(fileList, Common.FILE_SELECT_PRN_IMAGE);
    }

    protected void onActivityResult(final int requestCode,
                                    final int resultCode, final Intent data) {

        super.onActivityResult(requestCode, resultCode, data);

        // set the image/prn file
        if (resultCode == RESULT_OK
                && requestCode == Common.FILE_SELECT_PRN_IMAGE) {
            filePath = data.getStringExtra(Common.INTENT_FILE_NAME);
            ((TextView)findViewById(R.id.FilePath_value)).setText(filePath);
        }
    }
}