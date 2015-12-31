package sqstats.xml.tools;

import java.util.Map;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author moroz
 */
@XmlRootElement(name = "map-wrapper")
public class MapWrapper {

    private Map map;

    public MapWrapper() {
    }

    public MapWrapper(Map map) {
        this.map = map;
    }

    public Map getMap() {
        return map;
    }

    public void setMap(Map map) {
        this.map = map;
    }

}
