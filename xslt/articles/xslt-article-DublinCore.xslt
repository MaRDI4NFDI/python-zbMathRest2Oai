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
                <xsl:apply-templates select="root/datestamp"/>

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


    <xsl:template match="datestamp">
        <dc:date>
            <xsl:value-of select="substring-before(. , 'T')" />
        </dc:date>
    </xsl:template>

</xsl:stylesheet>
