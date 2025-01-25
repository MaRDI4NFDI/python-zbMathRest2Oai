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

            <publicationYear>
               <xsl:choose>
        <xsl:when test="root/standard_articles/year[normalize-space(.) != '' and . != 'None']">
            <xsl:value-of select="root/standard_articles/year[not(. > ../../standard_articles/year)]"/>
        </xsl:when>
        <xsl:when test="root/references_year_alt[1] and not(starts-with(root/references_year_alt[1], '0'))">
            <xsl:apply-templates select="root/references_year_alt[1]"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="root/source_year"/>
        </xsl:otherwise>
    </xsl:choose>
            </publicationYear>
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
              <xsl:choose>
              <xsl:when test="root/source_code[normalize-space(.) != '' and . != 'none' and . != 'null']">
              <xsl:value-of select="root/source_code"/>
              </xsl:when>
             <xsl:otherwise>
              <xsl:value-of select="root/homepage"/>
             </xsl:otherwise>
             </xsl:choose>
            </publisher>

                  <xsl:apply-templates select="root/license_terms"/>

                   <relatedIdentifiers>
                    <xsl:apply-templates select="root/homepage"/>
                     <xsl:apply-templates select="root/references"/>
                       <xsl:apply-templates select="root/references_alt"/>
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
         <xsl:value-of select="."/>
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

    <!-- Template to get the source code -->
<xsl:template name="sourceCode">
    <xsl:variable name="sourceCode" select="normalize-space(root/source_code)"/>
    <xsl:if test="$sourceCode != '' and $sourceCode != 'none' and $sourceCode != 'null'">
        <xsl:value-of select="$sourceCode"/>
    </xsl:if>
</xsl:template>

<!-- Template to get the homepage -->
<xsl:template name="homepage">
    <xsl:value-of select="root/homepage"/>
</xsl:template>



     <xsl:template match="references">
  <relatedIdentifier relatedIdentifierType="URL" relationType="IsCitedBy">
            <xsl:text>https://api.zbmath.org/v1/document/</xsl:text>
            <xsl:value-of select="."/>
        </relatedIdentifier>
    </xsl:template>

<xsl:template match="references_alt">
    <xsl:variable name="reference" select="."/>
    <xsl:call-template name="process-reference">
        <xsl:with-param name="text" select="$reference"/>
    </xsl:call-template>
</xsl:template>

<xsl:template name="process-reference">
    <xsl:param name="text"/>
    <xsl:choose>
        <!-- Check if there's a semicolon (;) in the text -->
        <xsl:when test="contains($text, ';')">
            <xsl:variable name="current" select="substring-before($text, ';')"/>
            <xsl:variable name="remaining" select="substring-after($text, ';')"/>

            <!-- Handle DOI -->
            <xsl:if test="starts-with($current, '10.')">
                <relatedIdentifier relatedIdentifierType="DOI" relationType="IsCitedBy">
                    <xsl:value-of select="$current"/>
                </relatedIdentifier>
            </xsl:if>

            <!-- Handle arXiv ID -->
            <xsl:if test="$current and string-length($current) > 6 and substring($current, 5, 1) = '.'">


                <relatedIdentifier relatedIdentifierType="ARXIV" relationType="IsCitedBy">
                    <xsl:value-of select="$current"/>
                </relatedIdentifier>
            </xsl:if>


            <!-- Recursively process the remaining part -->
            <xsl:call-template name="process-reference">
                <xsl:with-param name="text" select="$remaining"/>
            </xsl:call-template>
        </xsl:when>

        <!-- Handle the last part (no more semicolons) -->
        <xsl:otherwise>
            <!-- Handle DOI -->
            <xsl:if test="starts-with($text, '10.')">
                <relatedIdentifier relatedIdentifierType="DOI" relationType="IsCitedBy">
                    <xsl:value-of select="$text"/>
                </relatedIdentifier>
            </xsl:if>

            <!-- Handle arXiv ID -->
            <xsl:if test="$text and string-length($text) > 6 and substring($text, 5, 1) = '.'">


                <relatedIdentifier relatedIdentifierType="arXiv" relationType="IsCitedBy">
                    <xsl:value-of select="$text"/>
                </relatedIdentifier>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>



</xsl:stylesheet>
