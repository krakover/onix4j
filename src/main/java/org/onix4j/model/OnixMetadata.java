package org.onix4j.model;

/**
 * User: Neta
 * Date: 6/2/14
 * Time: 11:40 AM
 */
public class OnixMetadata {
    public String sentDate;
     public String fileName;

    public OnixMetadata(String sentDate, String fileName) {
        this.fileName = fileName;
        this.sentDate = sentDate;
    }
}
