package org.onix4j.filter;

import org.onix4j.model.Onix;
import org.onix4j.model.OnixProduct;

/**
 * User: Neta
 * Date: 6/3/14
 * Time: 12:00 PM
 */
public interface Filter<T extends OnixProduct> {
    public boolean useFile(String fileName);

    public boolean useOnix(Onix<T> onix);

    public boolean useProduct(String fileName, String uniqueIdentifier);
}
