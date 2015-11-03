package sqstats.rs;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

/**
 * @author moroz
 */
public class Utils {

    public static final String APP_CFG_NAME = "sqstats.cfg";

    private static Utils instance;

    private Properties data = new Properties();

    private Utils() {
        InputStream is = this.getClass().getClassLoader().getResourceAsStream(APP_CFG_NAME);

        if (is != null) {
            try {
                data.load(is);
            } catch (IOException ex) {

            }
        } else {
            System.out
                    .println("app cfg not found");
        }

        try {
            data.load(new FileInputStream(APP_CFG_NAME));
        } catch (IOException ex) {

        }

    }

    public static Utils getInstance() {
        if (instance != null) {
            return instance;
        } else {
            instance = new Utils();
            return instance;
        }

    }

    public static String getProperty(String name) {
        return getInstance().data.getProperty(name);
    }

    public static boolean getBoolProperty(String name) {
        return getOtherBoolProperty(name, getInstance().data);
    }

    public static boolean getOtherBoolProperty(String name, Properties props) {
        String val = props.getProperty(name);
        boolean result = val != null ? val.matches("([Yy]es|[Tt]rue)") : false;
        return result;
    }

    public static String getOtherHierProperty(String name, Properties props) {
        String val = props.getProperty(name);
        if ((val == null) && (name.contains("."))) {
            if ((name.indexOf(".") + 1) < (name.length())) {
                return getHierProperty(name.substring(name.indexOf(".") + 1));
            }
        }
        return val;

    }

    public static Set<String> getOtherHierPropKeySet(String name, Properties props) {
        HashSet<String> result = new HashSet<>(12);
        for (Object key : props.keySet()) {
            if (((String) key).toLowerCase().startsWith(name+".")){
                result.add((String) key);
            }
        }
        return result;
    }

    public static String getHierProperty(String name) {
        return getOtherHierProperty(name, getInstance().data);
    }

    static {
        instance = new Utils();
    }

}
