package com.brother.ptouch.sdk.printdemo;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import android.app.AlertDialog;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.brother.sdk.lmprinter.setting.PJCustomPaperSize;
import com.brother.sdk.lmprinter.setting.PJPaperSize;

public class Activity_PrintSettingPJPaperSize extends Activity {

    public PJPaperSize.PaperSize paperSize;
    public PJCustomPaperSize pjCustomPaperSize;

    private LayoutInflater layoutInflater;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_print_setting_pj_paper_size);
        Intent intent = getIntent();
        layoutInflater = (LayoutInflater)this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        PJPaperSize pjPaperSize = (PJPaperSize)intent.getSerializableExtra("pjPaperSize");
        
        paperSize = pjPaperSize.getPaperSize();
        pjCustomPaperSize = pjPaperSize.getCustomPaperSize();

        refreshLayout(paperSize);

        int id = getResources().getIdentifier(paperSize.name(), "id", getPackageName());
        RadioGroup radioGroup_paperSize = ((RadioGroup)findViewById(R.id.PaperSize));
        radioGroup_paperSize.check(id);
        radioGroup_paperSize.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                // チェックされた状態の時の処理を記述
                if (checkedId != -1) {
                    switch (checkedId) {
                        case R.id.A4:
                            paperSize = PJPaperSize.PaperSize.A4; break;
                        case R.id.A5:
                            paperSize = PJPaperSize.PaperSize.A5; break;
                        case R.id.A5_Landscape:
                            paperSize = PJPaperSize.PaperSize.A5_Landscape; break;
                        case R.id.Letter:
                            paperSize = PJPaperSize.PaperSize.Letter; break;
                        case R.id.Legal:
                            paperSize = PJPaperSize.PaperSize.Legal; break;
                        case R.id.Custom:
                            paperSize = PJPaperSize.PaperSize.Custom; break;
                    }
                    refreshLayout(paperSize);
                }
            }
        });

    }

    public void onBackPressed() {
        Intent intentSub = new Intent();
        PJPaperSize pjPaperSize = null;
        if (paperSize == PJPaperSize.PaperSize.Custom) {
            pjPaperSize = PJPaperSize.newCustomPaper(pjCustomPaperSize);
        }
        else {
            pjPaperSize = PJPaperSize.newPaperSize(paperSize);
        }
        intentSub.putExtra("pjPaperSize", pjPaperSize);

        setResult(RESULT_OK, intentSub);

        super.onBackPressed();
    }


    public String StringOfCustomSize(PJCustomPaperSize customPaperSize) {
        return String.format("(%d, %d)", customPaperSize.getWidthDots(), customPaperSize.getLengthDots());
    }

    public void refreshLayout(PJPaperSize.PaperSize paperSize) {
        LinearLayout layout = (LinearLayout)findViewById(R.id.layout);
        layout.removeAllViews();
        if (pjCustomPaperSize == null) {
            pjCustomPaperSize = new PJCustomPaperSize(2400,3300);
        }
        if (paperSize == PJPaperSize.PaperSize.Custom) {
            layoutInflater.inflate(R.layout.pj_custom_paper, layout);
            ((TextView)findViewById(R.id.CustomPaperSize_value)).setText(StringOfCustomSize(pjCustomPaperSize));
        }
    }

    public void changeCustomPaperSize(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(Activity_PrintSettingPJPaperSize.this);

        View input_dialog_margins = layoutInflater.inflate( R.layout.input_dialog_pj_custom_paper, null );

        final EditText widthDotsValueText = (EditText) input_dialog_margins.findViewById(R.id.widthDots_value);
        final EditText lengthDotsValueText = (EditText) input_dialog_margins.findViewById(R.id.lengthDots_value);

        widthDotsValueText.setHint(String.valueOf(pjCustomPaperSize.getWidthDots()));
        lengthDotsValueText.setHint(String.valueOf(pjCustomPaperSize.getLengthDots()));

        builder.setTitle( "changeCustomPaperSize" );
        builder.setView( input_dialog_margins );
        builder.setPositiveButton("OK" , new  DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                String widthDotsString = widthDotsValueText.getText().toString();
                String lengthDotsString = lengthDotsValueText.getText().toString();
                int widthDots = pjCustomPaperSize.getWidthDots();
                int lengthDots = pjCustomPaperSize.getLengthDots();
                if (widthDotsString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(widthDotsString);
                        widthDots = value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                if (lengthDotsString.length() > 0 ) {
                    try {
                        int value = Integer.parseInt(lengthDotsString);
                        lengthDots = value;
                    }
                    catch (NumberFormatException e) { /* nop */ }
                }
                pjCustomPaperSize = new PJCustomPaperSize(widthDots, lengthDots);
                ((TextView)findViewById(R.id.CustomPaperSize_value)).setText(StringOfCustomSize(pjCustomPaperSize));
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