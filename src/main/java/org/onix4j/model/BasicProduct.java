package org.onix4j.model;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
import org.onix4j.metadata.Column;
import org.onix4j.metadata.Table;

import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: Neta
 * Date: 5/19/14
 * Time: 3:23 AM
 */
@XStreamAlias("basicproduct")
@Table(tableName="onix", schemaName = "staging")
public class BasicProduct implements OnixProduct {
    @Column(columnName = "isbn13")
    public String isbn;

    @Column(columnName = "title_text")
    public String title;

    @Column(columnName = "title_subtitle")
    public String subtitle;

    @Column(columnName = "series_title")
    public String seriesTitle;

    @Column(columnName = "author_name", instances = 3, elementName="authorName")
    public List<String> authorNames;

    @Column(columnName = "editor_name", instances = 2, elementName="editorName")
    public List<String> editorNames;

    @Column(columnName = "language_code")
    public String languageCode;

    @Column(columnName = "num_of_pages")
    public String numPages;

    @Column(columnName = "publisher_name")
    public String publisherName;

    @Column(columnName = "publication_date")
    public String publicationDate;

     @Column(columnName = "dewey_code")
    public String deweyCode;

    @Column(columnName = "bisac_code", instances = 5, elementName = "bisacCode")
    public List<String> bisacCodes;

    @Column(columnName = "bic_code", instances = 5, elementName = "bicCode")
    public List<String> bicCodes;

    @Column
    public String keywords;

    @Column(instances = 3, elementName = "price")
    public List<Price> prices;

    @Column(columnName="sales_allowed", instances = 3, elementName = "salesAllowed")
    public List<SalesRestriction> salesAlloweds;

    @Column(columnName="sales_banned", instances = 3, elementName = "salesBanned")
    public List<SalesRestriction> salesBanneds;

    @Column
    public String description;

    @Column(columnName = "description_text_format")
    public String descriptionFormat;

    @Column(columnName = "short_description")
    public String shortDescription;

    @Column(columnName = "short_description_text_format")
    public String shortDescriptionFormat;

    @Column(columnName = "onix_timestamp")
    public String onixTimestamp;

    @Column
    public String provider;

    @XStreamOmitField
    private OnixMetadata onixMetadata;

    @Override
    public String toString() {
        return "BasicProduct{" +
                "isbn='" + isbn + '\'' +
                ", title='" + title + '\'' +
                ", subtitle='" + subtitle + '\'' +
                ", seriesTitle='" + seriesTitle + '\'' +
                ", authorNames=" + authorNames +
                ", editorNames=" + editorNames +
                ", languageCode='" + languageCode + '\'' +
                ", numPages='" + numPages + '\'' +
                ", publisherName='" + publisherName + '\'' +
                ", publicationDate='" + publicationDate + '\'' +
                ", deweyCode='" + deweyCode + '\'' +
                ", bisacCodes=" + bisacCodes +
                ", bicCodes=" + bicCodes +
                ", keywords='" + keywords + '\'' +
                ", prices=" + prices +
                ", salesAlloweds=" + salesAlloweds +
                ", salesBanneds=" + salesBanneds +
                ", description='" + description + '\'' +
                ", descriptionFormat='" + descriptionFormat + '\'' +
                ", short_description='" + shortDescription + '\'' +
                ", shortDescriptionFormat='" + shortDescriptionFormat + '\'' +
                ", onixTimestamp='" + onixTimestamp + '\'' +
                ", provider='" + provider + '\'' +
                '}';
    }

    public String getUniqueKey() {
        return isbn;
    }

    public OnixMetadata getOnixMetadata() {
        return onixMetadata;
    }

    public void setOnixMetadata(OnixMetadata metadata) {
        this.onixMetadata = metadata;
    }
}
