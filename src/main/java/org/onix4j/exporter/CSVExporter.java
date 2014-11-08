package org.onix4j.exporter;

/**
 * User: Neta
 * Date: 5/21/14
 * Time: 4:34 PM
 */
public class CSVExporter extends Exporter<String> {

    public String export(ExportData exportData) {
        StringBuilder query = new StringBuilder();

        StringBuilder fieldsSB = new StringBuilder("");
        for (int i = 0; i < exportData.columnNames.size(); i++) {
            fieldsSB.append(exportData.columnNames.get(i)).append(",");
        }
        fieldsSB.replace(fieldsSB.length() - 1, fieldsSB.length(),"\n"); // end of row

        StringBuilder valuesSB = new StringBuilder("");
        for (ExportData.ExportedRow row : exportData.rows) {
            for (int i = 0; i < exportData.columnNames.size(); i++) {
                appendValue(valuesSB, row.columns.get(i)).append(",");
            }
            valuesSB.replace(valuesSB.length() - 1, valuesSB.length(), "\n"); // end of row
        }

        //query./*append(fieldsSB).*/append(valuesSB);
        query.append(fieldsSB).append(valuesSB);
        valuesSB.replace(valuesSB.length() - 1, valuesSB.length(), "\n");
        return query.toString();
    }

    private static StringBuilder appendValue(StringBuilder valuesSB, Object value) {
        if (value == null) {
            valuesSB.append("");
        } else {
            valuesSB.append("\"");
            valuesSB.append(value.toString().replaceAll("\"", "'").replaceAll("\n", "\t"));
            valuesSB.append("\"");
        }
        return valuesSB;
    }
}
