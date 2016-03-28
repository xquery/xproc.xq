<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xproc="http://xproc.net/xproc" exclude-result-prefixes="xs xproc" version="2.0">
    <xsl:output indent="yes"/>

    <xsl:variable name="standard-steps-library"
        select="document('typed-pipeline-library.xml')"/>
    <xsl:variable name="optional-steps-library"
        select="document('pipeline-optional.xml')"/>
    <xsl:variable name="extension-steps-library"
        select="document('pipeline-extension.xml')"/>

    <xsl:template match="p:pipeline|p:declare-step">
        <p:declare-step xmlns:xproc="http://xproc.net/xproc">
            <xsl:attribute name="xproc:default-name" select="'!1'"/>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates>
            <xsl:with-param name="dname">!1</xsl:with-param>
            </xsl:apply-templates>
        </p:declare-step>
    </xsl:template>

    <xsl:template
        match="p:input|p:iteration-source|p:viewport-source|p:output|p:log|p:serialization|p:variable|p:option|p:with-option">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <xsl:template
        match="p:for-each|p:viewport|p:choose|p:group|p:try">
        <xsl:param name="dname"></xsl:param>
        <xsl:copy>
            
            <xsl:attribute name="xproc:default-name" select="concat($dname,'.',1 + count(preceding-sibling::*[name() ne 'p:input'][name() ne 'p:output'][name() ne 'p:with-option'][name() ne 'p:variable'][name() ne 'p:import']))"/>
            
            <xsl:copy-of select="@*"/>
            <p:input port="source"/>
            <xsl:apply-templates>
                <xsl:with-param name="dname"  select="concat($dname,'.',1 + count(preceding-sibling::*[name() ne 'p:input'][name() ne 'p:output'][name() ne 'p:with-option'][name() ne 'p:variable'][name() ne 'p:import']))"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="p:catch">
        <xsl:param name="dname"></xsl:param>
        <xsl:copy>
            
            <xsl:attribute name="xproc:default-name" select="concat($dname,'.',1 + count(preceding-sibling::*[name() ne 'p:input'][name() ne 'p:output'][name() ne 'p:with-option'][name() ne 'p:variable'][name() ne 'p:import']))"/>
            
            <xsl:copy-of select="@*"/>
            <p:input port="source">
                <p:pipe port="result" step="" xproc:dstep="{$dname[1]}"/>
            </p:input>
            <xsl:apply-templates>
                <xsl:with-param name="dname"  select="concat($dname,'.',1 + count(preceding-sibling::*[name() ne 'p:input'][name() ne 'p:output'][name() ne 'p:with-option'][name() ne 'p:variable'][name() ne 'p:import']))"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template
        match="p:add-attribute
        | p:add-xml-base
        | p:cast-content-type
        | p:compare
        | p:count
        | p:delete
        | p:directory-list
        | p:error
        | p:escape-markup
        | p:filter
        | p:http-request
        | p:identity
        | p:insert
        | p:label-elements
        | p:load
        | p:make-absolute-uris
        | p:namespace-rename
        | p:pack
        | p:parameters
        | p:rename
        | p:replace
        | p:set-attributes
        | p:set-properties
        | p:sink
        | p:split-sequence
        | p:store
        | p:string-replace
        | p:unescape-markup
        | p:unwrap
        | p:wrap
        | p:wrap-sequence
        | p:xinclude
        | p:xslt">
        <xsl:param name="dname"></xsl:param>
        <xsl:copy>
            <xsl:attribute name="name" select="@name"/>
            <xsl:attribute name="xproc:default-name" select="concat($dname,'.',1 + count(preceding-sibling::*[name() ne 'p:input'][name() ne 'p:output'][name() ne 'p:with-option'][name() ne 'p:variable'][name() ne 'p:import']))"/>

            <xsl:variable name="step-impl" select="."/>
            <xsl:variable name="step-name" select="name()"/>
            <xsl:variable name="step-attr" select="@*[not(name(.) eq 'name')]"/>

            <xsl:variable name="step-def"
                select="$standard-steps-library//p:declare-step[string(@type) eq $step-name]"/>
            <xsl:variable name="inputs" select="p:input"/>
            <xsl:variable name="outputs" select="p:output"/>
            <xsl:variable name="options" select="p:with-option"/>

            <xsl:for-each select="$step-def/p:input">
                <xsl:variable name="input-port" select="string(@port)"/>
                <xsl:choose>
                    <xsl:when test="$inputs[@port eq $input-port]">
                        <xsl:copy-of select="$inputs[@port eq $input-port]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <p:input>
                            <xsl:copy-of
                                select="@*[not(name() eq 'primary')][not(name() eq 'sequence')][not(name() eq 'content-types')]"/>
                            <xsl:copy-of select="*"/>
                        </p:input>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$step-def/p:output">
                <xsl:variable name="output-port" select="string(@port)"/>
                <xsl:choose>
                    <xsl:when test="$outputs[@port eq $output-port]">
                        <xsl:copy-of select="$outputs[@port eq $output-port]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--p:output>
                            <xsl:copy-of select="@*[not(name() eq 'primary')][not(name() eq 'sequence')][not(name() eq 'select')]"/>
                            <xsl:copy-of select="*"/>
                        </p:output-->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$step-def/p:option">
               
                    <xsl:variable name="option-name" select="string(@name)"/>
                    <xsl:variable name="option-def" select="."/>
                    <xsl:variable name="option-impl"
                        select="$step-impl//p:with-option[@name eq $option-name]"/>
                    <xsl:variable name="match-attr" select="$step-attr[name() eq $option-name]"/>


                    <xsl:choose>
                        <xsl:when test="$match-attr">
                            <p:with-option name="{$option-name}">
                            <xsl:choose>
                                <xsl:when
                                    test="$option-name eq 'match' and $step-name eq 'p:string-replace'">
                                    <xsl:attribute name="select"
                                        select="$match-attr"/>
                                </xsl:when>
                                <xsl:when
                                    test="$option-name eq 'match'">
                                    <xsl:attribute name="select"
                                        select="concat('&quot;',$match-attr,'&quot;')"/>
                                </xsl:when>
                                <xsl:when
                                    test="$option-def[@as eq 'xs:QName']">
                                    <xsl:attribute name="select"
                                        select="concat('xs:QName(&quot;',$match-attr,'&quot;)')"/>
                                </xsl:when>
                                <xsl:when
                                    test="$option-def[@as eq 'xs:string']">
                                    <xsl:attribute name="select"
                                        select="concat('&quot;',$match-attr,'&quot;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="select" select="$match-attr"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </p:with-option>
                        </xsl:when>
                        <xsl:when test="$option-impl">
                            <p:with-option name="{$option-name}">
                            <xsl:attribute name="select" select="string($option-impl/@select)"/>
                            <xsl:copy-of select="$option-impl/*"/>
                            </p:with-option>
                        </xsl:when>
                        <xsl:when test="exists($option-def/@select)">
                            <p:with-option name="{$option-name}">
                            <xsl:attribute name="select" select="$option-impl/@select"/>
                            </p:with-option>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="@as eq 'xs:NCName'"></xsl:when>
                                <xsl:when test="@as eq 'xs:anyURI'"></xsl:when>
                                <xsl:when test="@as eq 'xs:string'">
                                    <p:with-option name="{$option-name}" select="''"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p:with-option name="{$option-name}" select="/"/>
                                </xsl:otherwise>
                            </xsl:choose>
                           
                        </xsl:otherwise>
                    </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
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
