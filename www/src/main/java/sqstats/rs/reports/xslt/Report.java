package sqstats.rs.reports.xslt;

import sqstats.rs.reports.xml.XsltMeta;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Pipe;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import org.xml.sax.InputSource;
import sqstats.rs.reports.raw.RawXmlReport;
import sqstats.rs.reports.xml.ReportError;

/**
 * @author moroz
 */
public class Report extends RawXmlReport {

    private static class CustomPipe {

        private class CustomOutputStream extends OutputStream {

            private final ByteBuffer obuf;

            CustomOutputStream() {
                obuf = ByteBuffer.allocate(512);
                obuf.clear();
            }

            @Override
            public void write(int b) throws IOException {
                obuf.putInt(b);
                obuf.flip();
                while (obuf.hasRemaining()) {
                    pipe.sink().write(obuf);
                }

            }
        }

        private class CustomInputStream extends InputStream {

            private final ByteBuffer ibuf;

            CustomInputStream() {
                ibuf = ByteBuffer.allocate(512);
                ibuf.clear();
            }

            @Override
            public int read() throws IOException {

                //limit is set to current position and position is set to zero
                ibuf.flip();

                if (ibuf.hasRemaining()) {
                    return ibuf.getInt();
                } else {
                    //position is set to zero and limit is set to capacity to clear the buffer.
                    ibuf.clear();
                    if (pipe.source().read(ibuf) > 0) {
                        return read();
                    } else {
                        return -1;
                    }
                }

            }
        }
        private final Pipe pipe;

        private final CustomOutputStream cos;
        private final CustomInputStream cis;

        public CustomPipe() throws IOException {
            cos = new CustomOutputStream();
            cis = new CustomInputStream();
            pipe = Pipe.open();
        }

        public OutputStream getOutputStream() {
            return cos;
        }

        public InputStream getInputStream() {
            return cis;
        }
    }

    @XmlElement(name = "xslt-meta")
    private XsltMeta xsltMeta;

   

    public XsltMeta getXsltMeta() {
        return xsltMeta;
    }

    public void setXsltMeta(XsltMeta xsltMeta) {
        this.xsltMeta = xsltMeta;
    }

    @Override
    public void write(OutputStream output) throws IOException, WebApplicationException {
       
        if (this.isRaw()) {
            super.write(output);
        } else {
            CustomPipe cp = new CustomPipe();

            super.write(cp.getOutputStream());

            SAXSource sas = new SAXSource(new InputSource(cp.getInputStream()));

            TransformerFactory tf = TransformerFactory.newInstance();

            try {

                Transformer tarnsformer = tf.newTransformer();
                StreamResult sr = new StreamResult(output);
                tarnsformer.transform(sas, sr);

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
