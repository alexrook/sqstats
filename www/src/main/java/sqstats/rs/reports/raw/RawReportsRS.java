package sqstats.rs.reports.raw;

import java.util.Map;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import sqstats.rs.AbstractRS;
import sqstats.rs.reports.xml.ReportError;

/**
 * @author moroz
 */
@Path("/raw")
public class RawReportsRS extends AbstractRS {

    @EJB
    ReportService reportService;

    @GET
    @Path("errors")
    @Produces(MediaType.APPLICATION_XML)
    public Map<Integer, ReportError> getErrors() {
        return reportService.getErrors();
    }

    @GET
    @Path("{name:\\w+}")
    @Produces(MediaType.APPLICATION_XML)
    public Response getReportForName(@PathParam("name") String name, @Context HttpHeaders headers) {

        RawXmlReport rawReport;

        rawReport = reportService.getRawXmlReport(name);
        if (rawReport != null) {
            if (rawReport.isValid()) {
                try {
                    return Response.ok(rawReport).build();
                } catch (Exception e) {
                    reportService.addError(new ReportError(e, e.getMessage()));
                    throw e;
                }
            } else {
                return Response.serverError().entity(rawReport).build();
            }
        } else {
            return Response.status(Response.Status.NOT_FOUND).build();
        }

    }

    @GET
    @Path("reports")
    @Produces(MediaType.APPLICATION_XML)
    public Map<String, RawXmlReport> getRawReportList() {
        return reportService.getReports();
    }

}
