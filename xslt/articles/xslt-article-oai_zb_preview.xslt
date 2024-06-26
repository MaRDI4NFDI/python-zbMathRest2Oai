<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oai_zb_preview="https://zbmath.org/OAI/2.0/oai_zbmath_preview/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/"
                exclude-result-prefixes="xsi oai_zb_preview">


<xsl:output method="xml" indent="yes"/>
<!-- this xslt file is made to map the plain.xml with reference.xml , within XSLT code -->
<xsl:template match="/">
  <oai_zb_preview:zbmath>
    <zbmath:author>
      <xsl:value-of select="root/contributors/authors/name"/>
    </zbmath:author>
    <zbmath:author_ids>
      <zbmath:author_id>
        <xsl:value-of select="root/contributors/authors/codes"/>
      </zbmath:author_id>
    </zbmath:author_ids>
    <zbmath:classifications>
       <xsl:for-each select="root/msc/code">
        <zbmath:classification><xsl:value-of select="."/></zbmath:classification>
      </xsl:for-each>
      </zbmath:classifications>
    <zbmath:document_id>
      <xsl:value-of select="root/id"/>
    </zbmath:document_id>
    <zbmath:document_title>
      <xsl:value-of select="root/title/title"/>
    </zbmath:document_title>
    <zbmath:document_type>
      <xsl:value-of select="root/document_type/code"/>
    </zbmath:document_type>
    <zbmath:doi>
      <xsl:value-of select="root/links[./type='doi']/identifier"/>
    </zbmath:doi>
    <zbmath:keywords>
      <xsl:for-each select="root/keywords">
        <zbmath:keyword>
          <xsl:value-of select="."/>
        </zbmath:keyword>
      </xsl:for-each>
    </zbmath:keywords>
    <zbmath:language>
      <xsl:value-of select="root/language/languages"/>
    </zbmath:language>
 <xsl:for-each select = "root/source">
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
   <xsl:value-of select="root/contributors/authors/name"/>
    </zbmath:spelling>
      <zbmath:time>
   <xsl:value-of select="root/datestamp"/>
    </zbmath:time>
    <zbmath:zbl_id>
      <xsl:value-of select="root/identifier"/>
    </zbmath:zbl_id>
    <zbmath:review>
        <zbmath:review_language>
          <xsl:value-of select="root/editorial_contributions/language"/>
        </zbmath:review_language>
     <zbmath:review_sign>
            <xsl:value-of select="root/editorial_contributions/reviewer/sign"/>
          </zbmath:review_sign>
         <zbmath:review_text>
          <xsl:value-of select="root/editorial_contributions/text"/>
         </zbmath:review_text>
        <zbmath:review_type>
          <xsl:value-of select="root/editorial_contributions/contribution_type"/>
        </zbmath:review_type>
        <zbmath:reviewer>
            <xsl:value-of select="root/editorial_contributions/reviewer/reviewer_id"/>
          </zbmath:reviewer>
        <zbmath:reviewer_id>
      <xsl:value-of  select="root/editorial_contributions/reviewer/author_code"/>
        </zbmath:reviewer_id>
    </zbmath:review>
    <zbmath:serial>
     <zbmath:serial_publisher>
<xsl:value-of select="root/source/series/publisher"/>
</zbmath:serial_publisher>
    <zbmath:serial_title>
<xsl:value-of select="root/source/series/title"/>
 </zbmath:serial_title>
    </zbmath:serial>
<zbmath:references>
      <xsl:for-each select="root/references">
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
       <zbmath:links>
                <xsl:for-each select="root/links[type != 'doi']">
                    <zbmath:link>
                        <xsl:choose>
                            <!-- Removed for backwards compatibility
                            <xsl:when test="type = 'doi'">
                                <xsl:value-of select="concat('https://doi.org/', identifier)"/>
                            </xsl:when>-->
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
                            </xsl:otherwise> <!-- reuse it for Datacite with a proper way for Datacite -->
                        </xsl:choose>
                    </zbmath:link>
                </xsl:for-each>
            </zbmath:links>
          <zbmath:rights>Content generated by zbMATH Open, such as reviews,
        classifications, software, or author disambiguation data,
        are distributed under CC-BY-SA 4.0. This defines the license for the
        whole dataset, which also contains non-copyrighted bibliographic
        metadata and reference data derived from I4OC (CC0). Note that the API
        only provides a subset of the data in the zbMATH Open Web interface. In
        several cases, third-party information, such as abstracts, cannot be
        made available under a suitable license through the API. In those cases,
        we replaced the data with the string 'zbMATH Open Web Interface contents
        unavailable due to conflicting licenses.'
    </zbmath:rights>
  </oai_zb_preview:zbmath>
</xsl:template>
</xsl:stylesheet>
