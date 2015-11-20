package sqstats.rs.reports.xslt.meta;

import sqstats.rs.reports.xml.XsltMeta;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import sqstats.rs.Utils;
import sqstats.rs.reports.raw.meta.PlanReportMetaLoader;

/**
 * @author moroz
 */
public class PlanReportXsltMetaLoader extends PlanReportMetaLoader implements IReportXsltMetaLoader {

    public static final String REPORT_XSLT_CONTENTTYPE = "report.xlst.contentType",
            REPORT_XSLT_URI = "report.xlst.uri";

    private final Map<String, XsltMeta> xsltMetas = new HashMap<>(12);

    @Override
    protected void parsedFile(File file, Properties props, String reportName) throws IOException {
        XsltMeta xsltMeta = new XsltMeta();
        xsltMeta.setContentType(props.getProperty(REPORT_XSLT_CONTENTTYPE));

        try {
            URI u = new URI(Utils.tryPropertyNotEmpty(REPORT_XSLT_URI, props));
            if (!u.isAbsolute()) {
                u = u.resolve(file.getCanonicalPath());
            }
            xsltMeta.setXsltUri(u);
        } catch (URISyntaxException ex) {
            throw new IOException(ex);
        }

        xsltMetas.put(reportName, xsltMeta);
    }

    @Override
    public Map<String, XsltMeta> getXsltMetas() {
        return xsltMetas;
    }

    @Override
    public XsltMeta getXsltMeta(String reportName) {
        return xsltMetas.get(reportName);
    }

}
