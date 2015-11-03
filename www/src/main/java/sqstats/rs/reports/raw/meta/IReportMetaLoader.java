package sqstats.rs.reports.raw.meta;

import java.io.IOException;
import java.util.List;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
public interface IReportMetaLoader {
  
        void init() throws IOException;

        List<ReportMeta> getReportMetas() throws IOException;
        
        boolean hasChanges();
  
    
}
