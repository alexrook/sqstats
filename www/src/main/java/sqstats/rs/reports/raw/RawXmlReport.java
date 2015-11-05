package sqstats.rs.reports.raw;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.sql.DataSource;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.StreamingOutput;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import sqstats.rs.reports.xml.ReportError;
import sqstats.rs.reports.xml.ReportMeta;

/**
 * @author moroz
 */
@XmlRootElement(name = "raw-xml-report")
@XmlAccessorType(XmlAccessType.FIELD)
public class RawXmlReport implements StreamingOutput, Serializable {

    public static final String XML_DECLARATION = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

    public static final String RAW_REPORT_TAG = "report";

    private String lineSeparator;
    private ReportMeta meta;

    @XmlTransient
    private DataSource dataSource;

    public boolean isValid() {
        return (meta != null) && (meta.getError() == null);
    }

    public String getLineSeparator() {
        return lineSeparator;
    }

    public void setLineSeparator(String lineSeparator) {
        this.lineSeparator = lineSeparator;
    }

    public DataSource getDataSource() {
        return dataSource;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public ReportMeta getMeta() {
        return meta;
    }

    public void setMeta(ReportMeta meta) {
        this.meta = meta;
    }

    @Override
    public void write(OutputStream output) throws IOException, WebApplicationException {

        if (this.isValid()) {
            try (Connection conn = dataSource.getConnection();
                    PreparedStatement statement = conn.prepareStatement(getMeta().getStatement(),
                            ResultSet.TYPE_SCROLL_INSENSITIVE,
                            ResultSet.CONCUR_READ_ONLY);) {

                ResultSet rs;
                try {
                    rs = statement.executeQuery();

                    try (Writer w = new OutputStreamWriter(output)) {
                        writeHeader(w);
                        writeMeta(w);
                        startTag(w, "resultset");
                        int cc = statement.getMetaData().getColumnCount();
                        for (int i = 1; i < cc + 1; i++) {
                            int columntType = statement.getMetaData().getColumnType(i);
                            if (columntType == Types.SQLXML) {
                                writeXmlField(rs, w, statement.getMetaData().getColumnName(i));
                            }
                        }
                        endTag(w, "resultset");
                        writeFooter(w);
                    }

                } catch (SQLException e) {
                    this.meta.setError(new ReportError(e, e.getMessage()));
                    throw new WebApplicationException(Response.serverError().entity(this).build());
                }
            } catch (SQLException ex) {
                throw new WebApplicationException(ex);
            }
        } else {
            try (Writer w = new OutputStreamWriter(output)) {
                writeHeader(w);
                writeMeta(w);
                writeFooter(w);
            }
            throw new IOException(meta.getError().getCause());

        }

    }

    private void writeXmlField(ResultSet rs, Writer w,
            String columnName) throws SQLException {
        try {
            HashMap<String, String> columnAttrs = new HashMap();
            columnAttrs.put("name", columnName);
            startTag(w, "column", columnAttrs);

            rs.first();
            do {

                w.append(getLineSeparator());

                Reader r = rs.getSQLXML(columnName).getCharacterStream();
                int c = r.read();
                while (c != - 1) {
                    w.append((char) c);
                    c = r.read();
                }

            } while (rs.next());

            endTag(w, "column");
        } catch (IOException ex) {
            throw new SQLException(ex);
        }
    }

    private void writeMeta(Writer w) throws WebApplicationException {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(ReportMeta.class);
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FRAGMENT, true);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            getMeta().setGenDate(new Date());

            marshaller.marshal(getMeta(), w);

        } catch (JAXBException ex) {
            throw new WebApplicationException(ex);
        }

    }

    private void writeHeader(Writer w) throws IOException {
        w.append(XML_DECLARATION);
        startTag(w, RAW_REPORT_TAG);

    }

    private void writeFooter(Writer w) throws IOException {
        endTag(w, RAW_REPORT_TAG);
    }

    private Writer startTag(Writer w, String tagName, Map<String, String> attrs) throws IOException {
        w.append(getLineSeparator())
                .append("<")
                .append(tagName);
        if ((attrs != null) && (!attrs.isEmpty())) {

            for (String name : attrs.keySet()) {
                if (name != null) {
                    w.append(" ");
                    w.append(name).append("=")
                            .append("\"")
                            .append(attrs.get(name))
                            .append("\"");
                }
            }

        }
        w.append(">");

        return w;

    }

    private Writer startTag(Writer w, String tagName) throws IOException {
        return startTag(w, tagName, null);
    }

    private Writer endTag(Writer w, String tagName) throws IOException {
        w.append(getLineSeparator())
                .append("</")
                .append(tagName).append(">");
        return w;
    }

}
