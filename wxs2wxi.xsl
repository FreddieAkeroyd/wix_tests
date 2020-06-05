<xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:msxsl="urn:schemas-microsoft-com:xslt"
            exclude-result-prefixes="msxsl"
            xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"
            >

    <!-- Turns a Wix wxs file into a wxi include file that can then be used in another master wxs file -->

    <xsl:output method="xml" indent="yes" />

    <xsl:strip-space elements="*"/>

    <xsl:template match='wix:Wix'>
	    <Include>
            <xsl:apply-templates select="*"/>
	    </Include>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

  <!-- Search directories for the components that will be removed. -->
  <xsl:key name="dir-search" match="wix:Directory[@Name = '.git' or @Name = 'package_builder' or @Name = 'build']" use="descendant::wix:Component/@Id" />

  <!-- Remove directories. -->
  <xsl:template match="wix:Directory[@Name = '.git' or @Name = 'package_builder' or @Name = 'build']" />

  <!-- Remove componentsrefs referencing components in those directories. -->
  <xsl:template match="wix:ComponentRef[key('dir-search', @Id)]" />
  
</xsl:stylesheet>