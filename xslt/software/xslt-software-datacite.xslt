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
                  <xsl:apply-templates select="root/license_terms"/>
                   <relatedIdentifiers>
                 <xsl:apply-templates select="root/homepage"/>
                <xsl:apply-templates select="root/related_software"/>
             </relatedIdentifiers>
             <relatedItems>
            <xsl:apply-templates select="root/related_software" mode="relatedItems"/>
            </relatedItems>

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

     <xsl:template match="related_software">
  <relatedIdentifier relatedIdentifierType="URL" relationType="IsCitedBy">
            <xsl:text>https://zbmath.org/software/</xsl:text>
            <xsl:value-of select="id"/>
        </relatedIdentifier>
    </xsl:template>


    <xsl:template match="related_software" mode="relatedItems">
        <relatedItem relatedItemType="Software" relationType="IsCitedBy">
            <relatedItemIdentifier relatedItemIdentifierType="URL">
                <xsl:text>https://zbmath.org/software/</xsl:text>
                <xsl:value-of select="id"/>
            </relatedItemIdentifier>
            <titles>
                <title>
                    <xsl:value-of select="name"/>
                </title>
            </titles>
        </relatedItem>
    </xsl:template>
</xsl:stylesheet>
