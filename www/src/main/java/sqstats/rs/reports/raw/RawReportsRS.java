package sqstats.rs.reports.raw;

import java.util.Map;
import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import sqstats.rs.AbstractRS;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;

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
    public Map<String, ReportError> getErrors() {
        return reportService.getErrors();
    }

    @GET
    @Path("{name:\\w+}")
    @Produces(MediaType.APPLICATION_XML)
    public Response getReportForName(@PathParam("name") String name,
            @Context UriInfo uriInfo, @Context HttpHeaders headers) {

        RawXmlReport rawReport;

        rawReport = reportService.getRawXmlReport(name);

        if (rawReport != null) {

            passReportParams(rawReport, uriInfo.getQueryParameters());

            return Response.ok(rawReport).build();

        } else {
            return Response.status(Response.Status.NOT_FOUND).build();
        }

    }

    private void passReportParams(RawXmlReport report, MultivaluedMap<String, String> uriParams) {

        ReportMeta meta = report.getMeta();

        meta.clearParamsValues();

        for (String key : uriParams.keySet()) {
            //setParam ignores value if param not found in meta.params map
            meta.setParam(key, uriParams.getFirst(key));
        }

    }

    @GET
    @Path("reports")
    @Produces(MediaType.APPLICATION_XML)
    public Map<String, RawXmlReport> getRawReportList() {
        return reportService.getReports();
    }

}
