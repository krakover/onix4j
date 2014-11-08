<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.loc.gov/MARC21/slim">
    <xsl:include href="http://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
    <xsl:output indent="yes"/>

    <!-- http://www.loc.gov/marc/onix2marc.html#mapping -->

    <xsl:template match="/ONIXmessage | /ONIXMessage">
        <collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd" >
            <xsl:apply-templates select="product | Product"/>
        </collection>
    </xsl:template>

    <xsl:template match="text()|@*"/> <!-- handles unwanted print of text nodes -->

    <xsl:param name="filename"/>

    <xsl:template match="product | Product">
         <xsl:variable name="isbn" select="productidentifier[b221='15']/b244 |  ProductIdentifier[ProductIDType='15']/IDValue"/>
         <xsl:choose>
             <xsl:when xmlns:tbx="java:org.onix4j.model.EnhanceProduct"
                       test="o4j:shouldHandleBook($filename, $isbn)">
                <record>
                     <leader>
                         <!-- 00-04 Record length -->
                         <xsl:text>    </xsl:text>
                         <!-- 05 Record Status -->
                         <xsl:choose>
                             <xsl:when test="a002=01 or NotificationType=01">n</xsl:when>
                             <!-- new -->
                             <xsl:when test="a002=02 or NotificationType=02">n</xsl:when>
                             <!-- new -->
                             <xsl:when test="a002=03 or NotificationType=03">c</xsl:when>
                             <!-- corrected -->
                             <xsl:when test="a002=04 or NotificationType=04">c</xsl:when>
                             <!-- corrected -->
                             <xsl:when test="a002=05 or NotificationType=05">d</xsl:when>
                             <!-- deleted -->
                             <xsl:otherwise>n</xsl:otherwise>
                             <!-- new -->
                         </xsl:choose>
                         <!-- 06 Type of record-->
                         <xsl:choose>
                             <xsl:when test="starts-with(b012,'A') or starts-with(ProductForm,'A')">j</xsl:when>
                             <xsl:when test="starts-with(b012,'B') or starts-with(ProductForm,'B')">a</xsl:when>
                             <xsl:when test="starts-with(b012,'C') or starts-with(ProductForm,'C')">e</xsl:when>
                             <xsl:when test="starts-with(b012,'F') or starts-with(ProductForm,'F')">g</xsl:when>
                             <xsl:when test="starts-with(b012,'M') or starts-with(ProductForm,'M')">a</xsl:when>
                             <xsl:when test="starts-with(b012,'V') or starts-with(ProductForm,'V')">g</xsl:when>
                             <xsl:when test="starts-with(b012,'W') or starts-with(ProductForm,'W')">p</xsl:when>
                             <xsl:when test="starts-with(b012,'X') or starts-with(ProductForm,'X')">r</xsl:when>
                             <xsl:when test="starts-with(b012,'Z') or starts-with(ProductForm,'Z')">r</xsl:when>
                             <xsl:when test="b012='DD' or ProductForm='DD'">g</xsl:when>
                             <xsl:when test="starts-with(b012,'D') or starts-with(ProductForm,'D')">m</xsl:when>
                             <xsl:when test="b012='PH' or ProductForm='PH'">o</xsl:when>
                             <xsl:when test="b012='PI' or ProductForm='PI'">c</xsl:when>
                             <xsl:when test="starts-with(b012,'P') or starts-with(ProductForm,'P')">k</xsl:when>
                             <xsl:otherwise>
                                 <xsl:text>m</xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>
                         <!-- 07 -->
                         <xsl:choose>
                             <xsl:when test="b020 or YearOfAnnual">s</xsl:when>
                             <xsl:otherwise>m</xsl:otherwise>
                         </xsl:choose>
                         <!-- 08 -->
                         <xsl:text> </xsl:text>
                         <!-- 09 -->
                         <xsl:text> </xsl:text>
                         <!-- 10 -->
                         <xsl:text>2</xsl:text>
                         <!-- 11 -->
                         <xsl:text>2</xsl:text>
                         <!-- 12-16 -->
                         <xsl:text>     </xsl:text>
                         <!-- 17 -->
                         <xsl:choose>
                             <xsl:when test="a002=01 or a002=02 or NotificationType=01 or NotificationType=02">8</xsl:when>
                             <xsl:otherwise>4</xsl:otherwise>
                         </xsl:choose>
                         <!-- 18 -->
                         <xsl:text> </xsl:text>
                         <!-- 19 -->
                         <xsl:text> </xsl:text>
                         <!-- 20-23 -->
                         <xsl:text>4500</xsl:text>
                     </leader>


                     <xsl:for-each select="a001 | RecordReference">
                         <controlfield tag="001">
                             <xsl:value-of select="."/>
                         </controlfield>
                     </xsl:for-each>

                     <controlfield tag="003">
                         <xsl:choose>
                             <xsl:when test="a196 or RecordSourceIdentifier">
                                 <xsl:value-of select="a196 | RecordSourceIdentifier"/>
                             </xsl:when>
                             <xsl:otherwise>XX-XxUND</xsl:otherwise>
                         </xsl:choose>
                      </controlfield>

                     <controlfield tag="006">
                         <!-- 0 electronic resource-->
                         <xsl:text>m</xsl:text>
                         <!-- 01-04 Undefined -->
                         <xsl:text>    </xsl:text>
                         <!-- 05 Target audience -->
                         <xsl:choose>
                             <xsl:when test="b073='01' or AudienceCode='01'">g</xsl:when>
                             <xsl:when test="b073='02' or AudienceCode='02'">j</xsl:when>
                             <xsl:when test="b073='03' or AudienceCode='03'">d</xsl:when>
                             <xsl:when test="b073='04' or AudienceCode='04'">b</xsl:when>
                             <xsl:when test="b073='05' or AudienceCode='05'">f</xsl:when>
                             <xsl:when test="b073='06' or AudienceCode='06'">f</xsl:when>
                             <xsl:when test="b073='07' or AudienceCode='07'">
                                 <xsl:text> </xsl:text>
                             </xsl:when>
                             <xsl:when test="b073='08' or AudienceCode='08'">e</xsl:when>
                             <xsl:otherwise>
                                 <xsl:text> </xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>
                         <!-- 06 Form of item-->
                         <xsl:text>o</xsl:text>
                         <!-- 07-08 undefined-->
                         <xsl:text>  </xsl:text>
                         <!-- 09 Form of item-->
                         <xsl:text>d</xsl:text>
                         <!-- 10 Undefined -->
                         <xsl:text> </xsl:text>
                         <!-- 11 Government publication -->
                         <xsl:text> </xsl:text>
                         <!-- 12-17 undefined -->
                         <xsl:text>      </xsl:text>
                     </controlfield>

                     <controlfield tag="007">
                         <xsl:choose>
                             <xsl:when test="b012='AA' or ProductForm='AA'">su uuuuuuuuuuu</xsl:when>
                             <xsl:when test="b012='AB' or ProductForm='AB'">ss lsnjlbmpnue</xsl:when>
                             <xsl:when test="b012='AC' or ProductForm='AC'">sd zsngnnmmnud</xsl:when>
                             <xsl:when test="b012='AD' or ProductForm='AD'">ss lsnjlbmpnud</xsl:when>
                             <xsl:when test="b012='AE' or ProductForm='AE'">sd zsnunnmmnud</xsl:when>
                             <xsl:when test="b012='AZ' or ProductForm='AZ'">sz zzzzzzzuuzz</xsl:when>
                             <xsl:when test="b012='BA' or ProductForm='BA'">tu</xsl:when>
                             <xsl:when test="b012='BB' or ProductForm='BB'">ta</xsl:when>
                             <xsl:when test="b012='BC' or ProductForm='BC'">ta</xsl:when>
                             <xsl:when test="b012='BD' or ProductForm='BD'">td</xsl:when>
                             <xsl:when test="b012='BE' or ProductForm='BE'">ta</xsl:when>
                             <xsl:when test="b012='BF' or ProductForm='BF'">ta</xsl:when>
                             <xsl:when test="b012='BG' or ProductForm='BG'">ta</xsl:when>
                             <xsl:when test="b012='BH' or ProductForm='BH'">tz</xsl:when>
                             <xsl:when test="b012='BI' or ProductForm='BI'">tz</xsl:when>
                             <xsl:when test="b012='BJ' or ProductForm='BJ'">tz</xsl:when>
                             <xsl:when test="b012='BZ' or ProductForm='BZ'">tz</xsl:when>
                             <xsl:when test="b012='CA' or ProductForm='CA'">aj cauua</xsl:when>
                             <xsl:when test="b012='CB' or ProductForm='CB'">aj cauua</xsl:when>
                             <xsl:when test="b012='CC' or ProductForm='CC'">aj cauua</xsl:when>
                             <xsl:when test="b012='CD' or ProductForm='CD'">aj cauua</xsl:when>
                             <xsl:when test="b012='CE' or ProductForm='CE'">du cun</xsl:when>
                             <xsl:when test="b012='CZ' or ProductForm='CZ'">aj cauua</xsl:when>
                             <xsl:when test="b012='DA' or ProductForm='DA'">cu uuu---uuuuu</xsl:when>
                             <xsl:when test="b012='DB' or ProductForm='DB'">cm ugu---uuuuu</xsl:when>
                             <xsl:when test="b012='DC' or ProductForm='DC'">cm ugu---uuuuu</xsl:when>
                             <xsl:when test="b012='DD' or ProductForm='DD'">vd cvaizu</xsl:when>
                             <xsl:when test="b012='DE' or ProductForm='DE'">cb cua---uuuuu</xsl:when>
                             <xsl:when test="b012='DF' or ProductForm='DF'">cj uau---uuuuu</xsl:when>
                             <xsl:when test="b012='DG' or ProductForm='DG'">tz</xsl:when>
                             <xsl:when test="b012='DH' or ProductForm='DH'">cr unu---aucuu</xsl:when>
                             <xsl:when test="b012='DZ' or ProductForm='DZ'">cu uuu---uuuuu</xsl:when>
                             <xsl:when test="b012='FA' or ProductForm='FA'">gt cjuuuu</xsl:when>
                             <xsl:when test="b012='FB' or ProductForm='FB'">go cjuuu</xsl:when>
                             <xsl:when test="b012='FC' or ProductForm='FC'">gs cjuufu</xsl:when>
                             <xsl:when test="b012='FD' or ProductForm='FD'">gt cjuuuc</xsl:when>
                             <xsl:when test="b012='FZ' or ProductForm='FZ'">gz cuuuzu</xsl:when>

                             <xsl:otherwise>
                                 <xsl:value-of select="b012 | ProductForm"/>
                             </xsl:otherwise>
                         </xsl:choose>
                     </controlfield>

                     <controlfield tag="008">
                         <xsl:text>      </xsl:text>
                         <xsl:choose>
                             <xsl:when test="b003 and b087">t</xsl:when>
                             <xsl:otherwise>s</xsl:otherwise>
                         </xsl:choose>
                         <xsl:choose>
                             <xsl:when test="b003 and b087">
                                 <xsl:value-of select="substring(b003,1,4)"/>
                                 <xsl:value-of select="substring(b087,1,4)"/>
                             </xsl:when>
                             <xsl:when test="b003">
                                 <xsl:value-of select="substring(b003,1,4)"/>
                                 <xsl:text>    </xsl:text>
                             </xsl:when>
                             <xsl:when test="b087">
                                 <xsl:value-of select="substring(b087,1,4)"/>
                                 <xsl:text>    </xsl:text>
                             </xsl:when>
                             <xsl:otherwise>
                                 <xsl:text>        </xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>

                         <xsl:choose>
                             <xsl:when test="b251"/>
                             <xsl:otherwise>
                                 <xsl:text>xx </xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>
                         <xsl:text>|||||||||||| ||||</xsl:text>
                         <xsl:choose>
                             <xsl:when test="b059">
                                 <xsl:value-of select="b059"/>
                             </xsl:when>
                             <xsl:when test="b253=01">
                                 <xsl:value-of select="b252"/>
                             </xsl:when>
                             <xsl:otherwise>
                                 <xsl:text>und</xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>
                         <xsl:text> d</xsl:text>
                     </controlfield>

                     <xsl:for-each select="productidentifier[b221='13'] | ProductIdentifier[ProductIDType='13']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">010</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="./b244 | ./IDValue"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each
                             select="productidentifier[b221='02' or b221='15'] | ProductIdentifier[ProductIDType='02' or ProductIDType='15']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">020</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="./b244 | ./IDValue"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b004 | ISBN">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">020</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b005 | EAN13">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">024</xsl:with-param>
                             <xsl:with-param name="ind1">3</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b006 | UPC">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">024</xsl:with-param>
                             <xsl:with-param name="ind1">1</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b008 | ISMN">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">024</xsl:with-param>
                             <xsl:with-param name="ind1">2</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b009 | DOI">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">024</xsl:with-param>
                             <xsl:with-param name="ind1">5</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each
                             select="productidentifier[b221='03' or b221='04' or b221='05' or b221='14'] | ProductIdentifier[ProductIDType='03' or ProductIDType='04' or ProductIDType='05' or ProductIDType='14']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">024</xsl:with-param>
                             <xsl:with-param name="ind1">
                                 <xsl:choose>
                                     <xsl:when test="b221='03' or ProductIDType='03'">3</xsl:when>
                                     <xsl:when test="b221='04' or ProductIDType='04'">1</xsl:when>
                                     <xsl:when test="b221='05' or ProductIDType='05'">2</xsl:when>
                                     <xsl:when test="b221='14' or ProductIDType='14'">7</xsl:when>
                                 </xsl:choose>
                             </xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="./b244 | ./IDValue"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="productidentifier[b221='01'] | ProductIdentifier[ProductIDType='01']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">028</xsl:with-param>
                             <xsl:with-param name="ind1">5</xsl:with-param>
                             <xsl:with-param name="ind2">0</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of select="./b244 | ./IDValue"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:when xmlns:tbx="java:org.onix4j.model.EnhanceProduct"
                              test="o4j:getCoverURLForIsbn($filename, $isbn) != 'null'">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">029</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:call-template name="get-cover">
                                         <xsl:with-param name="isbn" select="$isbn"/>
                                     </xsl:call-template>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:when>

                     <xsl:call-template name="datafield">
                         <xsl:with-param name="tag">037</xsl:with-param>
                         <xsl:with-param name="subfields">
                             <subfield code="n">
                                 <xsl:choose>
                                     <xsl:when test="supplydetail/j141='AB' or SupplyDetail/Availabilitycode='AB'">
                                         Cancelled
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='AD' or SupplyDetail/Availabilitycode='AD'">
                                         Available direct from publisher only
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='CS' or SupplyDetail/Availabilitycode='CS'">Check
                                         with customer service
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='EX' or SupplyDetail/Availabilitycode='EX'">
                                         Wholesaler or vendor only
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='IP' or SupplyDetail/Availabilitycode='IP'">
                                         Always Available
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='MD' or SupplyDetail/Availabilitycode='MD'">
                                         Manufactured_on_demand
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='NP' or SupplyDetail/Availabilitycode='NP'">Not
                                         yet published
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='NY' or SupplyDetail/Availabilitycode='NY'">Newly
                                         catalogued. Not yet in stock
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OF' or SupplyDetail/Availabilitycode='OF'">Other
                                         format available
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OI' or SupplyDetail/Availabilitycode='OI'">Out
                                         of stock indefinitely
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OP' or SupplyDetail/Availabilitycode='OP'">Out
                                         of print
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OR' or SupplyDetail/Availabilitycode='OR'">
                                         Replaced by new edition
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='PP' or SupplyDetail/Availabilitycode='PP'">
                                         Publication postponed indefinitely
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RF' or SupplyDetail/Availabilitycode='RF'">Refer
                                         to another supplier
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RM' or SupplyDetail/Availabilitycode='RM'">
                                         Remaindered
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RP' or SupplyDetail/Availabilitycode='RP'">
                                         Reprinting
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RU' or SupplyDetail/Availabilitycode='RU'">
                                         Reprinting undated
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TO' or SupplyDetail/Availabilitycode='TO'">
                                         Special order
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TP' or SupplyDetail/Availabilitycode='TP'">
                                         Temporarily out of stock because publisher cannot supply
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TU' or SupplyDetail/Availabilitycode='TU'">
                                         Temporarily unavailable
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='UR' or SupplyDetail/Availabilitycode='UR'">
                                         Unavailable awaiting reissue
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='WR' or SupplyDetail/Availabilitycode='WR'">Will
                                         be remaindered as of date
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='WS' or SupplyDetail/Availabilitycode='WS'">
                                         Withdrawn from sale
                                     </xsl:when>
                                     <xsl:otherwise>Always Available</xsl:otherwise>
                                 </xsl:choose>
                             </subfield>
                         </xsl:with-param>
                     </xsl:call-template>

                     <xsl:if test="a196">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">040</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="a196"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:for-each
                             select="subject[b067='03'] | mainsubject[b191='03'] | Subject[SubjectSchemeIdentifier='03'] | MainSubject[MainSubjectSchemeIdentifier='03']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">050</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b070 | SubjectHeadingText"/><xsl:text> ebook</xsl:text>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each
                             select="subject[b067='13'] | mainsubject[b191='13'] | Subject[SubjectSchemeIdentifier='13'] | MainSubject[MainSubjectSchemeIdentifier='13']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">052</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b070 | SubjectHeadingText"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b064 | BASICMainSubject">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">072</xsl:with-param>
                             <xsl:with-param name="ind2">0</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="."/>
                                 </subfield>
                                 <subfield code="02">
                                     <xsl:text>basishc</xsl:text>
                                     <xsl:for-each select="../b200 | ../BASICVersion">
                                         <xsl:text>/</xsl:text>
                                         <xsl:value-of select="."/>
                                     </xsl:for-each>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="b065 | BICMainSubject">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">072</xsl:with-param>
                             <xsl:with-param name="ind2">0</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="."/>
                                 </subfield>
                                 <subfield code="02">
                                     <xsl:text>bicscc</xsl:text>
                                     <xsl:for-each select="../b066 | ../BICVersion">
                                         <xsl:text>/</xsl:text>
                                         <xsl:value-of select="."/>
                                     </xsl:for-each>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:variable name="subject_scheme_identifiers_072"
                                   select="'04 10 12 14 15 16 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36'"/>
                     <xsl:for-each
                             select="mainsubject[contains( concat(' ', $subject_scheme_identifiers_072, ' '),b191)] | MainSubject[contains( concat(' ', $subject_scheme_identifiers_072, ' '),MainSubjectSchemeIdentifier)] | subject[contains( concat(' ', $subject_scheme_identifiers_072, ' '),b067)] | Subject[contains( concat(' ', $subject_scheme_identifiers_072, ' '),SubjectSchemeIdentifier)]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">072</xsl:with-param>
                             <xsl:with-param name="ind2">7</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b069 | SubjectCode"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:variable name="subject_scheme_identifiers_082" select="'01 02'"/>
                     <xsl:for-each
                             select="mainsubject[contains( concat(' ', $subject_scheme_identifiers_082, ' '),b191)] | MainSubject[contains( concat(' ', $subject_scheme_identifiers_082, ' '),MainSubjectSchemeIdentifier)] | subject[contains( concat(' ', $subject_scheme_identifiers_082, ' '),b067)] | Subject[contains( concat(' ', $subject_scheme_identifiers_082, ' '),SubjectSchemeIdentifier)]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">082</xsl:with-param>
                             <xsl:with-param name="ind1">
                                 <xsl:choose>
                                     <xsl:when test="b191='01' or b067='01' or MainSubjectSchemeIdentifier='01' or SubjectSchemeIdentifier='01'">0</xsl:when>
                                     <xsl:otherwise>1</xsl:otherwise>
                                     <!-- 02 -->
                                 </xsl:choose>
                             </xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b069 | SubjectCode"/>
                                 </subfield>
                                 <subfield code='2'>
                                     <xsl:value-of select="b068 | SubjectSchemeVersion"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>


                     <xsl:if test="subject/b067='25' or mainsubject/b191='25' or MainSubject/MainSubjectSchemeIdentifier='25' or Subject/SubjectSchemeIdentifier='25'">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">084</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code='a'>
                                     <xsl:value-of
                                             select="mainsubject[b191='25']/b069 | subject[b067='25']/b069 | Subject[SubjectSchemeIdentifier='25']/SubjectCode | MainSubject[MainSubjectSchemeIdentifier='25']/SubjectCode"/>
                                 </subfield>
                                 <subfield code='2'>
                                     <xsl:text>tmisbn</xsl:text>
                                     <xsl:for-each
                                             select="mainsubject[b191='25']/b068 | subject[b067='25']/b068 | Subject[SubjectSchemeIdentifier='25']/SubjectSchemeVersion | MainSubject[MainSubjectSchemeIdentifier='25']/SubjectSchemeVersion">
                                         <xsl:text>/</xsl:text>
                                         <xsl:value-of select="."/>
                                     </xsl:for-each>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:variable name="supported_contributor_types" select="'A01 A02'"/>
                     <xsl:for-each
                             select="contributor[(b036 or b037 or b040) and position()=1] | Contributor[(PersonName or PersonNameInverted or KeyNames) and position()=1]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">100</xsl:with-param>
                             <xsl:with-param name="ind1">1</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:choose>
                                         <xsl:when test="b037 or PersonNameInverted">
                                             <xsl:value-of select="b037 | PersonNameInverted"/>
                                         </xsl:when>
                                         <xsl:otherwise>
                                             <xsl:value-of select="b040 | KeyNames"/>
                                             <xsl:text>, </xsl:text>
                                             <xsl:value-of select="b039 | NamesBeforeKey"/>
                                         </xsl:otherwise>
                                     </xsl:choose>
                                     <xsl:if test="b247 | PrefixToKey">
                                         <xsl:text> </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                     <xsl:if test="b041 | NamesAfterKey">
                                         <xsl:text>, </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                 </subfield>
                                 <xsl:choose>
                                     <xsl:when test="b248 | SuffixToKey">
                                         <subfield code="c">
                                             <xsl:value-of select="b248[1] | SuffixToKey[1]"/>
                                         </subfield>
                                     </xsl:when>
                                     <xsl:otherwise>
                                         <xsl:if test="b043[1] | TitlesAfterNames[1]">
                                             <subfield code="c">
                                                 <xsl:value-of select="b043[1] | TitlesAfterNames[1]"/>
                                             </subfield>
                                         </xsl:if>
                                     </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:for-each select="b046 | Affiliation">
                                     <subfield code="u">
                                         <xsl:value-of select="."/>
                                     </subfield>
                                 </xsl:for-each>
                                 <xsl:for-each select="b035 | ContributorRole">
                                     <xsl:if test="contains( concat(' ', $supported_contributor_types, ' '),.)">
                                         <subfield code="4">
                                             <xsl:choose>
                                                 <xsl:when test=".='A01'">aut</xsl:when>
                                                 <xsl:when test=".='A12'">ill</xsl:when>
                                             </xsl:choose>
                                         </subfield>
                                     </xsl:if>
                                 </xsl:for-each>
                                 <xsl:for-each select="b306 | Date">
                                     <subfield code="d">
                                         <xsl:value-of select="b306 | Date"/>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:call-template name="datafield">
                         <xsl:with-param name="tag">245</xsl:with-param>
                         <xsl:with-param name="ind1">
                             <xsl:choose>
                                 <xsl:when test="b036 or b037 or b040 or PersonName or PersonNameInverted or KeyNames">1
                                 </xsl:when>
                                 <xsl:otherwise>0</xsl:otherwise>
                             </xsl:choose>
                         </xsl:with-param>
                         <xsl:with-param name="ind2">0</xsl:with-param>
                         <xsl:with-param name="subfields">
                             <subfield code="a">
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
                             </subfield>
                             <subfield code="h">[electronic resource]</subfield>
                             <xsl:for-each select="title/b029 | Title/Subtitle">
                                 <subfield code="b">
                                     <xsl:value-of select="."/>
                                 </subfield>
                             </xsl:for-each>

                             <subfield code="c">
                                 <xsl:for-each select="contributor | Contributor">
                                     <xsl:if test="position() > 1">,</xsl:if>
                                     <xsl:value-of select="b036 | PersonName"/>
                                 </xsl:for-each>
                             </subfield>
                             <!--subfield code="k">
                                <xsl:value-of select="b336 | ProductFormFeatureDescription"/>
                                <xsl:value-of select=" | ProductForm"/>
                                <xsl:value-of select="b333 | ProductFormDetail"/>
                            </subfield-->
                         </xsl:with-param>
                     </xsl:call-template>

                     <xsl:if test="b056 or b057 or b217 or b058 or EditionTypeCode or EditionNumber or EditionVersionNumber or EditionStatement">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">250</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of
                                             select="concat(b056, b057,b217,b058,EditionTypeCode,EditionNumber,EditionVersionNumber,EditionStatement)"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:call-template name="datafield">
                         <xsl:with-param name="tag">260</xsl:with-param>
                         <xsl:with-param name="subfields">
                             <subfield code="a">
                                 <xsl:choose>
                                     <xsl:when test="b209 | CityOfPublication">
                                         <xsl:value-of select="b209 | CityOfPublication"/>
                                     </xsl:when>
                                     <xsl:otherwise>[S.l.] :</xsl:otherwise>
                                 </xsl:choose>
                             </subfield>
                             <subfield code="b">
                                 <xsl:choose>
                                     <xsl:when test="imprint/b079 | Imprint/ImprintName"><xsl:value-of
                                             select="imprint/b079 | Imprint/ImprintName"/>,</xsl:when>
                                     <xsl:when test="publisher/b081 | Publisher/PublisherName"><xsl:value-of
                                             select="publisher/b081 | Publisher/PublisherName"/>,</xsl:when>
                                     <xsl:otherwise>[s.n.],</xsl:otherwise>
                                 </xsl:choose>
                             </subfield>
                             <subfield code="c">
                                 <xsl:choose>
                                     <xsl:when test="b003 | PublicationDate">
                                         <xsl:value-of select="substring(b003,1,4)"/>
                                         <xsl:value-of select="substring(PublicationDate,1,4)"/>
                                     </xsl:when>
                                     <xsl:when test="b087 | CopyrightYear">
                                         <xsl:value-of select="substring(b087,1,4)"/>
                                         <xsl:value-of select="substring(CopyrightYear,1,4)"/>
                                     </xsl:when>
                                     <xsl:otherwise>[?] :</xsl:otherwise>
                                 </xsl:choose>
                             </subfield>
                             <xsl:if test="(b003 and b087 and (substring(b003,1,4) != substring(b087,1,4))) or (PublicationDate and CopyrightYear and (substring(PublicationDate,1,4) != substring(CopyrightYear,1,4)))">
                                 <subfield code="c">
                                     <xsl:value-of select="substring(b087,1,4)"/>
                                     <xsl:value-of select="substring(CopyrightYear,1,4)"/>
                                 </subfield>
                             </xsl:if>
                         </xsl:with-param>
                     </xsl:call-template>

                     <xsl:if test="b061 or NumberOfPages">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">300</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">1 online resource (<xsl:value-of select="b061 | NumberOfPages"/><xsl:text> p.)</xsl:text>
                                 </subfield>
                                 <xsl:if test="measure/c093='01' or Measure/MeasureTypeCode='01'">
                                     <subfield code="c">
                                         <xsl:value-of select="measure/c094 | Measure/Measurement"/>
                                         <xsl:text> </xsl:text>
                                         <xsl:choose>
                                             <xsl:when test="measure/c095='gr' or Measure/MeasureUnitCode='gr'">grams.
                                             </xsl:when>
                                             <xsl:when test="measure/c095='in' or Measure/MeasureUnitCode='in'">in.
                                             </xsl:when>
                                             <xsl:when test="measure/c095='lb' or Measure/MeasureUnitCode='lb'">pounds.
                                             </xsl:when>
                                             <xsl:when test="measure/c095='mm' or Measure/MeasureUnitCode='mm'">mm.
                                             </xsl:when>
                                             <xsl:when test="measure/c095='oz' or Measure/MeasureUnitCode='oz'">oz.
                                             </xsl:when>
                                         </xsl:choose>
                                     </subfield>
                                 </xsl:if>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>


                     <xsl:variable name="other_text_type_code_500" select="'17 18 23 30 31 33'"/>

                     <xsl:if test="othertext[contains( concat(' ', $other_text_type_code_500, ' '),d102)] or OtherText[contains( concat(' ', $other_text_type_code_500, ' '),TextTypeCode)]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">500</xsl:with-param>

                             <xsl:with-param name="subfields">
                                 <xsl:for-each
                                         select="othertext[contains( concat(' ', $other_text_type_code_500, ' '),d102) and d104 != ''][0] | OtherText[contains( concat(' ', $other_text_type_code_500, ' '),TextTypeCode) and  Text != ''][0]">
                                     <subfield code="a">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text" select="d104 | Text"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="othertext[d102='04'] or OtherText[TextTypeCode='04']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">505</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <xsl:for-each select="othertext[d102='04'] | OtherText[TextTypeCode='04']">
                                     <subfield code="a">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text" select="d104 | Text"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>


                     <xsl:variable name="other_text_type_code_520_ind1_2" select="'01 02 12 14 25 26 27 28'"/>

                     <xsl:if test="othertext[contains( concat(' ', $other_text_type_code_520_ind1_2, ' '),d102) and d104 != ''] or OtherText[contains( concat(' ', $other_text_type_code_520_ind1_2, ' '),TextTypeCode) and Text != '']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">520</xsl:with-param>
                             <xsl:with-param name="ind1">2</xsl:with-param>

                             <xsl:with-param name="subfields">
                                 <xsl:for-each
                                         select="othertext[contains( concat(' ', $other_text_type_code_520_ind1_2, ' '),d102) and d104 != ''] | OtherText[contains( concat(' ', $other_text_type_code_520_ind1_2, ' '),TextTypeCode) and Text != '']">
                                     <subfield code="a">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text" select="d104 | Text"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:variable name="other_text_type_code_520_ind1_1" select="'07 08 10'"/>

                     <xsl:if test="othertext[contains( concat(' ', $other_text_type_code_520_ind1_1, ' '),d102)] or OtherText[contains( concat(' ', $other_text_type_code_520_ind1_1, ' '),TextTypeCode)]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">520</xsl:with-param>
                             <xsl:with-param name="ind1">1</xsl:with-param>

                             <xsl:with-param name="subfields">
                                 <xsl:for-each
                                         select="othertext[contains( concat(' ', $other_text_type_code_520_ind1_1, ' '),d102)][1] | OtherText[contains( concat(' ', $other_text_type_code_520_ind1_1, ' '),TextTypeCode)][1]">
                                     <subfield code="a">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text" select="d104 | Text"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:for-each>
                                 <xsl:if test="othertext/d101 | OtherText/MainDescription">
                                     <subfield code="a">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text"
                                                             select="othertext/d101 | OtherText/MainDescription"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:if>
                                 <xsl:if test="contributor/b048 |  Contributor/ContributorDescription">
                                     <subfield code="b">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text"
                                                             select="contributor/b048 |  Contributor/ContributorDescription"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:if>
                                 <xsl:for-each select="othertext[d102='13'] | OtherText[TextTypeCode='13']">
                                     <subfield code="b">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text" select="d104 | Text"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:if test="b073 or AudienceCode">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">521</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:choose>
                                         <xsl:when test="b073='01' or AudienceCode='01'">General adult.</xsl:when>
                                         <xsl:when test="b073='02' or AudienceCode='02'">Children/juvenile.</xsl:when>
                                         <xsl:when test="b073='03' or AudienceCode='03'">Young adult.</xsl:when>
                                         <xsl:when test="b073='04' or AudienceCode='04'">Primary and secondary school.
                                         </xsl:when>
                                         <xsl:when test="b073='05' or AudienceCode='05'">College/higher education.
                                         </xsl:when>
                                         <xsl:when test="b073='06' or AudienceCode='06'">Professional and scholarly.
                                         </xsl:when>
                                         <xsl:when test="b073='07' or AudienceCode='07'">English as second language.
                                         </xsl:when>
                                         <xsl:when test="b073='08' or AudienceCode='08'">Adult education</xsl:when>
                                     </xsl:choose>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:call-template name="datafield">
                         <xsl:with-param name="tag">533</xsl:with-param>
                         <xsl:with-param name="subfields">
                             <subfield code="n">
                                 <xsl:choose>
                                     <xsl:when test="supplydetail/j141='AB' or SupplyDetail/Availabilitycode='AB'">
                                         Cancelled
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='AD' or SupplyDetail/Availabilitycode='AD'">
                                         Available direct from publisher only
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='CS' or SupplyDetail/Availabilitycode='CS'">Check
                                         with customer service
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='EX' or SupplyDetail/Availabilitycode='EX'">
                                         Wholesaler or vendor only
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='IP' or SupplyDetail/Availabilitycode='IP'">
                                         Always Available
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='MD' or SupplyDetail/Availabilitycode='MD'">
                                         Manufactured_on_demand
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='NP' or SupplyDetail/Availabilitycode='NP'">Not
                                         yet published
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='NY' or SupplyDetail/Availabilitycode='NY'">Newly
                                         catalogued. Not yet in stock
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OF' or SupplyDetail/Availabilitycode='OF'">Other
                                         format available
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OI' or SupplyDetail/Availabilitycode='OI'">Out
                                         of stock indefinitely
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OP' or SupplyDetail/Availabilitycode='OP'">Out
                                         of print
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='OR' or SupplyDetail/Availabilitycode='OR'">
                                         Replaced by new edition
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='PP' or SupplyDetail/Availabilitycode='PP'">
                                         Publication postponed indefinitely
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RF' or SupplyDetail/Availabilitycode='RF'">Refer
                                         to another supplier
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RM' or SupplyDetail/Availabilitycode='RM'">
                                         Remaindered
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RP' or SupplyDetail/Availabilitycode='RP'">
                                         Reprinting
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='RU' or SupplyDetail/Availabilitycode='RU'">
                                         Reprinting undated
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TO' or SupplyDetail/Availabilitycode='TO'">
                                         Special order
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TP' or SupplyDetail/Availabilitycode='TP'">
                                         Temporarily out of stock because publisher cannot supply
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='TU' or SupplyDetail/Availabilitycode='TU'">
                                         Temporarily unavailable
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='UR' or SupplyDetail/Availabilitycode='UR'">
                                         Unavailable awaiting reissue
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='WR' or SupplyDetail/Availabilitycode='WR'">Will
                                         be remaindered as of date
                                     </xsl:when>
                                     <xsl:when test="supplydetail/j141='WS' or SupplyDetail/Availabilitycode='WS'">
                                         Withdrawn from sale
                                     </xsl:when>
                                     <xsl:otherwise>Always Available</xsl:otherwise>
                                 </xsl:choose>
                             </subfield>
                         </xsl:with-param>
                     </xsl:call-template>

                     <xsl:if test="contributor/b044 or Contributor/BiographicalNote or contributor/b048 or Contributor/ContributorDescription or othertext[/d102='13'] or OtherText[/TextTypeCode='13']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">545</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <xsl:choose>
                                     <xsl:when test="contributor/b044 |  Contributor/BiographicalNote">
                                         <subfield code="a">
                                             <xsl:call-template name="remove-html">
                                                 <xsl:with-param name="text"
                                                                 select="contributor/b044 | Contributor/BiographicalNote"/>
                                             </xsl:call-template>
                                         </subfield>
                                     </xsl:when>
                                     <xsl:when test="othertext[d102='13'] | OtherText[TextTypeCode='13']">
                                         <xsl:for-each select="othertext[d102='13'] | OtherText[TextTypeCode='13']">
                                             <xsl:call-template name="remove-html">
                                                 <xsl:with-param name="text" select="d104 | Text"/>
                                             </xsl:call-template>
                                         </xsl:for-each>
                                     </xsl:when>
                                 </xsl:choose>

                                 <xsl:if test="contributor/b048 |  Contributor/ContributorDescription">
                                     <subfield code="b">
                                         <xsl:call-template name="remove-html">
                                             <xsl:with-param name="text"
                                                             select="contributor/b048 |  Contributor/ContributorDescription"/>
                                         </xsl:call-template>
                                     </subfield>
                                 </xsl:if>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:if>

                     <xsl:for-each select="personassubject | PersonAsSubject">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">600</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:choose>
                                         <xsl:when test="b037 or PersonNameInverted">
                                             <xsl:value-of select="b037 | PersonNameInverted"/>
                                         </xsl:when>
                                         <xsl:otherwise>
                                             <xsl:value-of select="b040 | KeyNames"/>
                                             <xsl:text>, </xsl:text>
                                             <xsl:value-of select="b039 | NamesBeforeKey"/>
                                         </xsl:otherwise>
                                     </xsl:choose>
                                     <xsl:if test="b247 | PrefixToKey">
                                         <xsl:text> </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                     <xsl:if test="b041 | NamesAfterKey">
                                         <xsl:text>, </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                 </subfield>
                                 <xsl:choose>
                                     <xsl:when test="b248 | SuffixToKey">
                                         <subfield code="c">
                                             <xsl:value-of select="b248[1] | SuffixToKey[1]"/>
                                         </subfield>
                                     </xsl:when>
                                     <xsl:otherwise>
                                         <xsl:if test="b043[1] | TitlesAfterNames[1]">
                                             <subfield code="c">
                                                 <xsl:value-of select="b043[1] | TitlesAfterNames[1]"/>
                                             </subfield>
                                         </xsl:if>
                                     </xsl:otherwise>
                                 </xsl:choose>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each
                             select="subject[b067='04'] | mainsubject[b191='04'] | Subject[SubjectSchemeIdentifier='04'] | MainSubject[MainSubjectSchemeIdentifier='04'] | subject[b067='02'] | mainsubject[b191='02'] | Subject[SubjectSchemeIdentifier='02'] | MainSubject[MainSubjectSchemeIdentifier='02']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">650</xsl:with-param>
                             <xsl:with-param name="ind2">4</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b070 | SubjectHeadingText"/>
                                 </subfield>
                                 <subfield code="02">
                                     <xsl:value-of
                                             select="b191 | b068 | MainSubjectSchemeIdentifier | SubjectSchemeVersion"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>

                     <xsl:variable name="subjects"
                                   xmlns:o4j="java:org.onix4j.model.EnhanceProduct"
                                   select="o4j:getSubjectsByISBN($isbn)"/>

                     <xsl:for-each select="$subjects">
                         <xsl:variable name="subject" select="."/>
                         <xsl:if test="$subject != ''">
                             <xsl:variable name="form"
                                           xmlns:o4j="java:org.onix4j.model.EnhanceProduct"
                                           select="o4j:getSubjectsFormSubdivisionByISBN($isbn, $subject)"/>
                             <xsl:call-template name="datafield">
                                 <xsl:with-param name="tag">650</xsl:with-param>
                                 <xsl:with-param name="ind2">0</xsl:with-param>
                                 <xsl:with-param name="subfields">
                                     <subfield code='a'>
                                         <xsl:value-of select="$subject"/>
                                     </subfield>
                                     <xsl:if test="$form != 'null'">
                                         <subfield code='v'>
                                             <xsl:value-of select="$form"/>
                                         </subfield>
                                     </xsl:if>
                                 </xsl:with-param>

                             </xsl:call-template>
                         </xsl:if>
                     </xsl:for-each>


                     <xsl:for-each
                             select="subject[b067='20'] | mainsubject[b191='20'] | Subject[SubjectSchemeIdentifier='20'] | MainSubject[MainSubjectSchemeIdentifier='20']">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">653</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:value-of select="b070 | SubjectHeadingText"/>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>


                     <xsl:call-template name="datafield">
                         <xsl:with-param name="tag">655</xsl:with-param>
                         <xsl:with-param name="ind2">0</xsl:with-param>
                         <xsl:with-param name="subfields">
                             <subfield code='a'>Electronic books</subfield>
                         </xsl:with-param>
                     </xsl:call-template>

                     <xsl:for-each select="b064 | BASICMainSubject">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">655</xsl:with-param>
                             <xsl:with-param name="ind2">4</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:call-template name="get-bisac-name">
                                         <xsl:with-param name="bisac_code">
                                             <xsl:value-of select="."/>
                                         </xsl:with-param>
                                     </xsl:call-template>
                                 </subfield>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>


                     <xsl:for-each
                             select="subject[b067='10' and b069] | mainsubject[b191='10' and b069] | Subject[SubjectSchemeIdentifier='10' and SubjectCode] | MainSubject[MainSubjectSchemeIdentifier='10' and SubjectCode]">
                         <xsl:choose>
                             <xsl:when xmlns:o4j="java:org.onix4j.model.EnhanceProduct"
                                       test="o4j:getBISACNameByBISACCode(b069 | SubjectCode) != 'null'">
                                 <xsl:call-template name="datafield">
                                     <xsl:with-param name="tag">655</xsl:with-param>
                                     <xsl:with-param name="ind2">4</xsl:with-param>
                                     <xsl:with-param name="subfields">
                                         <subfield code="a">
                                             <xsl:call-template name="get-bisac-name">
                                                 <xsl:with-param name="bisac_code">
                                                     <xsl:value-of select="b069 | SubjectCode"/>
                                                 </xsl:with-param>
                                             </xsl:call-template>
                                         </subfield>
                                     </xsl:with-param>
                                 </xsl:call-template>
                             </xsl:when>
                         </xsl:choose>
                     </xsl:for-each>

                     <xsl:for-each
                             select="contributor[(b036 or b037 or b040) and position()!=1] | Contributor[(PersonName or PersonNameInverted or KeyNames) and position()!=1]">
                         <xsl:call-template name="datafield">
                             <xsl:with-param name="tag">700</xsl:with-param>
                             <xsl:with-param name="ind1">1</xsl:with-param>
                             <xsl:with-param name="subfields">
                                 <subfield code="a">
                                     <xsl:choose>
                                         <xsl:when test="b037 or PersonNameInverted">
                                             <xsl:value-of select="b037 | PersonNameInverted"/>
                                         </xsl:when>
                                         <xsl:otherwise>
                                             <xsl:value-of select="b040 | KeyNames"/>
                                             <xsl:text>, </xsl:text>
                                             <xsl:value-of select="b039 | NamesBeforeKey"/>
                                         </xsl:otherwise>
                                     </xsl:choose>
                                     <xsl:if test="b247 | PrefixToKey">
                                         <xsl:text> </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                     <xsl:if test="b041 | NamesAfterKey">
                                         <xsl:text>, </xsl:text>
                                         <xsl:value-of select="b247 | PrefixToKey"/>
                                     </xsl:if>
                                 </subfield>
                                 <xsl:choose>
                                     <xsl:when test="b248 | SuffixToKey">
                                         <subfield code="c">
                                             <xsl:value-of select="b248[1] | SuffixToKey[1]"/>
                                         </subfield>
                                     </xsl:when>
                                     <xsl:otherwise>
                                         <xsl:if test="b043[1] | TitlesAfterNames[1]">
                                             <subfield code="c">
                                                 <xsl:value-of select="b043[1] | TitlesAfterNames[1]"/>
                                             </subfield>
                                         </xsl:if>
                                     </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:for-each select="b046 | Affiliation">
                                     <subfield code="u">
                                         <xsl:value-of select="."/>
                                     </subfield>
                                 </xsl:for-each>
                                 <xsl:for-each select="b035 | ContributorRole">
                                     <xsl:if test="contains( concat(' ', $supported_contributor_types, ' '),.)">
                                         <subfield code="4">
                                             <xsl:choose>
                                                 <xsl:when test=".='A01'">aut</xsl:when>
                                                 <xsl:when test=".='A12'">ill</xsl:when>
                                             </xsl:choose>
                                         </subfield>
                                     </xsl:if>
                                 </xsl:for-each>
                                 <xsl:for-each select="b306 | Date">
                                     <subfield code="d">
                                         <xsl:value-of select="b306 | Date"/>
                                     </subfield>
                                 </xsl:for-each>
                             </xsl:with-param>
                         </xsl:call-template>
                     </xsl:for-each>
                 </record>
             </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-cover" xmlns:o4j="java:org.onix4j.model.EnhanceProduct">
        <xsl:param name="isbn"/>
        <xsl:value-of select="o4j:getCoverURLForIsbn(string($isbn))"/>
    </xsl:template>

    <xsl:template name="get-bisac-name" xmlns:o4j="java:org.onix4j.model.EnhanceProduct">
        <xsl:param name="bisac_code"/>
        <xsl:value-of select="o4j:getBISACNameByBISACCode($bisac_code)"/>
    </xsl:template>

    <xsl:template name="remove-html">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '&lt;')">
                <xsl:value-of select="substring-before($text, '&lt;')"/>
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>