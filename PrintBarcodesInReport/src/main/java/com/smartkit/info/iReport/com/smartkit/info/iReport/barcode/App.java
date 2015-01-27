package com.smartkit.info.iReport.com.smartkit.info.iReport.barcode;

import java.io.File;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.web.bind.annotation.RestController;

@RestController
@EnableAutoConfiguration
/**
 * Hello world!
 *
 */
public class App
{
    public static void main(String[] args) throws Exception
    {
        SpringApplication.run(App.class, args);
        //
        // path of the folder where .jrxml file is present
        final String PATH = "/Users/yangboz/Documents/Git/bearded-shame/PrintBarcodesInReport/";
        String jrxmlFileName = PATH + "BarcodeReport.jrxml";
        String fillFileName = PATH + "BarcodeReport.jasper";

        try {
            // compile the .jrxml file to create .jasper file
            JasperCompileManager.compileReportToFile(jrxmlFileName, fillFileName);
            System.out.println(jrxmlFileName + " - File compiled successfully.");

            File reportFile = new File(fillFileName);

            JasperPrint jasperPrint = JasperFillManager.fillReport(fillFileName, null, new JREmptyDataSource());

            // export the report in pdf format
            JRPdfExporter exporter = new JRPdfExporter();
            File destFile = new File(reportFile.getParent(), jasperPrint.getName() + ".pdf");
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());
            exporter.exportReport();

            System.out.println("Report exported to " + destFile.getAbsolutePath());
            System.out.println("Finished.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
