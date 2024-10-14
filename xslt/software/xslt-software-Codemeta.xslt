<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
                xmlns:swhdeposit="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:schema="https://schema.org/">
    <xsl:output method="xml" indent="yes"/>
     <xsl:template match="/">
        <entry>

 <xsl:apply-templates select="root/id"/>

<xsl:apply-templates select="root/swhdeposit:deposit"/>

 <codemeta:author>
<xsl:apply-templates select="root/authors"/>
</codemeta:author>
<xsl:apply-templates select="root/name"/>

<xsl:apply-templates select="root/description"/>

<xsl:apply-templates select="root/homepage"/>

<xsl:apply-templates select="root/source_code"/>

<xsl:apply-templates select="root/keywords"/>

 <xsl:apply-templates select="root/operating_systems"/>

 <xsl:apply-templates select="root/orms_id"/>

<xsl:apply-templates select="root/programming_languages"/>

<xsl:apply-templates select="root/classification"/>

<xsl:apply-templates select="root/articles_count"/>

<codemeta:supportingData>
<xsl:apply-templates select="root/related_software"/>
</codemeta:supportingData>

<codemeta:citation>
<xsl:apply-templates select="root/standard_articles"/>
</codemeta:citation>

<xsl:apply-templates select="root/zbmath_url"/>

  </entry>
</xsl:template>





 <xsl:template match="id">
        <codemeta:identifier>
            <xsl:text>zbmath-</xsl:text>
            <xsl:value-of select="."/>
        </codemeta:identifier>
    </xsl:template>


     <xsl:template match="swhdeposit:deposit">
        <swhdeposit:deposit>
            <xsl:apply-templates select="swhdeposit:reference"/>
            <xsl:apply-templates select="swhdeposit:metadata-provenance"/>
        </swhdeposit:deposit>
    </xsl:template>

    <!-- Template for swhdeposit:reference -->
    <xsl:template match="swhdeposit:reference">
        <swhdeposit:reference>
            <xsl:apply-templates select="swhdeposit:object"/>
        </swhdeposit:reference>
    </xsl:template>

    <!-- Template for swhdeposit:object -->
    <xsl:template match="swhdeposit:object">
        <swhdeposit:object swhid="{@swhid}"/>
    </xsl:template>

    <!-- Template for swhdeposit:metadata-provenance -->
    <xsl:template match="swhdeposit:metadata-provenance">
        <swhdeposit:metadata-provenance>
            <xsl:apply-templates select="schema:url"/>
        </swhdeposit:metadata-provenance>
    </xsl:template>

    <!-- Template for schema:url -->
    <xsl:template match="schema:url">
        <schema:url>
            <xsl:value-of select="."/>
        </schema:url>
    </xsl:template>




    <xsl:template match="authors">
        <codemeta:author>

            <codemeta:familyName>
                <xsl:value-of select="substring-before(., ',')"/>
            </codemeta:familyName>

            <codemeta:givenName>
                <xsl:value-of select="normalize-space(substring-after(., ','))"/>
            </codemeta:givenName>
        </codemeta:author>
    </xsl:template>

     <xsl:template match="description">
        <codemeta:description>
            <xsl:value-of select="."/>
        </codemeta:description>
    </xsl:template>

     <xsl:template match="homepage">
        <codemeta:sameAs >
            <xsl:value-of select="."/>
        </codemeta:sameAs>
    </xsl:template>

         <xsl:template match="source_code">
        <codemeta:codeRepository>
            <xsl:value-of select="."/>
        </codemeta:codeRepository>
    </xsl:template>

     <xsl:template match="keywords">
        <codemeta:keywords>
            <xsl:value-of select="."/>
        </codemeta:keywords>
    </xsl:template>

      <xsl:template match="name">
        <codemeta:name>
            <xsl:value-of select="."/>
        </codemeta:name>
    </xsl:template>

      <xsl:template match="operating_systems">
        <codemeta:operatingSystem>
            <xsl:value-of select="."/>
        </codemeta:operatingSystem>
    </xsl:template>

     <xsl:template match="orms_id">
        <codemeta:identifier>
            <xsl:value-of select="."/>
        </codemeta:identifier>
    </xsl:template>


  <xsl:template match="programming_languages">
        <codemeta:programmingLanguage>
            <xsl:value-of select="."/>
        </codemeta:programmingLanguage>
    </xsl:template>

  <xsl:template match="classification">
        <codemeta:inCodeSet>
            <xsl:value-of select="."/>
        </codemeta:inCodeSet>
    </xsl:template>

  <xsl:template match="articles_count">
        <codemeta:itemList>
            <xsl:value-of select="."/>
        </codemeta:itemList>
    </xsl:template>


 <xsl:template match="related_software">

            <codemeta:name>
                <xsl:value-of select="name"/>
            </codemeta:name>

               <codemeta:identifier>

                <xsl:value-of select="id"/>
            </codemeta:identifier>

    </xsl:template>


     <xsl:template match="standard_articles">

            <codemeta:author>
                <xsl:value-of select="authors"/>
            </codemeta:author>

               <codemeta:identifier>

                <xsl:value-of select="id"/>
            </codemeta:identifier>

          <codemeta:hasSource>

                <xsl:value-of select="source"/>
            </codemeta:hasSource>

                <codemeta:headline>
                <xsl:value-of select="title"/>
            </codemeta:headline>

            <codemeta:datePublished >

                <xsl:value-of select="year"/>
            </codemeta:datePublished >
    </xsl:template>


      <xsl:template match="zbmath_url">
        <codemeta:url>
            <xsl:value-of select="."/>
        </codemeta:url>
    </xsl:template>

 </xsl:stylesheet>