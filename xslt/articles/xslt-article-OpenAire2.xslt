<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version ="1.0"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:datacite="http://datacite.org/schema/kernel-4"
                xmlns="http://namespace.openaire.eu/schema/oaire/"
                xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
       <resource xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd">
        <xsl:apply-templates select="root/zbmath_url"/>

                <datacite:alternateIdentifiers>
                    <xsl:apply-templates select="root/identifier"/>
                <xsl:apply-templates select="root/id"/>
                <xsl:apply-templates select="root/links"/>
                </datacite:alternateIdentifiers>
               <datacite:creators>
                <xsl:apply-templates select="root/contributors/authors"/>
              </datacite:creators>
           <xsl:apply-templates select="root/editorial_contributions/text"/>
              <datacite:rightsList> <!-- this generates the copyrights and legal aspect wihtin the xslt -->
                <datacite:rights xml:lang="en"
                        schemeURI="https://api.zbmath.org/v1/"
                        rightsIdentifierScheme="zbMATH"
                        rightsIdentifier="CC-BY-SA 4.0"
                        rightsURI="https://creativecommons.org/licenses/by-sa/4.0/">
                    The zbMATH Open OAI-PMH API is subject to the Terms and Conditions for the zbMATH Open API Service of FIZ Karlsruhe – Leibniz-Institut für Informationsinfrastruktur GmbH.
Content generated by zbMATH Open, such as reviews, classifications, software, or author disambiguation data, are distributed under CC-BY-SA 4.0. This defines the license for the whole dataset, which also contains non-copyrighted bibliographic metadata and reference data derived from I4OC (CC0). Note that the API only provides a subset of the data in the zbMATH Open Web interface. In several cases, third-party information, such as abstracts, cannot be made available under a suitable license through the API. In those cases, we replaced the data with the string
"zbMATH Open Web Interface contents unavailable due to conflicting licenses."</datacite:rights>
            </datacite:rightsList>
   <dc:format xml:lang="en-EN">XML</dc:format>

                 <datacite:subjects>
                <xsl:apply-templates select="root/msc"/>
                <xsl:apply-templates select="root/keywords"/>
                 </datacite:subjects>

    </resource>
    </xsl:template>

    <xsl:template match="zbmath_url">
        <datacite:identifier IdentifierType="URL">
            <xsl:value-of select="."/>
        </datacite:identifier>
    </xsl:template>

     <xsl:template match="identifier">
        <datacite:alternateIdentifier alternateIdentifierType="zbMATH Identifier">
            <xsl:value-of select="."/>
        </datacite:alternateIdentifier>
        </xsl:template>
    <xsl:template match="id">
    <datacite:alternateIdentifier alternateIdentifierType="zbMATH Document ID">
        <xsl:value-of select="."/>
    </datacite:alternateIdentifier>
    </xsl:template>

     <xsl:template match="root/links">
    <xsl:choose>
        <!-- Process the first 'links' node that has a 'doi' identifier -->
        <xsl:when test="self::links[type = 'doi' and normalize-space(identifier) != ''][1]">
            <datacite:alternateIdentifier alternateIdentifierType="DOI">
                <xsl:value-of select="identifier"/>
            </datacite:alternateIdentifier>
        </xsl:when>
        <!-- If no 'doi' identifier is present, consider 'arxiv' -->
        <xsl:when test="self::links[type = 'arxiv' and normalize-space(identifier) != ''][1] and not(preceding-sibling::links[type = 'doi' and normalize-space(identifier) != ''])">
            <datacite:alternateIdentifier alternateIdentifierType="ARXIV">
                <xsl:value-of select="identifier"/>
            </datacite:alternateIdentifier>
        </xsl:when>
    </xsl:choose>
</xsl:template>

     <xsl:template match="authors">
        <datacite:creator>
            <datacite:creatorName nameType="Personal">
                <xsl:value-of select="name"/>
            </datacite:creatorName>
            <datacite:givenName>
                <xsl:value-of select="substring-before(name, ',')"/>
            </datacite:givenName>
            <datacite:familyName>
                <xsl:value-of select="substring-after(name, ', ')"/>
            </datacite:familyName>
            <datacite:nameIdentifier schemeURI="https://zbmath.org/" nameIdentifierScheme="zbMATH Author Code">
                <xsl:value-of select="codes"/>
            </datacite:nameIdentifier>
        </datacite:creator>
    </xsl:template>

     <xsl:template match="text">
            <!-- Transformation of  description text -->
        <dc:description  descriptionType="Abstract">

         <xsl:value-of select="normalize-space(.)"/>

        </dc:description>
        </xsl:template>
   <xsl:template match="msc">
    <datacite:subject>
        <xsl:attribute name="subjectScheme">
            <xsl:value-of select="scheme"/>
        </xsl:attribute>
        <xsl:attribute name="classificationCode">
            <xsl:value-of select="code"/>
        </xsl:attribute>
        <xsl:value-of select="text"/>
    </datacite:subject>
</xsl:template>
<!-- Template for processing keywords it is also under the subject section with MSC'S
with its own subjectscheme -->

       <xsl:template match="keywords">
            <!-- Transformation of  keywords -->
        <datacite:subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </datacite:subject>
        </xsl:template>
</xsl:stylesheet>
