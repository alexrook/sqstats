package sqstats.rs.reports.raw;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.sql.DataSource;
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

            //TODO: check&create reports metafile in reports dir, for loading reports list
            RawXmlReport report = new RawXmlReport();
            ReportMeta meta = new ReportMeta();
            meta.setName("vr_xml_day_sums");
            meta.setStatement("select * from vr_xml_day_sums");
            report.setMeta(meta);

            reports.put(meta.getName(), report);

        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

}
