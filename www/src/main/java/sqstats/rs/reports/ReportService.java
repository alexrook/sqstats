package sqstats.rs.reports;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ServiceLoader;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.sql.DataSource;
import sqstats.rs.reports.raw.RawXmlReport;
import sqstats.rs.reports.raw.meta.IReportMetaLoader;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;
import sqstats.rs.reports.xslt.meta.IReportXsltMetaLoader;
import sqstats.rs.reports.xslt.Report;

/**
 * @author moroz
 */
@Singleton
public class ReportService {

    public static final int MAX_ERRORS_SIZE = 7;

    public static class MapErrorStorage
            implements IReportMetaLoader.IReportErrorStorage,
            RawXmlReport.IRawXmlReportEventListener {

        private final Map<String, ReportError> storage = new LinkedHashMap<String, ReportError>(MAX_ERRORS_SIZE) {

            @Override
            protected boolean removeEldestEntry(Map.Entry<String, ReportError> eldest) {
                return size() > MAX_ERRORS_SIZE;//simple LRU cache
            }

        };

        @Override
        public synchronized void addError(String name, ReportError error) {
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
        public synchronized void clear() {
            storage.clear();
        }

    }
    @Resource(lookup = "java:jboss/datasources/sqstatsDS")
    DataSource dataSource;

    ServiceLoader<IReportMetaLoader> slReportMetaLoader;

    private final Map<String, RawXmlReport> reports = new HashMap<>(12);
    private final MapErrorStorage reportErrors = new MapErrorStorage();

    public Map<String, ReportError> getErrors() {

        checkChanges();

        return reportErrors.getErrorsMap();
    }

    public Map<String, RawXmlReport> getReports() {

        checkChanges();

        return reports;
    }

    public RawXmlReport getRawXmlReport(String name) {
        return getRawXmlReport(name, System.lineSeparator());
    }

    public RawXmlReport getRawXmlReport(String name, String lineSeparator) {

        checkChanges();

        RawXmlReport result = reports.get(name);
        if (result != null) {
            result.setDataSource(dataSource);
            result.setLineSeparator(lineSeparator);
        }
        return result;
    }

    public Report getReport(String name) {
        return getReport(name, System.lineSeparator());
    }

    public Report getReport(String name, String lineSeparator) {

        checkChanges();

        Object result = reports.get(name);
        if ((result != null) && (result instanceof Report)) {

            ((Report) result).setDataSource(dataSource);
            ((Report) result).setLineSeparator(lineSeparator);

            return (Report) result;
        } else {
            return null;
        }

    }

    public void addError(String name, ReportError re) {
        reportErrors.addError(name, re);

    }

    @PostConstruct
    private synchronized void init() {
        try {

            slReportMetaLoader
                    = ServiceLoader.load(IReportMetaLoader.class);

            reportErrors.clear();

            for (IReportMetaLoader rml : slReportMetaLoader) {

                rml.init(reportErrors);
                if (rml instanceof IReportXsltMetaLoader) {
                    for (ReportMeta rmeta : rml.getReportMetas()) {
                        Report report = new Report();
                        report.setMeta(rmeta);
                        report.addListener(reportErrors);
                        report.setXsltMeta(((IReportXsltMetaLoader) rml).getXsltMeta(rmeta.getName()));
                        reports.put(rmeta.getName(), report);
                    }
                } else {
                    for (ReportMeta rmeta : rml.getReportMetas()) {
                        RawXmlReport report = new RawXmlReport();
                        report.setMeta(rmeta);
                        report.addListener(reportErrors);
                        reports.put(rmeta.getName(), report);
                    }
                }

            }

        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

    private void checkChanges() {
        for (IReportMetaLoader rml : slReportMetaLoader) {
            if (rml.hasChanges()) {
                init();
            }
        }
    }
}
