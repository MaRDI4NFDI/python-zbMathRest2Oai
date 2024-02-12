<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oai_zb_preview="https://zbmath.org/OAI/2.0/oai_zb_preview/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/">
<xsl:template match="/">
<oai_zb_preview>
      <xsl:for-each select="root/result/contributors/authors/name">
        <author><xsl:value-of select="."/></author>
      </xsl:for-each>
      <author_ids>
      <xsl:for-each select="root/result/contributors/authors/codes">
        <author_id><xsl:value-of select="."/></author_id>
      </xsl:for-each>
      </author_ids>
     <classifications>
       <xsl:for-each select="root/result/msc/code">
        <classification><xsl:value-of select="."/></classification>
      </xsl:for-each>
      </classifications>
    <zbmath:review_language>
<xsl:value-of select="root/result/editorial_contributions/language/languages"/>
</zbmath:review_language>
    <zbmath:pagination>
<xsl:value-of select="root/result/pages"/>
</zbmath:pagination>
<zbmath:publication_year>
<xsl:value-of select="root/result/year"/>
</zbmath:publication_year>
<zbmath:source>
<xsl:value-of select="root/result/source"/>
</zbmath:source>
<zbmath:spelling>
<xsl:value-of select="root/result/name"/>
</zbmath:spelling>
        <zbmath:zbl_id>
<xsl:value-of select="root/result/identifier"/>
</zbmath:zbl_id>
      <zbmath:review_sign>
            <xsl:value-of select="root/result/editorial_contributions/reviewer/sign"/>
          </zbmath:review_sign>
         <zbmath:review_text>
          <xsl:value-of select="root/result/editorial_contributions/text"/>
         </zbmath:review_text>
        <zbmath:review_type>
          <xsl:value-of select="root/result/editorial_contributions/contribution_type"/>
        </zbmath:review_type>
        <zbmath:reviewer>
        <zbmath:reviewer>
            <xsl:value-of select="root/result/editorial_contributions/reviewer/reviewer_id"/>
          </zbmath:reviewer>
     <zbmath:reviewer_id>
 <xsl:value-of  select="root/result/editorial_contributions/reviewer/author_code"/>
 </zbmath:reviewer_id>
        </zbmath:reviewer>
   <zbmath:keywords>
          <xsl:for-each select="root/result/keywords">
            <zbmath:keyword>
              <xsl:value-of select="."/>
            </zbmath:keyword>
          </xsl:for-each>
        </zbmath:keywords>
     <zbmath:serial_publisher>
<xsl:value-of select="root/result/publisher"/>
</zbmath:serial_publisher>
    <zbmath:serial_title>
<xsl:value-of select="root/result/title"/>
 </zbmath:serial_title>
<zbmath:doi>
<xsl:value-of select="root/result/identifier"/>
</zbmath:doi>
<zbmath:reference>
 <zbmath:text>
<xsl:value-of select="root/result/text"/>
 </zbmath:text>
<zbmath:ref_id>
<xsl:value-of select="root/result/document_id"/>
</zbmath:ref_id>
<zbmath:ref_classification>
<xsl:value-of select="root/result/msc"/>
</zbmath:ref_classification>
</zbmath:reference>
</oai_zb_preview>
</xsl:template>
</xsl:stylesheet>
