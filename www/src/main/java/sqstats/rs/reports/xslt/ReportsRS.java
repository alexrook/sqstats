package sqstats.rs.reports.xslt;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.channels.Channels;
import java.nio.channels.Pipe;
import java.util.Date;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
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
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.util.JAXBResult;
import javax.xml.bind.util.JAXBSource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import sqstats.rs.AbstractRS;
import sqstats.rs.reports.ReportService;
import sqstats.rs.reports.raw.RawXmlReport;
import sqstats.rs.reports.xml.ReportMeta;

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
    @Produces(MediaType.TEXT_HTML)
    public Response getReportList() throws JAXBException,
            TransformerConfigurationException,
            TransformerException,
            IOException {
        
        JAXBContext jaxbContext = JAXBContext.newInstance(Map.class);
        Marshaller marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FRAGMENT, true);
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        
        final JAXBSource source = new JAXBSource(marshaller, reportService.getReports());
        // set up XSLT transformation
        TransformerFactory tf = TransformerFactory.newInstance();
        final Transformer t = tf.newTransformer(new StreamSource("test.xsl"));//todo
        
        final Pipe pipe = Pipe.open();
        
        reportService.getThreadFactory().newThread(
                new Runnable() {
            @Override
            public void run() {
                try (OutputStream obuf = Channels.newOutputStream(pipe.sink())) {
                    //run transformation
                    t.transform(source, new StreamResult(System.out));
                    obuf.flush();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }).start();
        
        return Response.ok().entity(Channels.newInputStream(pipe.source())).build();
    }
    
}
