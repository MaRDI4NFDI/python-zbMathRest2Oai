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

              <datacite:creators>
                <xsl:apply-templates select="root/authors"/>
              </datacite:creators>

                 <datacite:titles>
                <xsl:apply-templates select="root/name"/>
                 </datacite:titles>
                <xsl:apply-templates select="root/description"/>

              <xsl:if test="root/classification[normalize-space(.) != '' and . != 'None'] or root/keywords[normalize-space(.) != '' and . != 'None']">
        <datacite:subjects>
            <xsl:apply-templates select="root/classification"/>
            <xsl:apply-templates select="root/keywords"/>
        </datacite:subjects>
           </xsl:if>

            <xsl:if test="root/standard_articles/id[normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))] or root/references[normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]">
               <datacite:relatedIdentifiers>
                <xsl:apply-templates select="root/standard_articles/id[normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]"/>
                <xsl:apply-templates select="root/references[normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))]"/>
               </datacite:relatedIdentifiers>
            </xsl:if>

         <xsl:if test="normalize-space(root/homepage) != '' and root/homepage != 'None' and root/homepage != 'none'">
    <datacite:alternateIdentifiers>
        <datacite:alternateIdentifier alternateIdentifierType="URL">
            <xsl:value-of select="root/homepage"/>
        </datacite:alternateIdentifier>
    </datacite:alternateIdentifiers>
       </xsl:if>


             <xsl:apply-templates select="root/license_terms"/>

            <oaire:resourceType resourceTypeGeneral="software" uri="http://purl.org/coar/resource_type/c_5ce6"/>
             <datacite:rightsList>
                   <datacite:rights rightsURI="http://purl.org/coar/access_right/c_14cb">metadata only access</datacite:rights>
                <datacite:rights xml:lang="en"
                        schemeURI="https://api.zbmath.org/v1/"
                        rightsIdentifierScheme="zbMATH"
                        rightsIdentifier="CC-BY-SA 4.0"
                        rightsURI="https://creativecommons.org/licenses/by-sa/4.0/">
                    The zbMATH Open OAI-PMH API is subject to the Terms and Conditions for the zbMATH Open API Service of FIZ Karlsruhe – Leibniz-Institut für Informationsinfrastruktur GmbH.
Content generated by zbMATH Open, such as reviews, classifications, software, or author disambiguation data, are distributed under CC-BY-SA 4.0. This defines the license for the whole dataset, which also contains non-copyrighted bibliographic metadata and reference data derived from I4OC (CC0). Note that the API only provides a subset of the data in the zbMATH Open Web interface. In several cases, third-party information, such as abstracts, cannot be made available under a suitable license through the API. In those cases, we replaced the data with the string
"zbMATH Open Web Interface contents unavailable due to conflicting licenses."</datacite:rights>
            </datacite:rightsList>
   <dc:format>application/xml</dc:format>
           <dc:language>eng</dc:language>
           <xsl:apply-templates select="root/standard_articles/source"/>
           <xsl:apply-templates select="root/standard_articles/title"/>
           <datacite:date dateType="Issued">
    <xsl:choose>
        <xsl:when test="normalize-space(root/standard_articles/year) != ''
                        and root/standard_articles/year != 'None'
                        and root/standard_articles/year != 'none'
                        and not(starts-with(root/standard_articles/year, '0'))
                        and not(contains(root/standard_articles/year, 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
            <xsl:value-of select="root/standard_articles/year[not(. > ../../standard_articles/year)]"/>
        </xsl:when>
        <xsl:when test="normalize-space(root/references_year_alt[1]) != ''
                        and root/references_year_alt[1] != 'None'
                        and root/references_year_alt[1] != 'none'
                        and not(starts-with(root/references_year_alt[1], '0'))
                        and not(contains(root/references_year_alt[1], 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
            <xsl:apply-templates select="root/references_year_alt[1]"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="root/source_year"/>
        </xsl:otherwise>
    </xsl:choose>
</datacite:date>

  </resource>

    </xsl:template>

 <xsl:template match="zbmath_url">
        <datacite:identifier identifierType="URL">
            <xsl:value-of select="concat('https://swmath.org/software/', substring-after(., 'https://zbmath.org/software/'))"/>
        </datacite:identifier>
    </xsl:template>

   <xsl:template match="authors">
        <datacite:creator>
            <datacite:creatorName nameType="Personal">
                <xsl:value-of select="."/>
            </datacite:creatorName>
            <datacite:givenName>
            <xsl:choose>
                <xsl:when test="contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., ', ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </datacite:givenName>
        <datacite:familyName>
            <xsl:choose>
                <xsl:when test="contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(., ', ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </datacite:familyName>
        </datacite:creator>
    </xsl:template>



 <xsl:template match="name">
    <datacite:title>
    <xsl:value-of select="."/>
    </datacite:title>
    </xsl:template>

    <xsl:template match="license_terms">
        <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
<oaire:licenseCondition>
    <xsl:value-of select="."/>
</oaire:licenseCondition>
        </xsl:if>
    </xsl:template>

     <xsl:template match="description">
        <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
        <dc:description xml:lang="en" descriptionType="Abstract">
         <xsl:value-of select="."/>
        </dc:description>
        </xsl:if>
        </xsl:template>

      <xsl:template match="classification">
          <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
        <datacite:subject subjectScheme="msc2020" >
            <xsl:value-of select="."/>
        </datacite:subject>
          </xsl:if>
        </xsl:template>

        <xsl:template match="keywords">
            <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
            <!-- Transformation of  keywords -->
        <datacite:subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </datacite:subject>
            </xsl:if>
        </xsl:template>



 <xsl:template match="source">
     <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
    <dc:source>
    <xsl:value-of select="."/>
    </dc:source>
     </xsl:if>
    </xsl:template>

     <xsl:template match="title">
          <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none'">
    <oaire:citationTitle>
    <xsl:value-of select="."/>
    </oaire:citationTitle>
          </xsl:if>
    </xsl:template>

  <xsl:template match="standard_articles/id">
    <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
        <datacite:relatedIdentifier relatedIdentifierType="URL" relationType="IsReferencedBy">
            <xsl:value-of select="concat('https://zbmath.org/', normalize-space(.))"/>
        </datacite:relatedIdentifier>
    </xsl:if>
</xsl:template>

<xsl:template match="references">
    <xsl:if test="normalize-space(.) != '' and . != 'None' and . != 'none' and not(contains(., 'zbMATH Open Web Interface contents unavailable due to conflicting licenses'))">
        <datacite:relatedIdentifier relatedIdentifierType="URL" relationType="IsSupplementedBy">
            <xsl:value-of select="concat('https://api.zbmath.org/v1/document/', normalize-space(.))"/>
        </datacite:relatedIdentifier>
    </xsl:if>
</xsl:template>

     <xsl:template match="year">
          <xsl:if test="normalize-space(.) != '' and . != 'None'">
          <xsl:value-of select="."/>
         </xsl:if>
    </xsl:template>

   <xsl:template match="root/references_year_alt">
    <xsl:if test="position() = 1">
        <xsl:value-of select="//references_year_alt[not(. > //references_year_alt)]" />
    </xsl:if>
</xsl:template>

     <xsl:template match="source_year">
          <xsl:if test="normalize-space(.) != '' and . != 'None'">
          <xsl:value-of select="."/>
         </xsl:if>
    </xsl:template>


</xsl:stylesheet>

