package org.onix4j.exporter;

import java.util.Collections;
import java.util.Comparator;

/**
 * User: Neta Krakover
 * Date: 5/20/14
 */
public class SQLExporter extends Exporter<String> {

    public String export(ExportData exportData) {
        StringBuilder query = new StringBuilder("insert into " + exportData.tableName + " ");

        StringBuilder fieldsSB = new StringBuilder(" (");
        for (int i = 0; i < exportData.columnNames.size(); i++) {
            fieldsSB.append(exportData.columnNames.get(i)).append(",");
        }
        fieldsSB.replace(fieldsSB.length() - 1, fieldsSB.length(), ")");

        StringBuilder valuesSB = new StringBuilder(" values ");
        Collections.sort(exportData.rows, new Comparator<ExportData.ExportedRow>() {
            public int compare(ExportData.ExportedRow o1, ExportData.ExportedRow o2) {
                return o1.columns.get(0).toString().compareTo(o2.columns.get(0).toString());
            }
        });
        for (ExportData.ExportedRow row : exportData.rows) {
            valuesSB.append("(");
            for (int i = 0; i < exportData.columnNames.size(); i++) {
                appendValue(valuesSB, row.columns.get(i));
                valuesSB.append(",");
            }
            valuesSB.replace(valuesSB.length() - 1, valuesSB.length(), ")");
            valuesSB.append(",\r\n");
        }

        //query./*append(fieldsSB).*/append(valuesSB);
        query.append(fieldsSB).append(valuesSB);
        valuesSB.replace(valuesSB.length() - 1, valuesSB.length(),";\r\n");
        return query.toString();
    }

    private static void appendValue(StringBuilder valuesSB, Object value) {
        if (value == null) {
            valuesSB.append("''");
        } else {
            valuesSB.append("'");
            valuesSB.append(value.toString().replaceAll("'", "''"));
            valuesSB.append("'");
        }
    }
}