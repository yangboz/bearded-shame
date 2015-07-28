package bearded.shame.report.jasper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.apache.xerces.parsers.SAXParser;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles Dynamic/Jasper reports download requests
 * 
 * @author Krams at {@link http://krams915@blogspot.com}
 */
@RestController
@RequestMapping("/report")
public class ReportController
{
    public static enum DocType
    {
        PDF,
        HTML,
        XLS,
        XML,
        RTF,
        CSV,
        TXT
    }

    public String getContentType(DocType docType)
    {
        String contentType = "text/html";
        switch (docType) {
            case PDF:
                contentType = "application/pdf";
                break;
            case XLS:
                contentType = "application/vnd.ms-excel";
                break;
            case XML:
                contentType = "text/xml";
                break;
            case RTF:
                contentType = "application/rtf";
                break;
            case CSV:
                contentType = "text/plain";
                break;
            default:
                break;
        }
        return contentType;
    }

    /**
     * @throws JRException
     * @see: http://jasperreports.sourceforge.net/sample.reference/fonts/index.html Downloads the report as an PDF
     *       format.
     *       <p>
     *       Make sure this method doesn't return any model. Otherwise, you'll get an
     *       "IllegalStateException: getOutputStream() has already been called for this response"
     */
    @RequestMapping(value = "/pdf", method = RequestMethod.GET)
    public JsonObject getPDF() throws JRException
    {
        String pdfUrl = "";
        //
        long start = System.currentTimeMillis();
        // try {
        // String tempPdfUrl =
        // JasperExportManager.exportReportToPdfFile(this.getClass().getResource("/").getPath()
        // + "/reports/A4_blank.jrprint");
        // LOG.info("tempPdfUrl:" + tempPdfUrl);
        // } catch (JRException e1) {
        // // e1.printStackTrace();
        // LOG.error(e1.toString());
        // }
        //
        String jasperDestFile = JasperCompileManager.compileReportToFile(JRXML_SOURCE_FILE);
        //
        String printFileName = null;
        DataBeanList DataBeanList = new DataBeanList();
        ArrayList dataList = DataBeanList.getDataBeanList();
        JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(dataList, true);
        //
        Map parameters = new HashMap();
        System.out.println("JASPER_DEST_FILE:" + JASPER_DEST_FILE);
        try {
            printFileName = JasperFillManager.fillReportToFile(JASPER_DEST_FILE, parameters, beanColDataSource);
        } catch (Exception e) {
            System.out.println("JasperFillManager.fillReportToFile: " + e.toString());
            e.printStackTrace();
        }
        if (printFileName != null) {
            //
            SAXParser parser = new SAXParser();
            /**
             * 1- export to PDF
             */
            try {
                JasperExportManager.exportReportToPdfFile(printFileName, JASPER_REPORT_BASE + ".pdf");
                // } catch (NullPointerException ex) {
                // LOG.error("NPE encountered in body: " + ex.getStackTrace().toString());
                // } catch (Throwable ex) {
                // LOG.error("Regular Throwable: " + ex.getMessage());
            } catch (Exception e) {
                System.out.println("JasperExportManager.exportReportToPdfFile: " + e.getClass().toString()
                    + e.getStackTrace().toString());
                e.printStackTrace();
            }
            pdfUrl = JASPER_REPORT_BASE + ".pdf";
            /**
             * 2- export to HTML
             */
            // JasperExportManager.exportReportToHtmlFile(printFileName, JASPER_REPORT_BASE + ".html");

            /**
             * 3- export to Excel sheet
             */
            // JRXlsExporter exporter = new JRXlsExporter();

            // exporter.setParameter(JRExporterParameter.INPUT_FILE_NAME, printFileName);
            // exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, JASPER_REPORT_BASE + ".xls");

            // exporter.exportReport();
        }
        System.out.println("PDF creation time : " + (System.currentTimeMillis() - start));
        // e.g. http://localhost:8082/api/reports/com.rushucloud.eip.reports.FastReport.pdf
        System.out.println("fastReport data(after PDF generate):" + pdfUrl);
        return new JsonObject(pdfUrl);
    }

    public String getClassPath()
    {
        String classPath = this.getClass().getResource("/").getPath();
        return classPath;
    }

    private final String JASPER_REPORT_BASE = getClassPath() + "reports/jasper_report_template";

    private final String JRXML_SOURCE_FILE = JASPER_REPORT_BASE + ".jrxml";

    private final String JASPER_DEST_FILE = JASPER_REPORT_BASE + ".jasper";

    // @ExceptionHandler(IllegalArgumentException.class)
    // public void handleBadRequests(HttpServletResponse response) throws IOException
    // {
    // response.sendError(HttpStatus.BAD_REQUEST.value(), response.toString());
    // }
}
