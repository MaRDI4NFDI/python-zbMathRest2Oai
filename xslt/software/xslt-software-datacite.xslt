<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.1/metadata.xsd"
                xmlns="http://datacite.org/schema/kernel-4">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
         <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
            <!-- Roots of the metadata -->
            <xsl:apply-templates select="root/id"/>

             <alternateIdentifiers>
            <xsl:apply-templates select="root/zbmath_url"/>
            </alternateIdentifiers>
            <creators>
                <xsl:apply-templates select="root/authors"/>
            </creators>
                <titles>
                <xsl:apply-templates select="root/name"/>
                 </titles>
                <descriptions>
                <xsl:apply-templates select="root/description"/>
                    <xsl:apply-templates select="root/operating_systems"/>
                    <xsl:apply-templates select="root/programming_languages"/>
                </descriptions>
      <xsl:apply-templates select="root/standard_articles/year"/>
            <subjects>
                <xsl:apply-templates select="root/classification"/>
                <xsl:apply-templates select="root/keywords"/>
            </subjects>
             <language>English</language>
 <resourceType resourceTypeGeneral="Software"/>
              <rightsList> <!-- this generates the copyrights and legal aspect wihtin the xslt -->
                <rights xml:lang="en"
                        schemeURI="https://api.zbmath.org/v1/"
                        rightsIdentifierScheme="zbMATH"
                        rightsIdentifier="CC-BY-SA 4.0"
                        rightsURI="https://creativecommons.org/licenses/by-sa/4.0/">
                    The zbMATH Open OAI-PMH API is subject to the Terms and Conditions for the zbMATH Open API Service of FIZ Karlsruhe – Leibniz-Institut für Informationsinfrastruktur GmbH.
Content generated by zbMATH Open, such as reviews, classifications, software, or author disambiguation data, are distributed under CC-BY-SA 4.0. This defines the license for the whole dataset, which also contains non-copyrighted bibliographic metadata and reference data derived from I4OC (CC0). Note that the API only provides a subset of the data in the zbMATH Open Web interface. In several cases, third-party information, such as abstracts, cannot be made available under a suitable license through the API. In those cases, we replaced the data with the string
"zbMATH Open Web Interface contents unavailable due to conflicting licenses."</rights>
            </rightsList>
</resource>
</xsl:template>
<xsl:template match="id">
 <identifier identifierType="swMATH">
<xsl:value-of select="."/>
 </identifier>
</xsl:template>
        <xsl:template match="zbmath_url">
        <alternateIdentifier alternateIdentifierType="URL">
            <xsl:value-of select="."/>
        </alternateIdentifier>
        </xsl:template>
 <xsl:template match="authors">
        <creator>
            <creatorName nameType="Personal">
                <xsl:value-of select="."/>
            </creatorName>
            <givenName>
                <xsl:value-of select="substring-after(., ', ')"/>
            </givenName>
            <familyName>
                <xsl:value-of select="substring-before(., ', ')"/>
            </familyName>
        </creator>
    </xsl:template>
  <xsl:template match="name">
    <title>
    <xsl:value-of select="."/>
    </title>
    </xsl:template>
 <xsl:template match="description">
            <!-- Transformation of  description text -->
        <description xml:lang="en" descriptionType="Abstract">
         <xsl:value-of select="."/>
        </description>
        </xsl:template>
      <xsl:template match="operating_systems">
    <xsl:if test=". != ''">
        <description xml:lang="en" descriptionType="TechnicalInfo">
            <xsl:text>operating systems: </xsl:text>
            <xsl:value-of select="."/>
        </description>
    </xsl:if>
</xsl:template>

<xsl:template match="programming_languages">
    <xsl:if test=". != ''">
        <description xml:lang="en" descriptionType="TechnicalInfo">
        <xsl:text>programming languages : </xsl:text>
            <xsl:value-of select="."/>
        </description>
    </xsl:if>
</xsl:template>
  <xsl:template match="year">
            <!-- Transformation of publicationYear -->
        <publicationYear>
         <xsl:value-of select="."/>
        </publicationYear>
        </xsl:template>

        <xsl:template match="classification">
        <subject subjectScheme="msc2020" >
            <xsl:value-of select="."/>
        </subject>
        </xsl:template>
        <xsl:template match="keywords">
            <!-- Transformation of  keywords -->
        <subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </subject>
        </xsl:template>
</xsl:stylesheet>
