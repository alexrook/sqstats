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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.enterprise.concurrent.ManagedThreadFactory;
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
import sqstats.rs.reports.xml.ReportParam;

/**
 * @author moroz
 */
@XmlRootElement(name = "raw-xml-report")
@XmlAccessorType(XmlAccessType.FIELD)
public class RawXmlReport implements StreamingOutput, Serializable {

    public static interface IRawXmlReportEventListener {

        void onError(String name, Exception e);
    }

    public static final String XML_DECLARATION = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

    public static final String RAW_REPORT_TAG = "report";

    private String lineSeparator;
    private ReportMeta meta;

    @XmlTransient
    private DataSource dataSource;

    @XmlTransient
    private ManagedThreadFactory threadFactory;

    @XmlTransient
    private final List<IRawXmlReportEventListener> listeners = new ArrayList<>(1);

    @XmlTransient
    private boolean raw;

    public boolean isRaw() {
        return raw;
    }

    public void setRaw(boolean raw) {
        this.raw = raw;
    }

    public void addListener(IRawXmlReportEventListener listener) {
        listeners.add(listener);
    }

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

    public ManagedThreadFactory getThreadFactory() {
        return threadFactory;
    }

    public void setThreadFactory(ManagedThreadFactory threadFactory) {
        this.threadFactory = threadFactory;
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

            try (Connection conn = dataSource.getConnection()) {

                try (PreparedStatement statement = conn.prepareStatement(getMeta().getStatement(),
                        ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_READ_ONLY);) {

                    setStatementParams(statement);

                    try (ResultSet rs = statement.executeQuery();) {

                        try {

                            Writer w = new OutputStreamWriter(output);

                            writeHeader(w);
                            writeMeta(w);
                            writeResultSet(statement, rs, w);
                            writeFooter(w);

                            w.flush();

                        } catch (IOException | SQLException e) {
                            fireError(e);
                            throw new WebApplicationException(Response.serverError().entity(new ReportError(e,
                                    e.getMessage())).build());
                        }

                    } catch (SQLException e) {//ошибка выполнения sql - значит он неверен, внести в мета
                        ReportError re = new ReportError(e, e.getMessage());
                        this.meta.setError(re);
                        fireError(e);
                        throw new WebApplicationException(Response.serverError().entity(re).build());
                    }

                } catch (IllegalAccessException e) {//неверно указаны параметы отчета в http-запросе, информируем пользователя
                    fireError(e);
                    throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity(new ReportError(e,
                            e.getMessage())).build());

                } catch (SQLException e) {//ошибка выполнения sql - значит он неверен, внести в мета
                    ReportError re = new ReportError(e, e.getMessage());
                    this.meta.setError(re);
                    fireError(e);
                    throw new WebApplicationException(Response.serverError().entity(re).build());
                }

            } catch (SQLException e) {//ошибка соединения - информируем пользователя
                fireError(e);
                throw new WebApplicationException(Response.serverError().entity(new ReportError(e,
                        e.getMessage())).build());
            }

        } else {//report not valid
            throw new WebApplicationException(Response.serverError().entity(this.meta.getError()).build());
        }

    }

    private void setStatementParams(PreparedStatement statement) throws SQLException, IllegalAccessException {

        for (Integer paramIndex : meta.getParams().keySet()) {
            ReportParam param = meta.getParam(paramIndex);
            statement.setObject(paramIndex, param.tryValue(), param.getSqlTypeNum());
        }

    }

    private void writeResultSet(PreparedStatement statement,
            ResultSet rs, Writer w) throws IOException, SQLException {

        startTag(w, "resultset");
        int cc = statement.getMetaData().getColumnCount();
        for (int i = 1; i < cc + 1; i++) {
            int columntType = statement.getMetaData().getColumnType(i);
            if (columntType == Types.SQLXML) {
                writeXmlField(rs, w, statement.getMetaData().getColumnName(i));
            }
        }
        endTag(w, "resultset");

    }

    private void writeXmlField(ResultSet rs, Writer w,
            String columnName) throws IOException, SQLException {

        HashMap<String, String> columnAttrs = new HashMap();
        columnAttrs.put("name", columnName);

        startTag(w, "column", columnAttrs);

        if (rs.first()) {//true if the cursor is on a valid row; false if there are no rows in the result set
            do {

                w.append(getLineSeparator());

                Reader r = rs.getSQLXML(columnName).getCharacterStream();
                int c = r.read();
                while (c != - 1) {
                    w.append((char) c);
                    c = r.read();
                }

            } while (rs.next());
        }
        endTag(w, "column");

    }

    private void writeMeta(Writer w) throws IOException {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(ReportMeta.class);
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FRAGMENT, true);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            getMeta().setGenDate(new Date());

            marshaller.marshal(getMeta(), w);

        } catch (JAXBException ex) {
            throw new IOException(ex);
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

    private void fireError(Exception e) {
        for (IRawXmlReportEventListener listener : listeners) {
            listener.onError(this.meta.getName(), e);
        }
    }
}
