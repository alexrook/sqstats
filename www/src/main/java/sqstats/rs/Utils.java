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

    public static String tryProperty(String name, Properties props) throws IOException{
        
        String result = props.getProperty(name);
        
        if (result != null) {
            return result;
        }

        throw new IOException("property " + name + " not found");
    }

    public static boolean getOtherBoolProperty(String name, Properties props) {
        String val = props.getProperty(name);
        boolean result = val != null ? val.matches("([Yy]es|[Tt]rue)") : false;
        return result;
    }

    public static String createKey(String prefix, String name, String suffix) {
        String result = (prefix != null) ? prefix + "." + name : name;
        result = (suffix != null) ? result + "." + suffix : result;
        return result;
    }

    /**
     * For the initial key name 'foo.bar.one' try to return the value of
     * 'foo.bar.one' if the value is not found, try "foo.bar" if not found, try
     * 'foo'
     *
     * @param name - key name
     * @param props - props to find
     * @return
     */
    public static String getOtherHierProperty(String name, Properties props) {
        String val = props.getProperty(name);
        if ((val == null) && (name.contains("."))) {
            if ((name.indexOf(".") + 1) < (name.length())) {
                return getHierProperty(name.substring(name.indexOf(".") + 1));
            }
        }
        return val;

    }

    /**
     * For the initial key name 'foo.bar' return all keys 'foo.bar.one',
     * 'foo.bar.other' and so on.
     *
     * @param name
     * @param props
     * @return
     */
    public static Set<String> getOtherHierPropKeySet(String name, Properties props) {
        HashSet<String> result = new HashSet<>(12);
        for (Object key : props.keySet()) {
            if (((String) key).toLowerCase().startsWith(name + ".")) {
                result.add((String) key);
            }
        }
        return result;
    }

    /**
     * For keys name 'foo.bar.one', 'foo.bar.two' and param name=foo.bar returns
     * set {one,two}
     *
     * @param name start name
     * @param props
     * @return
     */
    public static Set<String> getOtherNextPropKeyFragment(String name, Properties props) {
        HashSet<String> result = new HashSet<>(12);
        for (Object key : props.keySet()) {
            String skey = (String) key;
            if ((skey).toLowerCase().startsWith(name + ".")) {
                String rname = skey.substring(name.length() + 1,
                        skey.indexOf(".", name.length() + 1));
                result.add(rname);
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
