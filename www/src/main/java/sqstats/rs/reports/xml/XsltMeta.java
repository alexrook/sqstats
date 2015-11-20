package sqstats.rs.reports.xml;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

/**
 * @author moroz
 */
@XmlRootElement(name = "meta")
public class XsltMeta {

    private String contentType = MediaType.APPLICATION_XML;

    private URI xsltUri;

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public URI getXsltUri() {
        return xsltUri;
    }

    public void setXsltUri(URI xsltUri) {
        this.xsltUri = xsltUri;
    }

    public Source getXsltSource() throws IOException {

        if (this.xsltUri != null) {

            if (this.xsltUri.getScheme() != null) {
                return new StreamSource(new BufferedInputStream(this.xsltUri.toURL().openStream()));
            } else {
                return new StreamSource(new BufferedInputStream(new FileInputStream(xsltUri.toString())));
            }

        } else {
            throw new IOException("xslt uri is not set");
        }

    }

}
