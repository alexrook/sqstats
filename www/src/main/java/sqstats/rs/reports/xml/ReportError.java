package sqstats.rs.reports.xml;

import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import java.sql.SQLException;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "error")
public class ReportError implements Serializable {

    private String msg;

    private String stackTrace;

    private String sqlState;

    public ReportError() {

    }

    public ReportError(Exception e, String msg) {

        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        this.stackTrace = sw.toString();
        this.msg = msg;

        if (e instanceof SQLException) {
            //a "SQLstate" string, which follows either the XOPEN SQLstate conventions
            //or the SQL:2003 conventions. The values of the SQLState string 
            //are described in the appropriate spec
            this.sqlState = ((SQLException) e).getSQLState();
        }

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

    public String getSqlState() {
        return sqlState;
    }

    public void setSqlState(String sqlState) {
        this.sqlState = sqlState;
    }

}
