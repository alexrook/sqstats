package sqstats.rs.reports.raw.meta;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import sqstats.rs.Utils;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;
import sqstats.rs.reports.xml.ReportParam;

/**
 * @author moroz
 */
public class PlanReportMetaLoader implements IReportMetaLoader, FilenameFilter {

    public static final String REPORT_TXT_EXT = ".rpt.txt",
            REPORT_KEY_SQL = "report.sql",
            REPORT_KEY_NAME = "report.name",
            REPORT_KEY_DESC = "report.desc",
            REPORT_KEY_PARAM = "report.param",
            REPORT_KEY_PARAM_SUFFIX_INDEX = "index",
            REPORT_KEY_PARAM_SUFFIX_TYPE = "sqltype";

    String reportDir, reportsDb;

    private IReportErrorStorage errorsStorage;

    private List<ReportMeta> reportMetas;

    @Override
    public void init(IReportErrorStorage errorsStorage) throws IOException {
        this.errorsStorage = errorsStorage;
        reportDir = Utils.getProperty("reports.dir");
        reportsDb = Utils.getProperty("reports.db.file");
        fillReportMetaList();
    }

    private void fillReportMetaList() throws IOException {
        File rDir = new File(reportDir);

        if ((!rDir.isDirectory()) && (!rDir.canRead())) {
            throw new IOException("reports dir not exists or not readable");
        }

        File[] reportFiles = rDir.listFiles(this);

        reportMetas = new ArrayList<>();

        for (File report : reportFiles) {
            reportMetas.add(parseFile(report));
        }
        createDbFile(rDir);
    }

    @Override
    public List<ReportMeta> getReportMetas() {
        return reportMetas;
    }

    private boolean createDbFile(File dir) throws IOException {

        File dbFile = new File(dir, reportsDb);
        /*
         Atomically creates a new, empty file named by this abstract pathname if
         and only if a file with this name does not yet exist
         */
        return dbFile.createNewFile();

    }

    private ReportMeta parseFile(File file) {

        String reportName = "";
        ReportMeta result = new ReportMeta();
        Properties props = new Properties();
        try {
            props.load(new InputStreamReader(new FileInputStream(file), "UTF-8"));

            reportName = Utils.tryPropertyNotEmpty(REPORT_KEY_NAME, props);
            result.setName(reportName);
            result.setStatement(Utils.tryPropertyNotEmpty(REPORT_KEY_SQL, props));// try or get prop ?
            result.setDescription(props.getProperty(REPORT_KEY_DESC));

            HashMap<Integer, ReportParam> params = new HashMap<>(3);
            Set<String> paramNames = Utils.getOtherNextPropKeyFragment(REPORT_KEY_PARAM, props);
            for (String name : paramNames) {
                ReportParam param = new ReportParam();

                int paramIndex = Integer.parseInt(
                        Utils.tryPropertyNotEmpty( //index and sqltype for param must be in rpt.txt file
                                Utils.createKey(REPORT_KEY_PARAM, name, REPORT_KEY_PARAM_SUFFIX_INDEX), props
                        ));

                int paramSqlType = Integer.parseInt(
                        Utils.tryPropertyNotEmpty(
                                Utils.createKey(REPORT_KEY_PARAM, name, REPORT_KEY_PARAM_SUFFIX_TYPE), props
                        ));

                param.setName(name);
                param.setPosInStmt(paramIndex);
                param.setSqlTypeNum(paramSqlType);
                params.put(paramIndex, param);
            }

            result.setParams(params);

            parsedFile(file, props, reportName);

        } catch (IOException e) {

            String name = reportName.length() > 0 ? reportName : file.getName();//имя может быть ошибочно пропущено in rpt.txt file
            result.setName(name);
            ReportError re = new ReportError(e, e.getMessage());
            result.setError(re);
            addReportError(name, re);

        }

        return result;

    }

    //for subclassing
    protected void parsedFile(File file, Properties props, String reportName) throws IOException {

    }

    @Override
    public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(REPORT_TXT_EXT.toLowerCase());
    }

    @Override
    public boolean hasChanges() {
        File dbFile = new File(new File(reportDir), reportsDb);
        return !dbFile.exists();
    }

    private void addReportError(String name, ReportError error) {
        if (errorsStorage != null) {
            errorsStorage.addError(name, error);
        }
    }

    @Override
    public IReportErrorStorage getReportErrors() {
        return errorsStorage;
    }

}
