<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>


    <xsl:template match="/">

        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="http://www.w3.org/1999/02/22-rdf-syntax-ns# ">

            <!-- Describe the resource in RDF with rdf:Description -->
            <rdf:Description rdf:about="http://dublincore.org/sitemap/">

                <!-- Apply templates to transform title and datestamp -->
                <xsl:apply-templates select="root/title"/>
                <xsl:apply-templates select="root/contributors/authors"/>
                <xsl:apply-templates select="root/editorial_contributions/text"/>
                <xsl:apply-templates select="root/source/series/publisher"/>
                <xsl:apply-templates select="root/datestamp"/>
                <xsl:apply-templates select="root/language/languages"/>

                <!-- Example of a static format element -->
                <dc:format>XML</dc:format>

            </rdf:Description>

        </rdf:RDF>
    </xsl:template>

    <xsl:template match="title">
        <dc:title>
            <xsl:value-of select="."/>
        </dc:title>
    </xsl:template>

    <xsl:template match="authors">
    <dc:creator>
        <!-- Output the family name, then a comma and a space, followed by the given name -->
        <xsl:value-of select="concat(substring-after(name, ', '), ', ', substring-before(name, ','))"/>
    </dc:creator>
</xsl:template>


     <xsl:template match="text">
            <!-- Transformation of  description text -->
        <dc:description>
         <xsl:value-of select="normalize-space(.)"/>
        </dc:description>
        </xsl:template>

     <xsl:template match="publisher">
            <dc:publisher>
            <xsl:value-of select="."/>
            </dc:publisher>
            </xsl:template>

    <xsl:template match="datestamp">
        <dc:date>
            <xsl:value-of select="substring-before(. , 'T')" />
        </dc:date>
    </xsl:template>

    <xsl:template match="languages">
            <dc:language>
             <xsl:value-of select="substring-before(. , 'g')" />
            </dc:language>
            </xsl:template>

</xsl:stylesheet>
