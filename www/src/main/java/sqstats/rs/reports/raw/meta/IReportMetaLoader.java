package sqstats.rs.reports.raw.meta;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
public interface IReportMetaLoader {

    interface IReportErrorStorage {

        void addError(String name, ReportError error);

        ReportError getError(String name);
        
        Map<String,ReportError> getErrorsMap();
        
        void clear();
    }

    void init(IReportErrorStorage errorsStorage) throws IOException;

    List<ReportMeta> getReportMetas() throws IOException;

    IReportErrorStorage getReportErrors();

    boolean hasChanges();

}
