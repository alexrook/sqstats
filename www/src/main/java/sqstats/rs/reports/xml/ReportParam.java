package sqstats.rs.reports.xml;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "param")
public class ReportParam implements Serializable{
    
    private String name;
    private int posInStmt=1,sqlTypeNum;

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
    
    
    
}
