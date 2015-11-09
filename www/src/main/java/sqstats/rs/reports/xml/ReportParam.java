package sqstats.rs.reports.xml;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "param")
public class ReportParam implements Serializable {

    private String name;
    private int posInStmt = 1, sqlTypeNum;

    private Object value;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPosInStmt() {
        return posInStmt;
    }

    public void setPosInStmt(int posInStmt) {
        this.posInStmt = posInStmt;
    }

    public int getSqlTypeNum() {
        return sqlTypeNum;
    }

    public void setSqlTypeNum(int sqlTypeNum) {
        this.sqlTypeNum = sqlTypeNum;
    }

    public Object getValue() {
        return value;
    }

    public Object tryValue() throws IllegalAccessException {
        if (value != null) {
            return value;
        } else {
            throw new IllegalAccessException("param " + name + " not initialized");
        }
    }

    public void setValue(Object value) {
        this.value = value;
    }

}
