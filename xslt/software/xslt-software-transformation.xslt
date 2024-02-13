<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datacite="http://datacite.org/schema/kernel-4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/">
<xsl:template match="/">
<resource>
    <identifier>
        <xsl:value-of select="root/result/id"/>
    </identifier>
    <creator>
        <xsl:value-of select="root/result/authors"/>
    </creator>
    <title>
        <xsl:value-of select="root/result/name"/>
    </title>

    <description>
        <xsl:value-of select="root/result/description"/>
    </description>

     <publisher>
        <xsl:value-of select="root/result/homepage"/>
    </publisher>


    <xsl:for-each select="root/result/classification">
        <subject><xsl:value-of select="."/></subject>
      </xsl:for-each>

    <xsl:for-each select="root/result/related_software/id">
        <relatedIdentifier><xsl:value-of select="."/></relatedIdentifier>
      </xsl:for-each>
</resource>
</xsl:template>
</xsl:stylesheet>
