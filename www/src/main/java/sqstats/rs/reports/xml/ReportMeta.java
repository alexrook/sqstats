package sqstats.rs.reports.xml;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "meta")
public class ReportMeta {

    private String statement, name;

    private Map<Integer, ReportParam> params = new HashMap<>(3);

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

    public Map<Integer, ReportParam> getParams() {
        return params;
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
}
