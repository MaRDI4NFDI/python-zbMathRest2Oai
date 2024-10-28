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

           <datacite:subjects>
                <xsl:apply-templates select="root/classification"/>
                <xsl:apply-templates select="root/keywords"/>
            </datacite:subjects>

             <datacite:relatedIdentifiers>
                 <xsl:apply-templates select="root/homepage"/>

             </datacite:relatedIdentifiers>
            <xsl:apply-templates select="root/license_terms"/>
           <resourceType resourceTypeGeneral="Software"/>
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

               </resource>

    </xsl:template>
      <xsl:template match="zbmath_url">
        <datacite:identifier IdentifierType="URL">
            <xsl:value-of select="."/>
        </datacite:identifier>
    </xsl:template>

   <xsl:template match="authors">
        <datacite:creator>
            <datacite:creatorName nameType="Personal">
                <xsl:value-of select="."/>
            </datacite:creatorName>
            <datacite:givenName>
                <xsl:value-of select="substring-after(., ', ')"/>
            </datacite:givenName>
            <datacite:familyName>
                <xsl:value-of select="substring-before(., ', ')"/>
            </datacite:familyName>
        </datacite:creator>

    </xsl:template>

 <xsl:template match="name">
    <datacite:title>
    <xsl:value-of select="."/>
    </datacite:title>
    </xsl:template>

    <xsl:template match="license_terms">
        <xsl:if test="normalize-space(.) != '' and . != 'None'">
<oaire:licenseCondition>
    <xsl:value-of select="."/>
</oaire:licenseCondition>
        </xsl:if>
    </xsl:template>

    <xsl:template match="description">
        <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <dc:description xml:lang="en" descriptionType="Abstract">
         <xsl:value-of select="."/>
        </dc:description>
        </xsl:if>
        </xsl:template>

      <xsl:template match="classification">
          <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <datacite:subject subjectScheme="msc2020" >
            <xsl:value-of select="."/>
        </datacite:subject>
          </xsl:if>
        </xsl:template>

        <xsl:template match="keywords">
            <xsl:if test="normalize-space(.) != '' and . != 'None'">
            <!-- Transformation of  keywords -->
        <datacite:subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </datacite:subject>
            </xsl:if>
        </xsl:template>


     <xsl:template match="homepage">
         <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <datacite:relatedIdentifier  relatedIdentifierType="URL" relationType="IsSourceOf">
            <xsl:value-of select="."/>
        </datacite:relatedIdentifier>
         </xsl:if>
        </xsl:template>

     <xsl:template match="source">
    <dc:source>
    <xsl:value-of select="."/>
    </dc:source>
    </xsl:template>

     <xsl:template match="title">
    <oaire:citationTitle>
    <xsl:value-of select="."/>
    </oaire:citationTitle>
    </xsl:template>
    </xsl:stylesheet>