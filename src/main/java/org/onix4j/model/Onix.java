package org.onix4j.model;

import com.thoughtworks.xstream.annotations.XStreamAlias;

import java.util.List;

/**
 * User: Neta
 * Date: 5/20/14
 * Time: 4:32 PM
 */
@XStreamAlias("onix")
public class Onix<T extends OnixProduct>  {
    public String sentDate;
    public List<T> products;

    @Override
    public String toString() {
        return "Onix{" +
                ", products=" + products +
                '}';
    }

    public void setMetaData(OnixMetadata onixMetadata) {
        if (products != null) {
            for (T product : products) {
                product.setOnixMetadata(onixMetadata);
            }
        }
    }
}
