package sqstats.rs.reports.raw;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ServiceLoader;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.sql.DataSource;
import sqstats.rs.reports.raw.meta.IReportMetaLoader;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
@Singleton
public class ReportService {

    @Resource(lookup = "java:jboss/datasources/sqstatsDS")
    DataSource dataSource;

    ServiceLoader<IReportMetaLoader> slReportMetaLoader;

    private final Map<String, RawXmlReport> reports = new HashMap<>(12);
    private final Map<Integer, ReportError> reportErrors = new HashMap<>(3);
    
    int errCounter=0;

    public Map<Integer, ReportError> getErrors() {
        return reportErrors;
    }

    public Map<String, RawXmlReport> getReports() {
        return reports;
    }

    public RawXmlReport getRawXmlReport(String name)  {
        return getRawXmlReport(name, System.lineSeparator());
    }

    public RawXmlReport getRawXmlReport(String name, String lineSeparator) {

        for (IReportMetaLoader rml : slReportMetaLoader) {
            if (rml.hasChanges()) {
                init();
            }
        }

        RawXmlReport result = reports.get(name);
        if (result != null) {
            result.setDataSource(dataSource);
            result.setLineSeparator(lineSeparator);
        }
        return result;
    }

    public void addError(ReportError re){
       reportErrors.put(errCounter, re);
       errCounter++;
    }
    
    @PostConstruct
    private void init() {
        try {

            slReportMetaLoader
                    = ServiceLoader.load(IReportMetaLoader.class);

          
            for (IReportMetaLoader rml : slReportMetaLoader) {

                rml.init();

                for (ReportMeta rmeta : rml.getReportMetas()) {
                    RawXmlReport report = new RawXmlReport();
                    report.setMeta(rmeta);
                    reports.put(rmeta.getName(), report);
                }

                List<ReportError> rmlErr = rml.getReportErrors();
                if (rmlErr != null) {
                    for (ReportError re : rmlErr) {
                        reportErrors.put(errCounter, re);
                    }
                    errCounter++;
                }

            }

        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

}
