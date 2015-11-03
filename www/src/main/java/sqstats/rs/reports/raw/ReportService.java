package sqstats.rs.reports.raw;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.ServiceLoader;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.sql.DataSource;
import sqstats.rs.reports.raw.meta.IReportMetaLoader;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
@Singleton
public class ReportService {

    

    @Resource(lookup = "java:jboss/datasources/sqstatsDS")
    DataSource dataSource;

    private final Map<String, RawXmlReport> reports = new HashMap<>(12);

    public Map<String, RawXmlReport> getReports() {
        return reports;
    }

    public RawXmlReport getRawXmlReport(String name) throws SQLException {
        return getRawXmlReport(name, System.lineSeparator());
    }

    public RawXmlReport getRawXmlReport(String name, String lineSeparator) throws SQLException {
        RawXmlReport result = reports.get(name);
        if (result != null) {
            result.setDataSource(dataSource);
            result.setLineSeparator(lineSeparator);
        }
        return result;
    }

    @PostConstruct
    private void init() {
        try {

            ServiceLoader<IReportMetaLoader> sl
                    = ServiceLoader.load(IReportMetaLoader.class);

            for (IReportMetaLoader rml : sl) {

                rml.init();

                for (ReportMeta rmeta : rml.getReportMetas()) {
                    RawXmlReport report = new RawXmlReport();
                    report.setMeta(rmeta);
                    reports.put(rmeta.getName(), report);
                }

            }
           
        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

}
