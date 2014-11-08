package org.onix4j.reader;

import org.onix4j.model.OnixLog;

import java.util.List;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 11:59 AM
 */
public class LogFileOnixInput implements OnixInput {
    private OnixLog log;

    public LogFileOnixInput(String logFileName) {
        log = new OnixLog(logFileName);
    }

    public LogFileOnixInput(OnixLog log) {
        this.log = log;
    }

    public List<String> getFileNames() {
        return log.getOnixFileNames();
    }
}
