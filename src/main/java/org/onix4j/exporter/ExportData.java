package org.onix4j.exporter;

import org.onix4j.model.OnixMetadata;

import java.util.*;

/**
 * User: Neta
 * Date: 5/20/14
 * Time: 9:22 PM
 */
public class ExportData {

    public String tableName;
    public String schemeName;
    public List<String> columnNames = new ArrayList<String>();
    public List<ExportedRow> rows = new ArrayList<ExportedRow>();

    public ExportData() {
    }

    public ExportData(ExportData exportData) {
        setExportData(exportData);
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public void setSchemeName(String schemeName) {
        this.schemeName = schemeName;
    }

    public void setExportData(ExportData exportData) {
        this.schemeName = exportData.schemeName;
        this.tableName = exportData.tableName;
        this.columnNames = exportData.columnNames;
        this.rows = exportData.rows;
    }

    public ExportData filterUniqueByColumnName(String columnName) {
        return filterUniqueByColumnName(columnName, null);
    }

    public ExportData filterUniqueByColumnName(String columnName, Comparator<ExportedRow> comparator) {
        int index = columnNames.indexOf(columnName);
        if (index > 1) {
            return filterUniqueByColumnIndex(index, comparator);
        }
        throw new IllegalArgumentException("No such column name in export data");
    }

    public ExportData filterUniqueByColumnIndex(int columnIndex) {
        return filterUniqueByColumnIndex(columnIndex, null);
    }

    public ExportData filterUniqueByColumnIndex(int columnIndex, Comparator<ExportedRow> comparator) {
        Map<Object, ExportedRow> map = new HashMap<Object, ExportedRow>(rows.size());

        for (ExportedRow row : rows) {
            if (map.containsKey(row.columns.get(columnIndex))) {
                if (comparator != null) {
                    if(comparator.compare(map.get(row.columns.get(columnIndex)), row) < 0) {
                        // Replace the row only if the existing is smaller than the new
                        map.put(row.columns.get(columnIndex), row);
                    }
                } else {
                    // Prefer latter row
                    map.put(row.columns.get(columnIndex), row);
                }
            } else {
                 map.put(row.columns.get(columnIndex), row);
            }
        }

        ExportData data = new ExportData(this);
        data.rows = new ArrayList<ExportedRow>(map.values());

        return data;
    }
    public static class ExportedRow {
        public OnixMetadata metadata;
        List<Object> columns;

        public ExportedRow(OnixMetadata metadata, List<Object> values) {
            this.columns = values;
            this.metadata = metadata;
        }
    }
}
