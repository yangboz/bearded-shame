/*
 * Copyright 2015 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * All rights reserved.
 */
package info.smartkit.jreport.jrxml.demo;

import info.smartkit.jreport.jrxml.demo.pojo.DataBeanList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRXlsExporter;

/**
 * Application entry point
 * 
 * @author yangboz
 */
public class JasperReportFill
{
    public static String getClassPath()
    {
        String classPath = JasperReportFill.class.getResource("/").getPath();
        return classPath;
    }

    private final static String JASPER_REPORT_BASE = getClassPath() + "jasper_report_template2";

    private final static String JRXML_SOURCE_FILE = JASPER_REPORT_BASE + ".jrxml";

    private final static String JASPER_DEST_FILE = JASPER_REPORT_BASE + ".jasper";

    @SuppressWarnings("unchecked")
    public static void main(String[] args) throws JRException
    {
        // JasperCompileManager.compileReportToFile(JRXML_SOURCE_FILE, JASPER_DEST_FILE);
        String jasperDestFile = JasperCompileManager.compileReportToFile(JRXML_SOURCE_FILE);
        //
        String printFileName = null;
        DataBeanList DataBeanList = new DataBeanList();
        ArrayList dataList = DataBeanList.getDataBeanList();
        JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(dataList, true);

        Map parameters = new HashMap();
        long start = System.currentTimeMillis();
        try {
        	// 增加子报表的路径(所以主报表必须和子报表放在同一个目录下)
    		//String subReportPath = reportPath.substring(0, reportPath.lastIndexOf("/") + 1);
    		parameters.put("SUBREPORT_DIR", getClassPath());

    		// 实现显示报表不分页（true：模板中的page break不生效，不能强制分页；false：可以强制分页）
    		parameters.put("IS_IGNORE_PAGINATION", Boolean.FALSE);
    		
    		Map subParameters = new HashMap();
    		subParameters.put("data", dataList);
    		parameters.put("beanData", subParameters);

    		
            printFileName = JasperFillManager.fillReportToFile(JASPER_DEST_FILE, parameters, beanColDataSource);
            if (printFileName != null) {
                /**
                 * 1- export to PDF
                 */
                JasperExportManager.exportReportToPdfFile(printFileName, JASPER_REPORT_BASE + ".pdf");

                /**
                 * 2- export to HTML
                 */
                JasperExportManager.exportReportToHtmlFile(printFileName, JASPER_REPORT_BASE + ".html");

                /**
                 * 3- export to Excel sheet
                 */
                JRXlsExporter exporter = new JRXlsExporter();

                exporter.setParameter(JRExporterParameter.INPUT_FILE_NAME, printFileName);
                exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, JASPER_REPORT_BASE + ".xls");

                exporter.exportReport();
            }
        } catch (JRException e) {
            e.printStackTrace();
        }
        // test
        System.err.println("JasperReport Filling time : " + (System.currentTimeMillis() - start));
    }
}
