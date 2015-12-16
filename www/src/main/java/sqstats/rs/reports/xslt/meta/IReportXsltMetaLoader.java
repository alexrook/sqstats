package sqstats.rs.reports.xslt.meta;

import sqstats.rs.reports.xml.XsltMeta;
import java.util.Map;
import sqstats.rs.reports.raw.meta.IReportMetaLoader;

/**
 * @author moroz
 */
public interface IReportXsltMetaLoader extends IReportMetaLoader {

    Map<String, XsltMeta> getXsltMetas();
    
    XsltMeta getXsltMeta(String reportName);

}
