package sqstats.rs.reports.xml;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "error")
public class ReportError implements Serializable {

    private Exception cause;

    private String msg;

    public ReportError() {

    }

    public ReportError(Exception e, String msg) {
        this.cause = e;
        this.msg = msg;
    }

    public Exception getCause() {
        return cause;
    }

    public void setCause(Exception cause) {
        this.cause = cause;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

}
