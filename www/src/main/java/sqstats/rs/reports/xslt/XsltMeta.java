package sqstats.rs.reports.xslt;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
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

    private String xsltUri;

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getXsltUri() {
        return xsltUri;
    }

    public void setXsltUri(String xsltUri) {
        this.xsltUri = xsltUri;
    }

    public Source getXsltSource() throws IOException {
        //todo: загрузка в зависимости от схемы uri
        return new StreamSource(new BufferedInputStream(new FileInputStream(xsltUri)));
    }

}
