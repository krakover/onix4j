<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>

    <xsl:template match="text()|@*"/> <!-- handles unwanted print of text nodes -->
    <xsl:param name="fileName"/>
    <xsl:param name="timestamp"/>

    <xsl:template match="/ONIXMessage | /ONIXmessage">
        <onix>
            <sentDate><xsl:value-of select="header/m182 | Header/SentDate"/></sentDate>
            <xsl:apply-templates select="product | Product"/>
        </onix>
    </xsl:template>

    <xsl:template match="product | Product">
        <basicproduct>
            <isbn><xsl:value-of select="productidentifier[b221='15']/b244 | ProductIdentifier[ProductIDType='15']/IDValue"/></isbn>
            <title>
                <xsl:choose>
                    <xsl:when test="title/b203 | Title/TitleText">
                        <xsl:value-of select="title/b203 | Title/TitleText"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="title/b030 | Title/TitlePrefix"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="title/b031 | Title/TitleWithoutPrefix"/>
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <subtitle>
                <xsl:value-of select="title/b029 | Title/Subtitle"/>
            </subtitle>

            <seriesTitle>
                <xsl:value-of select="series/b018 | Series/TitleOfSeries"/>
            </seriesTitle>

            <description>
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="othertext[d102='01' or d102='12' or d102='14'  or d102='25'  or d102='26'  or d102='27'  or d102='28']/d104 | OtherText[TextTypeCode='01' or TextTypeCode='12' or TextTypeCode='14'  or TextTypeCode='25'  or TextTypeCode='26'  or TextTypeCode='27'  or TextTypeCode='28']/Text"/>
                </xsl:call-template>
            </description>

            <descriptionFormat>
                    <xsl:choose>
                        <xsl:when test="othertext[d102='01' or d102='12' or d102='14'  or d102='25'  or d102='26'  or d102='27'  or d102='28']/d103 = '02' or OtherText[TextTypeCode='01' or TextTypeCode='12' or TextTypeCode='14'  or TextTypeCode='25'  or TextTypeCode='26'  or TextTypeCode='27'  or TextTypeCode='28']/TextFormat = '02'">HTML</xsl:when>
                        <xsl:when test="othertext[d102='01' or d102='12' or d102='14'  or d102='25'  or d102='26'  or d102='27'  or d102='28']/d103 = '03' or OtherText[TextTypeCode='01' or TextTypeCode='12' or TextTypeCode='14'  or TextTypeCode='25'  or TextTypeCode='26'  or TextTypeCode='27'  or TextTypeCode='28']/TextFormat = '03'">XML</xsl:when>
                        <xsl:when test="othertext[d102='01' or d102='12' or d102='14'  or d102='25'  or d102='26'  or d102='27'  or d102='28']/d103 = '06' or OtherText[TextTypeCode='01' or TextTypeCode='12' or TextTypeCode='14'  or TextTypeCode='25'  or TextTypeCode='26'  or TextTypeCode='27'  or TextTypeCode='28']/TextFormat = '06'">Default_text_format</xsl:when>
                        <xsl:otherwise>Default_text_format</xsl:otherwise>
                    </xsl:choose>
            </descriptionFormat>

            <shortDescription>
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="othertext[d102='02']/d104 | OtherText[TextTypeCode='02']/Text"/>
                </xsl:call-template>
            </shortDescription>

            <shortDescriptionFormat>
                    <xsl:choose>
                        <xsl:when test="othertext[d102='02']/d103 = '02' or OtherText[TextTypeCode='02']/TextFormat = '02'">HTML</xsl:when>
                        <xsl:when test="othertext[d102='02']/d103 = '03' or OtherText[TextTypeCode='02']/TextFormat = '03'">XML</xsl:when>
                        <xsl:when test="othertext[d102='02']/d103 = '06' or OtherText[TextTypeCode='02']/TextFormat = '06'">Default_text_format</xsl:when>
                        <xsl:otherwise>Default_text_format</xsl:otherwise>
                    </xsl:choose>
            </shortDescriptionFormat>

            <bisacCodes>
                <xsl:for-each select="b064 | BASICMainSubject">
                    <bisacCode><xsl:value-of select="."/></bisacCode>
                </xsl:for-each>
                <xsl:for-each select="subject[b067=10]/b069 | Subject[SubjectSchemeIdentifier=10]/SubjectCode">
                    <bisacCode><xsl:value-of select="."/></bisacCode>
                </xsl:for-each>
            </bisacCodes>

            <bicCodes>
                <xsl:for-each select="b065 | BICMainSubject">
                    <bicCode><xsl:value-of select="."/></bicCode>
                </xsl:for-each>
            </bicCodes>


            <authorNames>
                <xsl:for-each select="contributor[(b036) and b035='A01']/b036 | Contributor[(PersonName or PersonNameInverted or KeyNames) and ContributorRole='A01']/PersonName">
                    <authorName><xsl:value-of select="."/></authorName>
                </xsl:for-each>
            </authorNames>


            <xsl:variable name="editor_roles" select="'B01 B09 B11 B12 B13 B16'" />

            <editorNames>
                <xsl:for-each select="contributor[b036 and contains( concat(' ', $editor_roles, ' '),b035)]/b036 | Contributor[PersonName and  contains( concat(' ', $editor_roles, ' '), ContributorRole)]/PersonName">
                    <editorName><xsl:value-of select="."/></editorName>
                </xsl:for-each>
            </editorNames>

            <languageCode><xsl:value-of select="language[b253 = '01'][1]/b252 | Language[LanguageRole = '01'][1]/LanguageCode"/></languageCode>

            <numPages><xsl:value-of select="b061 | NumberOfPages"/></numPages>

            <publisherName><xsl:value-of select="publisher[1]/b081[1] | Publisher[1]/PublisherName[1]"/></publisherName>

            <publicationDate><xsl:value-of select="b003 | PublicationDate"/></publicationDate>

            <xsl:for-each select="subject[b067=1] | Subject[SubjectSchemeIdentifier=1]">
                <deweyCode>
                    <xsl:choose>
                        <xsl:when test="(b069 and translate(b069,' ', '') = '') or (SubjectCode and translate(./SubjectCode,' ', '') = '')">
                            <xsl:value-of select="b069 | SubjectCode"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="b070 | SubjectHeadingText"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </deweyCode>
            </xsl:for-each>

            <keywords><xsl:value-of select="subject[b067=20]/b070 | Subject[SubjectSchemeIdentifier=20]/SubjectHeadingText"/></keywords>

            <prices>
                <xsl:for-each select="supplydetail/price | SupplyDetail/Price">
                    <price>
                        <priceAmount><xsl:value-of select="j151 | PriceAmount"/></priceAmount>
                        <priceCurrencyCode><xsl:value-of select="j152 | CurrencyCode"/></priceCurrencyCode>
                        <priceType>
                            <xsl:choose>
                                <xsl:when test="j148 = '01' or PriceTypeCode = '01'">RRP_excluding_tax</xsl:when>
                                <xsl:when test="j148 = '02' or PriceTypeCode = '02'">RRP_including_tax</xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </priceType>
                    </price>
                </xsl:for-each>
            </prices>

            <xsl:variable name="NO_SALES_RIGHTS" select="'03 04 05 06'" />
            <xsl:variable name="UNRESTRICTED_SALES_RIGHTS" select="'01 02 07 08'" />

            <salesAlloweds>
                <xsl:for-each select="salesrights[contains( concat(' ', $UNRESTRICTED_SALES_RIGHTS, ' '),b089)] | SalesRights[contains( concat(' ', $UNRESTRICTED_SALES_RIGHTS, ' '),SalesRightsType)]">
                    <salesAllowed>
                        <country><xsl:value-of select="b090 | RightsCountry"/></country>
                        <territory><xsl:value-of select="b388 | RightsTerritory"/></territory>
                        <region><xsl:value-of select="b091 | RightsRegion"/></region>
                    </salesAllowed>
                </xsl:for-each>
            </salesAlloweds>

            <salesBanneds>
                <xsl:for-each select="salesrights[contains( concat(' ', $NO_SALES_RIGHTS, ' '),b089)] | SalesRights[contains( concat(' ', NO_SALES_RIGHTS, ' '),SalesRightsType)]">
                    <salesBanned>
                        <country><xsl:value-of select="b090 | RightsCountry"/></country>
                        <territory><xsl:value-of select="b388 | RightsTerritory"/></territory>
                        <region><xsl:value-of select="b091 | RightsRegion"/></region>
                    </salesBanned>
                </xsl:for-each>
            </salesBanneds>

            <onixTimestamp>
                <xsl:choose>
                    <xsl:when test="$timestamp = null"><xsl:value-of select="../header/m182 | ../Header/SentDate"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$timestamp"/></xsl:otherwise>
                </xsl:choose>
            </onixTimestamp>
        </basicproduct>

    </xsl:template>

    <xsl:template name="remove-html">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '&lt;')">
                <xsl:value-of select="substring-before($text, '&lt;')"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($text, '\n')">
                <xsl:value-of select="substring-before($text, '\n')"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="substring-after($text, '\n')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>