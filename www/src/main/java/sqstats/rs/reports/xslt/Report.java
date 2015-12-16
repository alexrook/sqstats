package sqstats.rs.reports.xslt;

import sqstats.rs.reports.xml.XsltMeta;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.channels.Channels;
import java.nio.channels.Pipe;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamResult;
import org.xml.sax.InputSource;
import sqstats.rs.reports.raw.RawXmlReport;
import sqstats.rs.reports.xml.ReportError;

/**
 * @author moroz
 */
public class Report extends RawXmlReport {
    
    @XmlElement(name = "xslt-meta")
    private XsltMeta xsltMeta;
    
    public XsltMeta getXsltMeta() {
        return xsltMeta;
    }
    
    public void setXsltMeta(XsltMeta xsltMeta) {
        this.xsltMeta = xsltMeta;
    }
    
    private void superWrite(OutputStream output) throws IOException, WebApplicationException {
        super.write(output);
    }
    
    @Override
    public void write(OutputStream output) throws IOException, WebApplicationException {
        
        if (this.isRaw()) {
            superWrite(output);
        } else {
            final Pipe pipe = Pipe.open();
            final Report tt = this;
            
            getThreadFactory().newThread(new Runnable() {
                @Override
                public void run() {
                    try (OutputStream obuf = Channels.newOutputStream(pipe.sink())) {
                        tt.superWrite(obuf);
                        obuf.flush();
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }).start();
            
            SAXSource sas = new SAXSource(new InputSource(Channels.newInputStream(pipe.source())));
            
            SAXTransformerFactory stf = (SAXTransformerFactory) TransformerFactory.newInstance();
            try {
                
                Transformer transformer = stf.newTransformer(getXsltMeta().getXsltSource());
                StreamResult sr = new StreamResult(output);
                transformer.transform(sas, sr);
                output.flush();
                
            } catch (TransformerException ex) {
                throw new WebApplicationException(
                        Response.serverError()
                        .entity(
                                new ReportError(ex, ex.getMessage())
                        ).build());
            }
            
        }
    }
    
}
