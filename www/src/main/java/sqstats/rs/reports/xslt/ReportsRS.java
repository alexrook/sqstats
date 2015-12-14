package sqstats.rs.reports.xslt;

import java.util.Map;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import sqstats.rs.AbstractRS;
import sqstats.rs.reports.ReportService;
import sqstats.rs.reports.raw.RawXmlReport;

/**
 * @author moroz
 */
@Path("/xslt")
public class ReportsRS extends AbstractRS {
    
    @EJB
    ReportService reportService;
    
    @GET
    @Path("{name:\\w+}")
    @Produces(MediaType.APPLICATION_XML)
    public Response getReportForName(@PathParam("name") String name,
            @Context UriInfo uriInfo, @Context HttpHeaders headers) {
        
        Report report;
        
        report = reportService.getReport(name);
        
        if (report != null) {
            
            report.setRaw(false);
            passReportParams(report, uriInfo.getQueryParameters());
            
            return Response.ok(report).type(report.getXsltMeta().getContentType()).build();
            
        } else {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        
    }
    
    @GET
    @Path("reports")
    @Produces(MediaType.APPLICATION_XML)
    public Map<String, RawXmlReport> getReportList() {
        return reportService.getReports();
    }
    
}
