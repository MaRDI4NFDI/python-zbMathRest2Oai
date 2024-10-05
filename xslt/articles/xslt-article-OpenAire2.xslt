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

</xsl:stylesheet>
