package sqstats.rs.reports.raw;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import sqstats.rs.AbstractRS;


/**
 * @author moroz
 */
@Path("/raw")
public class RawReportsRS extends AbstractRS {

    
    @GET
    public Response testGet(){
        return Response.ok().build();
    }
    
}
