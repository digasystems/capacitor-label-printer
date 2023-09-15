package com.brother.sample_v4

import android.os.Bundle
import android.os.FileUtils
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.brother.sdk.lmprinter.*
import com.brother.sdk.lmprinter.setting.QLPrintSettings
import java.io.File

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var button = findViewById<Button>(R.id.printImage)
        button.setOnClickListener {
            Thread {
                printImage()
            }.start()
        }
    }

    //Exapmle of QL-820NWB
    fun printImage() {
        //Input your printer's IP address
        val channel: Channel = Channel.newWifiChannel("IP address")
        //Input your printer's macAddress
        // val channel: Channel = Channel.newBluetoothChannel(macAddress, BluetoothAdapter.getDefaultAdapter())
        val result: PrinterDriverGenerateResult = PrinterDriverGenerator.openChannel(channel)
        if (result.error.code !== OpenChannelError.ErrorCode.NoError) {
            Log.e("", "Error - Open Channel: " + result.error.code)
            return
        }
        val printerDriver = result.driver
        //Change here for your printer
        val printSettings = QLPrintSettings(PrinterModel.QL_820NWB)
        printSettings.labelSize = QLPrintSettings.LabelSize.DieCutW17H54
        printSettings.workPath = filesDir.absolutePath

        var file = File.createTempFile("tmp", ".png", externalCacheDir)
         assets.open("sample.png").use {  input ->
             file.outputStream().use { output ->
                 FileUtils.copy(input, output)
             }
         }

        val printError: PrintError = printerDriver.printImage(file.path, printSettings)
        if (printError.code != PrintError.ErrorCode.NoError) {
            Log.d("", "Error - Print Image: " + printError.code);
        }
        else {
            Log.d("", "Success - Print Image");
        }
        printerDriver.closeChannel();
    }
}