package sqstats.rs.reports.raw;

import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;
import sqstats.rs.AbstractRS;

/**
 * @author moroz
 */
@Path("/raw")
public class RawReportsRS extends AbstractRS {

    @EJB
    ReportService reportService;

    @GET
    @Path("{name:\\d+}")
    public Response testGet(@PathParam("name") int name, @Context HttpHeaders headers) {

        return Response.ok(headers.getRequestHeaders()).build();
    }

    @GET
    @Path("{name:\\w+}")
    public Response testGet(@PathParam("name") String name, @Context HttpHeaders headers) {

        RawXmlReport rawReport = reportService.getRawXmlReport(name);
        if (rawReport != null) {
            return Response.ok(rawReport).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).build();
        }

    }

    @GET
    public Response testGet1() {
        return Response.ok().build();
    }

}
