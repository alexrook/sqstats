package sqstats.rs.reports.xml;

import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "error")
public class ReportError implements Serializable {

    private String msg;

    private String stackTrace;

    public ReportError() {

    }

    public ReportError(Exception e, String msg) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        this.stackTrace = sw.toString();
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getStackTrace() {
        return stackTrace;
    }

    public void setStackTrace(String stackTrace) {
        this.stackTrace = stackTrace;
    }

    
}
