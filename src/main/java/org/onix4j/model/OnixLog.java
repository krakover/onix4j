package org.onix4j.model;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.log4j.Logger;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * User: Neta
 * Date: 6/5/14
 * Time: 11:03 AM
 */
public class OnixLog {
    PropertiesConfiguration config = new PropertiesConfiguration();
    private static Logger logger = Logger.getLogger(OnixLog.class);

    public OnixLog(Map<String, List<Object>> activeOnixNameToUniqueProductIds) {
        this.addToLog(activeOnixNameToUniqueProductIds);
    }

    public OnixLog addToLog(Map<String, List<Object>> activeOnixNameToUniqueProductIds) {
        for (Map.Entry<String, List<Object>> entry : activeOnixNameToUniqueProductIds.entrySet()) {
            config.setProperty(entry.getKey().replaceAll("\\\\", "~"), entry.getValue());
        }
        return this;
    }

    public OnixLog(String logFile) {
        try {
            config.load(new FileInputStream(logFile));

        } catch (IOException e) {
            e.printStackTrace();  // TODO
        } catch (ConfigurationException e) {
            e.printStackTrace();  // TODO
        }
    }

    public List<String> getOnixFileNames() {
        List<String> fileNames = new ArrayList<String>();
        Iterator keyIterator = config.getKeys();
        while (keyIterator.hasNext()) {
            fileNames.add(((String)keyIterator.next()).replaceAll("~", "\\\\"));
        }

        return fileNames;
    }

    public String toString() {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            config.save(os);
        } catch (ConfigurationException e) {
            logger.error("Failed to save", e);
        }
        return os.toString();
    }

    public List<Object> getUniqueIdentifiersForFile(String fileName) {
        return (List<Object>)config.getList(fileName.replaceAll("\\\\", "~"));
    }
}
