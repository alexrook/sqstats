package sqstats.rs.reports.xml;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "meta")
public class ReportMeta implements Serializable {

    private String statement, name, description;
    private Date genDate;

    private ReportError error = null;

    private Map<Integer, ReportParam> params = new HashMap<>(3);

    public Date getGenDate() {
        return genDate;
    }

    public void setGenDate(Date genDate) {
        this.genDate = genDate;
    }

    public ReportError getError() {
        return error;
    }

    public void setError(ReportError error) {
        this.error = error;
    }

    public String getStatement() {
        return statement;
    }

    public void setStatement(String statement) {
        this.statement = statement;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Map<Integer, ReportParam> getParams() {
        return params;
    }

    public void clearParamsValues() {
       for (ReportParam param: params.values()) {
           param.setValue(null);
       }
    }

    public void setParams(Map<Integer, ReportParam> params) {
        this.params = params;
    }

    public void addParam(ReportParam param) {
        params.put(param.getPosInStmt(), param);
    }

    public ReportParam getParam(Integer posInStmt) {
        return params.get(posInStmt);
    }

    public ReportParam getParam(String name) {

        ReportParam result = null;

        for (int i : params.keySet()) {
            if (params.get(i).getName().equalsIgnoreCase(name)) {
                result = params.get(i);
            }

        }
        return result;
    }

    public void setParam(String name, Object value) {
        ReportParam param = getParam(name);
        if (param != null) {
            param.setValue(value);
        }
    }

}
