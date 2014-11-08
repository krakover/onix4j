package org.onix4j.model;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import org.onix4j.metadata.Column;

/**
 * User: Neta
 * Date: 5/21/14
 * Time: 12:03 AM
 */
@XStreamAlias("price")
public class Price implements OnixProduct {
    @Column(columnName="price_type")
    public String priceType;

    @Column(columnName="price_amount")
    public String priceAmount;

    @Column(columnName="price_currencycode")
    public String priceCurrencyCode;

    @Override
    public String toString() {
        return "Price{" +
                "priceType=" + priceType +
                ", priceAmount=" + priceAmount +
                ", priceCurrencyCode=" + priceCurrencyCode +
                '}';
    }

    public String getUniqueKey() {
        return toString();
    }

    public OnixMetadata getOnixMetadata() {
        return null;
    }

    public void setOnixMetadata(OnixMetadata metadata) {
    }
}
