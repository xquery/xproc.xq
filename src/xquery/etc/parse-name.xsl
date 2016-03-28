<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xproc="http://xproc.net/xproc" 
    exclude-result-prefixes="xs xproc" 
    version="2.0">
    <xsl:output indent="yes" />
    
    <xsl:variable name="standard-steps-library"
        select="document('typed-pipeline-library.xml')"/>
    <xsl:variable name="optional-steps-library"
        select="document('pipeline-optional.xml')"/>
    <xsl:variable name="extension-steps-library"
        select="document('pipeline-extension.xml')"/>
   
    <xsl:template match="p:input">
        <xsl:variable name="input-name" select="@port" as="xs:string"/>
        <p:input>
            <xsl:copy-of select="@*"/>
            <xsl:choose>
            <xsl:when test="*">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p:pipe port="result"
                        step="{../preceding-sibling::*[1]/@name}"
                        xproc:dstep="{(../preceding-sibling::*[1]/@xproc:default-name,../ancestor::*[1]/@xproc:default-name,'xproc:std-input')[1]}" >
                    <xsl:apply-templates/>
                </p:pipe>
            </xsl:otherwise>
            </xsl:choose>
            
        </p:input>
    </xsl:template>
 
    <xsl:template match="p:pipe">
        <xsl:variable name="step-name" select="@step" as="xs:string"/>
        <p:pipe port="{@port}" step="{$step-name}" xproc:dstep="{(@xproc:dstep,//*[@name eq $step-name]/@xproc:default-name)[1]}"/>
    </xsl:template>
    
    
    <xsl:template match="element()">
        <xsl:copy>
            <xsl:apply-templates select="@*,node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="attribute()|text()|comment()|processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
</xsl:stylesheet>
