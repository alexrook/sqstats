package sqstats.rs.reports.xslt;

import javax.ejb.EJB;
import javax.ws.rs.Path;
import sqstats.rs.reports.raw.ReportService;

/**
 * @author moroz
 */
@Path("/xslt")
public class ReportsRS {

    @EJB
    ReportService reportService;
    
}
