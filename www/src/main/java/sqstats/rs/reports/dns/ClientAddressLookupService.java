package sqstats.rs.reports.dns;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.ejb.Schedule;
import javax.ejb.Stateless;
import javax.inject.Inject;
import sqstats.rs.reports.ReportService;
import sqstats.rs.reports.xml.ReportError;

/**
 * @author moroz
 */
@Stateless
public class ClientAddressLookupService {

    @Inject
    IClientAddressStorage clientAddressStorage;

    @EJB
    ReportService reportService;

    @Schedule(dayOfWeek = "*",
            month = "*",
            hour = "9-17",
            dayOfMonth = "*",
            year = "*",
            minute = "*",
            second = "0",
            persistent = false)
    public void lookupAddress() {

        try {
            List<String> clientAddresses = clientAddressStorage.getClientsAddresses();
            Map<String, String> updatetCliAddrs = new HashMap<>();
            for (String address : clientAddresses) {
                try {

                    InetAddress ia = InetAddress.getByName(address);

                    if (!address.equalsIgnoreCase(ia.getCanonicalHostName())) {
                        updatetCliAddrs.put(address, ia.getCanonicalHostName());
                    }

                } catch (UnknownHostException ex) {
                    String msg = "unknown host exception for address:" + address;
                    reportService.addError(address,
                            new ReportError(ex, msg));
                    Logger.getLogger(ClientAddressLookupService.class.getName()).log(Level.SEVERE, msg);
                }

            }

            clientAddressStorage.updateClientAddreses(updatetCliAddrs);

        } catch (IClientAddressStorage.ClientAddressStorageException ex) {
            String msg = "ClientAddressStorageException, check app configuration";
            reportService.addError("ClientAddressStorageException",
                    new ReportError(ex, msg));
            Logger.getLogger(ClientAddressLookupService.class.getName()).log(Level.SEVERE, msg);
        }

    }

}
