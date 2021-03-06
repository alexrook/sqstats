package sqstats.rs;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import javax.ws.rs.core.MultivaluedMap;
import sqstats.rs.reports.raw.RawXmlReport;
import sqstats.rs.reports.xml.ReportMeta;

/**
 *
 * @author moroz
 */
public class AbstractRS {

    public static final int DEF_RESULTS_COUNT = 15;
    public static final int[] DEF_RESULTS_RANGE = {0, DEF_RESULTS_COUNT};

    public int[] getRangeFromHeader(String header) {
        if (header == null) {
            return Arrays.copyOf(DEF_RESULTS_RANGE, DEF_RESULTS_RANGE.length);
        }
        String[] strs = header.split("-");
        int[] result = new int[2];
        try {
            result[0] = Integer.parseInt(strs[0]);
            result[1] = Integer.parseInt(strs[1]);
            if (checkRange(result)) {
                return result;
            } else {
                return Arrays.copyOf(DEF_RESULTS_RANGE, DEF_RESULTS_RANGE.length);
            }
        } catch (NumberFormatException e) {
            return Arrays.copyOf(DEF_RESULTS_RANGE, DEF_RESULTS_RANGE.length);
        }

    }

    private boolean checkRange(int[] range) {
        return !((range.length != 2) || (range[0] < 0) || (range[0] >= range[1]));
    }

    public String buildContentRangeHeaderValue(int[] range) {
        return range[0] + "-" + range[1];
    }

    protected void passReportParams(RawXmlReport report, MultivaluedMap<String, String> uriParams) {

        ReportMeta meta = report.getMeta();

        meta.clearParamsValues();

        for (String key : uriParams.keySet()) {
            //setParam ignores value if param not found in meta.params map
            meta.setParam(key, uriParams.getFirst(key));
        }

    }

    protected InputStream getFileInputStream(String name) throws IOException {
        
        File file =new File(name);
        
        if (!file.isAbsolute()) {
            file=new File(Utils.getProperty("reports.dir")+"/"+file.getPath());
        }
        
        return new BufferedInputStream(new FileInputStream(file));
    }

}
