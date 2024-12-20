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
                <formats>
                <format>application/xml</format>
                </formats>
             <publisher>
                 <xsl:call-template name="sourceCodeOrHomepage"/>
             </publisher>
                  <xsl:apply-templates select="root/license_terms"/>
                   <relatedIdentifiers>
                 <xsl:apply-templates select="root/homepage"/>
                <xsl:apply-templates select="root/references"/>
             </relatedIdentifiers>

             </resource>
             </xsl:template>
      <xsl:template match="id">
        <identifier identifierType="swMATH">
        <xsl:value-of select="."/>
         </identifier>
       </xsl:template>
       <xsl:template match="zbmath_url">
    <alternateIdentifier alternateIdentifierType="URL">
        <xsl:value-of select="concat('https://swmath.org', substring-after(., 'zbmath.org'))"/>
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
    <xsl:template match="license_terms">
    <xsl:if test=". != ''">
        <rights>
            <xsl:value-of select="."/>
        </rights>
    </xsl:if>
</xsl:template>
     <xsl:template match="homepage">
        <relatedIdentifier  relatedIdentifierType="URL" relationType="IsSourceOf">
            <xsl:value-of select="."/>
        </relatedIdentifier>
        </xsl:template>

     <xsl:template name="sourceCodeOrHomepage">
    <xsl:variable name="sourceCode" select="normalize-space(root/source_code)"/>
    <xsl:choose>
      <xsl:when test="$sourceCode != '' and $sourceCode != 'none' and $sourceCode != 'null'">
        <xsl:value-of select="$sourceCode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="root/homepage"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


     <xsl:template match="references">
  <relatedIdentifier relatedIdentifierType="URL" relationType="IsCitedBy">
            <xsl:text>https://api.zbmath.org/v1/document/</xsl:text>
            <xsl:value-of select="."/>
        </relatedIdentifier>
    </xsl:template>
</xsl:stylesheet>
