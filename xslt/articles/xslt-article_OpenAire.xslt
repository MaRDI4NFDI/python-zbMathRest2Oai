<!-- XSLT code to transform the zbmath metadata acoording the metadata Scheme of Datacite
Made by Shiraz Malla Mohamad member of zbmath Team-->
<xsl:stylesheet version="1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns="http://datacite.org/schema/kernel-4"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xsi:schemaLocation="http://datacite.org/schema/kernel-4
                https://schema.datacite.org/meta/kernel-4.1/metadata.xsd"
                exclude-result-prefixes="#default">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
            <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
            <!-- Roots of the metadata -->

            <xsl:apply-templates select="root/zbmath_url"/>


                </resource>
        </xsl:template>
        <!-- the URL is the main Identifier for OpenAire-->
        <xsl:template match="zbmath_url">
        <Identifier IdentifierType="URL">
            <xsl:value-of select="."/>
        </Identifier>
       </xsl:template>

    </xsl:stylesheet>

