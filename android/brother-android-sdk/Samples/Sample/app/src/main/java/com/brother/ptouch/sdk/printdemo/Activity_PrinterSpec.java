package com.brother.ptouch.sdk.printdemo;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.brother.sdk.lmprinter.PrinterModel;
import com.brother.sdk.lmprinter.PrinterModelSpec;

import java.util.ArrayList;

public class Activity_PrinterSpec extends ListActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_printer_spec);

        ArrayList<String> items = new ArrayList<>();
        for (PrinterModel model: PrinterModel.values()) {
            items.add(model.name() + "\n");
        }

        ArrayAdapter<String> fileList = new ArrayAdapter<String>(
                Activity_PrinterSpec.this,
                android.R.layout.test_list_item, items);
        Activity_PrinterSpec.this.setListAdapter(fileList);

        this.setTitle(R.string.text_printer_spec);
    }
    @Override
    protected void onListItemClick(ListView listView, View view, int position,
                                   long id) {

        final PrinterModel model = PrinterModel.values()[position];

        PrinterModelSpec spec = new PrinterModelSpec(model);

        String specString = "";
        specString += "X dpi : "+ spec.getXdpi() + "\n";
        specString += "Y dpi : "+ spec.getYdpi() + "\n";

        Intent intent = new Intent(this, Activity_ScrollingText.class);
        intent.putExtra(Intent.EXTRA_TEXT, specString);
        startActivity(intent);
    }
}
