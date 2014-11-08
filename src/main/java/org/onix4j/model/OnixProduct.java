package org.onix4j.model;

/**
 * User: Neta
 * Date: 5/21/14
 * Time: 10:34 AM
 */
public interface OnixProduct {
    public String getUniqueKey();

    public OnixMetadata getOnixMetadata();
    public void setOnixMetadata(OnixMetadata metadata);
}
