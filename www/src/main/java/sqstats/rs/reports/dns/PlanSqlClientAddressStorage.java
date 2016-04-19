package sqstats.rs.reports.dns;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.sql.DataSource;
import sqstats.rs.Utils;

/**
 * @author moroz
 */
@Singleton
public class PlanSqlClientAddressStorage implements IClientAddressStorage {

    public static final String DNS_KEY_SELECT_SQL = "dns.sql.stmt.select",
            DNS_KEY_UPDATE_SQL = "dns.sql.stmt.update";

    private String selectSQL, updateSQL;

    @Resource(lookup = "java:jboss/datasources/sqstatsDS")
    DataSource dataSource;

    Exception initEx = null;

    @Override
    public List<String> getClientsAddresses() throws ClientAddressStorageException {

        if (initEx != null) {
            throw new ClientAddressStorageException(initEx.getMessage(), initEx);
        }

        List<String> ret = new ArrayList(150);
        try (Connection conn = dataSource.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(selectSQL);) {

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    ret.add(rs.getString(1));
                }
                
            } catch (SQLException ex) {
                throw new ClientAddressStorageException("ClientAddressStorageException while executing "
                        + DNS_KEY_SELECT_SQL, ex);
            }
        } catch (SQLException connEx) {
            throw new ClientAddressStorageException("ClientAddressStorageException unnable open jdbc connection "
                    + DNS_KEY_SELECT_SQL, connEx);
        }

        return ret;
    }

    @Override
    public void updateClientAddreses(Map<String, String> clientAddressToNameMap) throws ClientAddressStorageException {
        if (initEx != null) {
            throw new ClientAddressStorageException(initEx.getMessage(), initEx);
        }
        for (String address : clientAddressToNameMap.keySet()) {
            System.out.println(address + ":" + clientAddressToNameMap.get(address));
        }
    }

    public PlanSqlClientAddressStorage() {
    }

    @PostConstruct
    public void init() {
        try {
            selectSQL = Utils.tryPropertyNotEmpty(DNS_KEY_SELECT_SQL);
            // updateSQL = Utils.tryPropertyNotEmpty(DNS_KEY_SELECT_SQL);
        } catch (IOException ex) {
            initEx = ex;
            Logger.getLogger(PlanSqlClientAddressStorage.class
                    .getName()).log(Level.SEVERE, "could not get PlanSqlClientAddressStorage property from cfg file");
        }
    }

}
