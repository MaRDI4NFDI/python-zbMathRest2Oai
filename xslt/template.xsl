<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <xsl:call-template name="expand-url">
      <xsl:with-param name="url" select="'{INPUT_URL}'" />
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="expand-url">
    <xsl:param name="url" />
    <xsl:variable name="lc" select="translate($url, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
    <xsl:choose>
      <xsl:when test="starts-with($lc, 'doi:')">
        <xsl:value-of select="'doi'" />,
        <xsl:value-of select="concat('https://doi.org/', substring-after($url, 'doi:'))" /> <!-- Append 'https://doi.org/' to DOI -->
      </xsl:when>
      <xsl:when test="starts-with($lc, 'http:') or starts-with($lc, 'https:')">
        <xsl:value-of select="'http'" />,
        <xsl:value-of select="$url" />
      </xsl:when>
      <xsl:when test="starts-with($lc, 'ftp:')">
        <xsl:value-of select="'ftp'" />,
        <xsl:value-of select="$url" />
      </xsl:when>
      <xsl:when test="starts-with($lc, 'euclid:')">
        <xsl:value-of select="'euclid'" />, <!-- Return 'euclid' prefix -->
        <xsl:value-of select="concat('https://projecteuclid.org/euclid.', substring-after($url, 'euclid:'))" /> <!-- Append 'https://projecteuclid.org/euclid.' to Euclid URL -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'unknown'" />, <!-- Return 'unknown' prefix -->
        <xsl:value-of select="$url" /> <!-- Return URL as is -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
