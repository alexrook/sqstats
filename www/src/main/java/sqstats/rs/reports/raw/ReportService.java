package sqstats.rs.reports.raw;

import java.util.HashMap;
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

    public static class MapErrorStorage
            implements IReportMetaLoader.IReportErrorStorage,
            RawXmlReport.IRawXmlReportEventListener {

        private final Map<String, ReportError> storage = new HashMap<>(3);

        @Override
        public void addError(String name, ReportError error) {
            storage.put(name, error);
        }

        @Override
        public ReportError getError(String name) {
            return storage.get(name);
        }

        @Override
        public Map<String, ReportError> getErrorsMap() {
            return storage;
        }

        @Override
        public void onError(String name, Exception e) {
            this.addError(name, new ReportError(e, e.getMessage()));
        }

        @Override
        public void clear() {
            storage.clear();
        }

    }
    @Resource(lookup = "java:jboss/datasources/sqstatsDS")
    DataSource dataSource;

    ServiceLoader<IReportMetaLoader> slReportMetaLoader;

    private final Map<String, RawXmlReport> reports = new HashMap<>(12);
    private final MapErrorStorage reportErrors = new MapErrorStorage();

    public Map<String, ReportError> getErrors() {
        return reportErrors.getErrorsMap();
    }

    public Map<String, RawXmlReport> getReports() {
        return reports;
    }

    public RawXmlReport getRawXmlReport(String name) {
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

    public void addError(String name, ReportError re) {
        reportErrors.addError(name, re);

    }

    @PostConstruct
    private void init() {
        try {

            slReportMetaLoader
                    = ServiceLoader.load(IReportMetaLoader.class);

            reportErrors.clear();
            
            for (IReportMetaLoader rml : slReportMetaLoader) {

                rml.init(reportErrors);

                for (ReportMeta rmeta : rml.getReportMetas()) {
                    RawXmlReport report = new RawXmlReport();
                    report.setMeta(rmeta);
                    report.addListener(reportErrors);
                    reports.put(rmeta.getName(), report);
                }

            }

        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

}
