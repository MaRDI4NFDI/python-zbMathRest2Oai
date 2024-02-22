<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oai_zbmath_preview="https://zbmath.org/OAI/2.0/oai_zbmath_preview/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/"
                exclude-result-prefixes="xsi oai_zb_preview">


<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
  <oai_zbmath_preview>
    <zbmath:author>
      <xsl:value-of select="root/result/contributors/authors/name"/>
    </zbmath:author>
    <zbmath:author_ids>
      <zbmath:author_id>
        <xsl:value-of select="root/result/contributors/authors/codes"/>
      </zbmath:author_id>
    </zbmath:author_ids>
    <zbmath:classifications>
       <xsl:for-each select="root/result/msc/code">
        <zbmath:classification><xsl:value-of select="."/></zbmath:classification>
      </xsl:for-each>
      </zbmath:classifications>
    <zbmath:document_id>
      <xsl:value-of select="root/result/id"/>
    </zbmath:document_id>
    <zbmath:document_title>
      <xsl:value-of select="root/result/title/title"/>
    </zbmath:document_title>
    <zbmath:document_type>
      <xsl:value-of select="root/result/document_type"/>
    </zbmath:document_type>
    <zbmath:doi>
      <xsl:value-of select="root/result/links[./type='doi']/identifier"/>
    </zbmath:doi>
    <zbmath:keywords>
      <xsl:for-each select="root/result/keywords">
        <zbmath:keyword>
          <xsl:value-of select="."/>
        </zbmath:keyword>
      </xsl:for-each>
    </zbmath:keywords>
    <zbmath:language>
      <xsl:value-of select="root/result/language/languages"/>
    </zbmath:language>
 <xsl:for-each select = "root/result/source">
    <zbmath:pagination>
      <xsl:value-of select="pages"/>
    </zbmath:pagination>
    <zbmath:publication_year>
      <xsl:value-of select="series/year"/>
    </zbmath:publication_year>
    <zbmath:source>
      <xsl:value-of select="source"/>
    </zbmath:source>
  </xsl:for-each>
    <zbmath:spelling>
   <xsl:value-of select="root/result/contributors/authors/name"/>
    </zbmath:spelling>
    <zbmath:zbmathl_id>
      <xsl:value-of select="root/result/identifier"/>
    </zbmath:zbmathl_id>
    <zbmath:review>
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
            <xsl:value-of select="root/result/editorial_contributions/reviewer/reviewer_id"/>
          </zbmath:reviewer>
        <zbmath:reviewer_id>
      <xsl:value-of  select="root/result/editorial_contributions/reviewer/author_code"/>
        </zbmath:reviewer_id>
    </zbmath:review>
    <zbmath:serial>
     <zbmath:serial_publisher>
<xsl:value-of select="root/result/source/series/publisher"/>
</zbmath:serial_publisher>
    <zbmath:serial_title>
<xsl:value-of select="root/result/source/series/title"/>
 </zbmath:serial_title>
    </zbmath:serial>
 <zbmath:links>
                <xsl:for-each select="root/result/links">
                    <zbmath:link>
                        <xsl:choose>
                            <xsl:when test="type = 'doi'">
                                <xsl:value-of select="concat('https://doi.org/', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'arxiv'">
                                <xsl:value-of select="concat('https://arxiv.org/abs/', identifier)"/>
                            </xsl:when>
                             <xsl:when test="type = 'euclid'">
                                <xsl:value-of select="concat('https://projecteuclid.org/euclid.', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'crelle'">
                                <xsl:value-of select="concat('https://www.digizeitschriften.de/dms/resolveppn/?PPN=', identifier)"/>
                            </xsl:when>
                                <xsl:when test="type = 'emis'">
                                    <xsl:value-of select="concat('http://www.emis.de/', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'eudml'">
                                <xsl:value-of select="concat('https://eudml.org/doc/', identifier)"/>
                            </xsl:when>
                             <xsl:when test="type = 'vixra'">
                                <xsl:value-of select="concat('http://www.vixra.org/abs/', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'numdam'">
                                <xsl:value-of select="concat('http://www.numdam.org/item?id=', identifier)"/>
                            </xsl:when>
                             <xsl:when test="type = 'gallica'">
                                <xsl:value-of select="concat('http://gallica.bnf.fr/ark:/', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'lni'">
                                <xsl:value-of select="concat('http://subs.emis.de/', identifier)"/>
                            </xsl:when>
                            <xsl:when test="type = 'mathnetru'">
                                <xsl:value-of select="concat('http://mathnet.ru/', identifier)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="identifier"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </zbmath:link>
                </xsl:for-each>
            </zbmath:links>
  <zbmath:references>
      <xsl:for-each select="root/result/references">
        <zbmath:reference>
          <zbmath:text>
            <xsl:value-of select="text"/>
          </zbmath:text>
          <zbmath:ref_id>
            <xsl:value-of select="zbmath/document_id"/>
          </zbmath:ref_id>
          <zbmath:ref_classifications>
            <xsl:for-each select="zbmath/msc">
              <zbmath:ref_classification>
                <xsl:value-of select="."/>
              </zbmath:ref_classification>
            </xsl:for-each>
          </zbmath:ref_classifications>
        </zbmath:reference>
      </xsl:for-each>
    </zbmath:references>
  </oai_zbmath_preview>
</xsl:template>
</xsl:stylesheet>