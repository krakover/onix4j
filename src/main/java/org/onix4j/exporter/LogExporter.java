package org.onix4j.exporter;

import org.onix4j.model.OnixLog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * User: Neta
 * Date: 6/2/14
 * Time: 11:35 AM
 */
public class LogExporter extends Exporter<OnixLog> {
    Map<String,List<Object>> activeOnixNameToUniqueProductIds = new HashMap<String, List<Object>>();

    public OnixLog export(ExportData exportData) {
        ExportData uniqueExportData = exportData.filterUniqueByColumnIndex(1);  // TODO comparator

        for (ExportData.ExportedRow row : uniqueExportData.rows) {
            if (!activeOnixNameToUniqueProductIds.containsKey(row.metadata.fileName)) {
                activeOnixNameToUniqueProductIds.put(row.metadata.fileName, new ArrayList<Object>(row.columns.size()));
            }

            Object productUniqueId = row.columns.get(0); // TODO
            activeOnixNameToUniqueProductIds.get(row.metadata.fileName).add(productUniqueId);
        }

        return new OnixLog(activeOnixNameToUniqueProductIds);
    }

    public OnixLog export(OnixLog onixLog, ExportData exportData) {
        ExportData uniqueExportData = exportData.filterUniqueByColumnIndex(1);  // TODO comparator

        for (ExportData.ExportedRow row : uniqueExportData.rows) {
            if (!activeOnixNameToUniqueProductIds.containsKey(row.metadata.fileName)) {
                activeOnixNameToUniqueProductIds.put(row.metadata.fileName, new ArrayList<Object>(row.columns.size()));
            }

            Object productUniqueId = row.columns.get(0); // TODO
            activeOnixNameToUniqueProductIds.get(row.metadata.fileName).add(productUniqueId);
        }

        onixLog.addToLog(activeOnixNameToUniqueProductIds);
        return onixLog;
    }

    // TODO appending
}
