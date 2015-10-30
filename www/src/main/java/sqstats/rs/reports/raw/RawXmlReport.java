package sqstats.rs.reports.raw;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.PreparedStatement;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.StreamingOutput;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
public class RawXmlReport implements StreamingOutput {

    public static final String RAW_REPORT_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + System.lineSeparator()
            + "<report>";

    public static final String RAW_REPORT_FOOTER = "</report>";

    private PreparedStatement statement;

    private ReportMeta meta;

    public ReportMeta getMeta() {
        return meta;
    }

    public void setMeta(ReportMeta meta) {
        this.meta = meta;
    }

    public PreparedStatement getStatement() {
        return statement;
    }

    public void setStatement(PreparedStatement statement) {
        this.statement = statement;
    }

    @Override
    public void write(OutputStream output) throws IOException, WebApplicationException {
        try {

            Writer w = new OutputStreamWriter(output);
            //statement.executeQuery();

            writeHeader(w);
            writeMeta(w);
            writeFooter(w);
            w.flush();

        } catch (Exception ex) {
            throw new WebApplicationException(ex);
        }
    }

    private void writeMeta(Writer w) throws WebApplicationException {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(ReportMeta.class);
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FRAGMENT, true);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            jaxbContext.createMarshaller().marshal(getMeta(), w);
        } catch (JAXBException ex) {
            throw new WebApplicationException(ex);
        }

    }

    private void writeHeader(Writer w) throws IOException {
        w.append(RAW_REPORT_HEADER);
    }

    private void writeFooter(Writer w) throws IOException {
        w.append(RAW_REPORT_FOOTER);
    }

}
