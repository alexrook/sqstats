package sqstats.rs.reports.raw;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

    public RawXmlReport getRawXmlReport(String name) {
        return reports.get(name);
   }

    @PostConstruct
    private void init() {
        try (Connection conn = dataSource.getConnection()) {

            //TODO: check&create reports metafile in reports dir, for loading reports list
            RawXmlReport report = new RawXmlReport();

            PreparedStatement ps = conn.prepareStatement("select * from v_test");
            report.setStatement(ps);

            ReportMeta meta = new ReportMeta();
            meta.setName("v_test");
            meta.setStatement("select * from v_test");
            report.setMeta(meta);

            reports.put(meta.getName(), report);

        } catch (Exception e) {
            throw new RuntimeException("error while initializing report service");
        }

    }

}
