package org.onix4j.model;

/**
 * User: Neta
 * Date: 5/21/14
 * Time: 10:52 AM
 */

public class SalesRestriction {
    public String country;
    public String region;
    public String territory;

    @Override
    public String toString() {
        return (territory != null ? territory + "," : "") + "|" +
               (country != null ? country.replaceAll(" ",";") + ";" : "") + "|" +
                region;
    }
}
