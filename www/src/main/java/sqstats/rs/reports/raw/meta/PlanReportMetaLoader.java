package sqstats.rs.reports.raw.meta;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import sqstats.rs.Utils;
import sqstats.rs.reports.xml.ReportMeta;
import sqstats.rs.reports.xml.ReportParam;

/**
 * @author moroz
 */
public class PlanReportMetaLoader implements IReportMetaLoader, FilenameFilter {
    
    public static final String REPORT_TXT_EXT = ".rpt.txt",
            REPORT_KEY_SQL = "report.sql",
            REPORT_KEY_NAME = "report.name",
            REPORT_KEY_PARAM = "report.param",
            REPORT_KEY_PARAM_SUFFIX_INDEX = "index",
            REPORT_KEY_PARAM_SUFFIX_TYPE = "sqltype";
    
    String reportDir;
    
    @Override
    public void init() throws IOException {
        reportDir = Utils.getProperty("reports.dir");
    }
    
    @Override
    public List<ReportMeta> getReportMetas() throws IOException {
        
        File rDir = new File(reportDir);
        
        if ((!rDir.isDirectory()) && (!rDir.canRead())) {
            throw new IOException("reports dir not exists or not readable");
        }
        
        File[] reportFiles = rDir.listFiles(this);
        
        ArrayList<ReportMeta> result = new ArrayList<>();
        
        for (File report : reportFiles) {
            result.add(parseFile(report));
        }
        
        return result;
    }
    
    private ReportMeta parseFile(File file) throws IOException {
        Properties props = new Properties();
        props.load(new FileInputStream(file));
        ReportMeta result = new ReportMeta();
        result.setName(props.getProperty(REPORT_KEY_NAME));
        result.setStatement(props.getProperty(REPORT_KEY_SQL));
        HashMap<Integer, ReportParam> params = new HashMap<>(3);
        Set<String> paramKeys = Utils.getOtherHierPropKeySet(REPORT_KEY_PARAM, props);
        for (String key : paramKeys) {
            ReportParam param = new ReportParam();
            String name = key.substring(REPORT_KEY_PARAM.length() + 1,
                    key.indexOf(".", REPORT_KEY_PARAM.length() + 1));
            int paramIndex=Integer.parseInt(
                        props.getProperty(REPORT_KEY_PARAM
                                +"."+name+"."+
                                REPORT_KEY_PARAM_SUFFIX_INDEX));
            int paramSqlType=Integer.parseInt(
                        props.getProperty(REPORT_KEY_PARAM
                                +"."+name+"."+
                                REPORT_KEY_PARAM_SUFFIX_TYPE));
            if (!params.containsKey(paramIndex)){
                param.setName(name);
                param.setPosInStmt(paramIndex);
                param.setSqlTypeNum(paramSqlType);
                params.put(paramIndex, param);
            }
            
        }
        result.setParams(params);
        return result;
    }
    
    @Override
    public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(REPORT_TXT_EXT.toLowerCase());
    }
    
}
