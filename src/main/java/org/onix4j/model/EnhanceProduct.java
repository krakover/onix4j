package org.onix4j.model;

import org.onix4j.filter.Filter;

import java.util.ArrayList;
import java.util.List;


/**
 * User: Neta
 * Date: 5/25/14
 * Time: 1:12 PM
 */
public class EnhanceProduct {
    public static List<Filter> filters;

    /**
     * @param fileName of the onix file being processed
     * @param isbn of the current product on hand
     * @return true iff the product should be handled
     */
    public static boolean shouldHandleBook(String fileName, String isbn) {
        if (filters != null) {
            for (Filter filter : filters) {
                if (!filter.useProduct(fileName, isbn)) {
                    return false;
                }
            }
        }
        return true;
    }

    public static String getCoverURLForIsbn(String isbn) {
        // TODO Add your logic here
        return null;
    }

    public static List<String> getSubjectsByISBN(String isbn) {
        // TODO Add your logic here
        return new ArrayList<String>(0);
    }

     public static String getSubjectsFormSubdivisionByISBN(String isbn, String subjectToMatch) {
         // TODO Add your logic here
         return null;
     }
}
