<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version ="1.0"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:datacite="http://datacite.org/schema/kernel-4"
                xmlns:oaire="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns="http://namespace.openaire.eu/schema/oaire/"
                xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
       <resource xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd">
        <xsl:apply-templates select="root/zbmath_url"/>

                <xsl:if test="root/links/*">
                    <datacite:alternateIdentifiers>
                    <xsl:apply-templates select="root/links"/>
                    </datacite:alternateIdentifiers>
                </xsl:if>

               <datacite:creators>
                <xsl:apply-templates select="root/contributors/authors"/>
              </datacite:creators>

           <datacite:titles>
           <xsl:apply-templates select="root/title"/>
           </datacite:titles>

           <xsl:apply-templates select="root/editorial_contributions/text"/>

           <datacite:rights rightsURI="http://purl.org/coar/access_right/c_14cb">metadata only access</datacite:rights>


   <dc:format>application/xml</dc:format>

                 <datacite:subjects>
                <xsl:apply-templates select="root/msc"/>
                <xsl:apply-templates select="root/keywords"/>
                 </datacite:subjects>

          <datacite:dates>
    <xsl:choose>

        <xsl:when test="root/year[normalize-space(.) != ''
                                 and . != 'None'
                                 and . != 'none'
                                 and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]">
            <datacite:date dateType="Issued">
                <xsl:value-of select="root/year"/>
            </datacite:date>
        </xsl:when>

        <xsl:otherwise>
            <xsl:if test="root/source/series/year[normalize-space(.) != ''
                                                  and . != 'None'
                                                  and . != 'none'
                                                  and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]">
                <datacite:date dateType="Issued">
                    <xsl:value-of select="root/source/series/year"/>
                </datacite:date>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</datacite:dates>

           <xsl:apply-templates select="root/source/series/publisher"/>


             <xsl:choose>
            <xsl:when test="not(root/document_type) or not(root/document_type/*)">
             <xsl:element name="resourceType">
            <xsl:attribute name="resourceTypeGeneral">literature</xsl:attribute>
            <xsl:attribute name="uri">http://purl.org/coar/resource_type/c_1843</xsl:attribute>
            <xsl:text>other</xsl:text>
             </xsl:element>
            </xsl:when>
            <xsl:otherwise>
          <xsl:apply-templates select="root/document_type/description"/>
            </xsl:otherwise>
        </xsl:choose>


           <datacite:relatedIdentifiers>
        <xsl:if test="//references[
        (doi[normalize-space() and
        . != 'None' and . != 'none' and
        not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))])
        or
        (zbmath/document_id[normalize-space() and
        . != 'None' and . != 'none' and
        not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))])
        ]">

            <xsl:apply-templates select="//references"/>

        </xsl:if>

        <xsl:apply-templates select="root/source" mode="relatedIdentifiers"/>
    </datacite:relatedIdentifiers>
           
              <xsl:if test="root/source[node()]">
                <xsl:apply-templates select="root/source" mode="citation"/>
              </xsl:if>

    </resource>
    </xsl:template>

    <xsl:template match="zbmath_url">
        <datacite:identifier identifierType="URL">
            <xsl:value-of select="."/>
        </datacite:identifier>
    </xsl:template>

     <xsl:template match="root/links">
         <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
    <xsl:choose>
        <!-- Process the first 'links' node that has a 'doi' identifier -->
        <xsl:when test="self::links[type = 'doi' and normalize-space(identifier) != ''][1]">
            <datacite:alternateIdentifier alternateIdentifierType="DOI">
                <xsl:value-of select="identifier"/>
            </datacite:alternateIdentifier>
        </xsl:when>
        <!-- If no 'doi' identifier is present, consider 'arxiv' -->
        <xsl:when test="self::links[type = 'arxiv' and normalize-space(identifier) != ''][1] and not(preceding-sibling::links[type = 'doi' and normalize-space(identifier) != ''])">
            <datacite:alternateIdentifier alternateIdentifierType="arXiv">
                <xsl:value-of select="identifier"/>
            </datacite:alternateIdentifier>
        </xsl:when>
    </xsl:choose>
         </xsl:if>
</xsl:template>

     <xsl:template match="authors">
        <datacite:creator>
            <datacite:creatorName nameType="Personal">
                <xsl:value-of select="name"/>
            </datacite:creatorName>
            <datacite:givenName>
                 <xsl:choose>
                <xsl:when test="contains(name, 'zbMATH Open Web Interface contents unavailable due to conflicting licenses.')">
                    zbMATH Open Web Interface contents unavailable due to conflicting licenses.
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(name, ',')"/>
                </xsl:otherwise>
            </xsl:choose>
            </datacite:givenName>
            <datacite:familyName>
                 <xsl:choose>
                <xsl:when test="contains(name, 'zbMATH Open Web Interface contents unavailable due to conflicting licenses.')">
                    zbMATH Open Web Interface contents unavailable due to conflicting licenses.
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(name, ', ')"/>
                </xsl:otherwise>
            </xsl:choose>
            </datacite:familyName>
            <datacite:nameIdentifier schemeURI="https://zbmath.org/" nameIdentifierScheme="zbMATH Author Code">
                <xsl:value-of select="codes"/>
            </datacite:nameIdentifier>
        </datacite:creator>
    </xsl:template>

           <xsl:template match="title">
            <datacite:title titleType="Subtitle" xml:lang="en">
                <xsl:value-of select="title"/>
            </datacite:title>
           </xsl:template>

     <xsl:template match="text">
            <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
        <dc:description  descriptionType="Abstract">

         <xsl:value-of select="normalize-space(.)"/>

        </dc:description>
            </xsl:if>
        </xsl:template>

   <xsl:template match="msc">
       <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
    <datacite:subject>
        <xsl:attribute name="subjectScheme">
            <xsl:value-of select="scheme"/>
        </xsl:attribute>
        <xsl:attribute name="classificationCode">
            <xsl:value-of select="code"/>
        </xsl:attribute>
        <xsl:value-of select="text"/>
    </datacite:subject>
       </xsl:if>
</xsl:template>

       <xsl:template match="keywords">
            <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
        <datacite:subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </datacite:subject>
            </xsl:if>
        </xsl:template>


          <xsl:template match="year">
    <xsl:variable name="seriesYear" select="../../source/series/year"/>
    <xsl:choose>

        <xsl:when test="normalize-space(.) != ''
                        and . != 'None'
                        and . != 'none'
                        and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
            <datacite:date dateType="Issued">
                <xsl:value-of select="."/>
            </datacite:date>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="normalize-space($seriesYear) != ''
                          and $seriesYear != 'None'
                          and $seriesYear != 'none'
                          and not(contains($seriesYear, 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
                <datacite:date dateType="Issued">
                    <xsl:value-of select="$seriesYear"/>
                </datacite:date>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


            <xsl:template match="publisher">
                 <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
            <dc:publisher>
            <xsl:value-of select="."/>
            </dc:publisher>
                 </xsl:if>
            </xsl:template>

 <xsl:template match="description">
    <xsl:variable name="docTypeDesc" select="normalize-space(../document_type/description)"/>

    <oaire:resourceType>
        <xsl:choose>
            <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'article')">
                <xsl:attribute name="resourceTypeGeneral">literature</xsl:attribute>
                <xsl:attribute name="uri">http://purl.org/coar/resource_type/c_6501</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'book')">
                <xsl:attribute name="resourceTypeGeneral">literature</xsl:attribute>
                <xsl:attribute name="uri">http://purl.org/coar/resource_type/c_2f33</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="normalize-space(.) != ''">
                <xsl:attribute name="resourceTypeGeneral">literature</xsl:attribute>
                <xsl:attribute name="uri">http://purl.org/coar/resource_type/c_1843</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="resourceTypeGeneral">literature</xsl:attribute>
                <xsl:attribute name="uri">http://purl.org/coar/resource_type/c_1843</xsl:attribute>
                <xsl:text>other</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </oaire:resourceType>
</xsl:template>


    <xsl:template match="references">
       <xsl:choose>
        <xsl:when test="normalize-space(doi) != ''
                        and doi != 'None'
                        and doi != 'none'
                        and not(contains(doi, 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
            <datacite:relatedIdentifier relatedIdentifierType="DOI" relationType="Cites" resourceTypeGeneral="Other">
                <xsl:value-of select="normalize-space(doi)"/>
            </datacite:relatedIdentifier>
        </xsl:when>
        <xsl:when test="zbmath/document_id[normalize-space()
                        and . != 'None'
                        and . != 'none'
                        and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]">
            <datacite:relatedIdentifier relatedIdentifierType="URL" relationType="IsCitedBy">
                <xsl:value-of select="concat('https://zbmath.org/', zbmath/document_id)"/>
            </datacite:relatedIdentifier>
        </xsl:when>
       </xsl:choose>
     </xsl:template>

     <xsl:template match="root/source" mode="relatedIdentifiers">
    <xsl:if test="normalize-space(descendant::issn[type='print']/number) != '' and descendant::issn[type='print']/number != 'None' and descendant::issn[type='print']/number != 'none'">
        <datacite:relatedIdentifier relatedIdentifierType="ISSN" relationType="Cites">
            <xsl:value-of select="descendant::issn[type='print']/number"/>
        </datacite:relatedIdentifier>
    </xsl:if>
    </xsl:template>


<xsl:template match="root/source" mode="citation">
    <xsl:if test="normalize-space(source) != '' and . != 'None' and . != 'none'">
        <dc:source>
            <xsl:value-of select="source"/>
        </dc:source>
    </xsl:if>

    <xsl:if test="normalize-space(series/title) != '' and series/title != 'None' and series/title != 'none'">
        <oaire:citationTitle>
            <xsl:value-of select="series/title"/>
        </oaire:citationTitle>
    </xsl:if>

    <xsl:if test="normalize-space(series/volume) != '' and series/volume != 'None' and series/volume != 'none'">
        <oaire:citationVolume>
            <xsl:value-of select="series/volume"/>
        </oaire:citationVolume>
    </xsl:if>

    <xsl:if test="normalize-space(series/issue) != '' and series/issue != 'None' and series/issue != 'none'">
        <oaire:citationIssue>
            <xsl:value-of select="series/issue"/>
        </oaire:citationIssue>
    </xsl:if>

    <xsl:variable name="pagesText" select="normalize-space(pages)"/>
    <xsl:variable name="firstPage" select="substring-before($pagesText, '-')"/>
    <xsl:variable name="lastPage" select="substring-after($pagesText, '-')"/>

    <xsl:if test="normalize-space($firstPage) != '' and $firstPage != 'None' and $firstPage != 'none'">
        <oaire:citationStartPage>
            <xsl:value-of select="$firstPage"/>
        </oaire:citationStartPage>
    </xsl:if>

    <xsl:if test="normalize-space($lastPage) != '' and $lastPage != 'None' and $lastPage != 'none'">
        <oaire:citationEndPage>
            <xsl:value-of select="$lastPage"/>
        </oaire:citationEndPage>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>
