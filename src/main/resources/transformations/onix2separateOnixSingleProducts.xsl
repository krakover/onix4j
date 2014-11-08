<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns="http://www.loc.gov/MARC21/slim">

    <xsl:output indent="yes"/>
    <xsl:template match="/ONIXmessage | /ONIXmessage">
        <xsl:for-each select="product | Product">
            <xsl:result-document method="xml" href="file_{productidentifier[b221='15']/b244 | ProductIdentifier[ProductIDType='15']/IDValue}-{tokenize(base-uri(), '/')[last()]}.o4j">
                <xsl:element name="{../name()}">
                    <xsl:copy-of select="../Header/. | ../header/." />
                    <xsl:copy-of select="." />
                </xsl:element>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>