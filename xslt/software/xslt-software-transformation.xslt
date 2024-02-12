<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oai_zb_preview="https://zbmath.org/OAI/2.0/oai_zb_preview/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/">
<xsl:template match="/">
<oai_zb_preview>
    <zbmath:identifier>
        <xsl:value-of select="root/result/id"/>
    </zbmath:identifier>
</oai_zb_preview>
</xsl:template>
</xsl:stylesheet>
