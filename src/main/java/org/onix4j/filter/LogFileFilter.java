package org.onix4j.filter;

import org.onix4j.model.Onix;
import org.onix4j.model.OnixLog;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 12:02 PM
 */
public class LogFileFilter implements Filter {
    private OnixLog log;

    public LogFileFilter(OnixLog log) {
        this.log = log;
    }

     public LogFileFilter(String logFileName) {
        this.log = new OnixLog(logFileName);
    }

    public boolean useFile(String fileName) {
        return log.getOnixFileNames().contains(fileName);
    }

    public boolean useOnix(Onix onix) {
        return true;
    }

    public boolean useProduct(String fileName, String uniqueIdentifier) {
        return log.getUniqueIdentifiersForFile(fileName).contains(uniqueIdentifier);
    }
}
