<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes"/>
<!-- Authors: JA Groeneveld & Myrta Gruening <info@myrta.eu> !-->
<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="MODULE"/>
<xsl:template match="TEST"/>

<xsl:template match="STUDENT">
        <xsl:variable name="filename" select="concat(DATA/ID,'_',DATA/SURNAME,'-feedback.tex')" />
        <xsl:value-of select="$filename" />
	<xsl:result-document href="{$filename}" method="text">
	<xsl:text>\documentclass[11pt]{article}
	\usepackage[a4paper,top=1.2cm,bottom=1.2cm,left=1.5cm,right=1.5cm]{geometry}
	\usepackage{helvet}
	\renewcommand*\familydefault{\sfdefault} 
	\usepackage{array}
	\usepackage{amsmath}
	\pagestyle{empty}
	\setlength{\parindent}{0.0cm}
	\setlength{\parskip}{0.0cm}
	\renewcommand{\baselinestretch}{1.2}
	\begin{document}	
	\begin{center}
	</xsl:text>
	<xsl:variable name="institution" select="../MODULE/INSTITUTION" />
	<xsl:variable name="classcode" select="../MODULE/MODULE_CODE" />
	<xsl:variable name="classdesc" select="../MODULE/MODULE_NAME" />
	<xsl:variable name="teacher" select="../MODULE/TEACHER" />
	<xsl:variable name="email" select="../MODULE/TEACHER_EMAIL" />
	<xsl:variable name="testtype" select="../TEST/TYPE" />
	<xsl:variable name="max" select="../TEST/AVAILABLE_MARKS" />
	<xsl:text>{\bfseries </xsl:text> <xsl:value-of select="$institution"/> <xsl:text>}\\ \vspace{5mm}
	{\bfseries </xsl:text> <xsl:value-of select="$classcode"/><xsl:text> \hfil
	</xsl:text> <xsl:value-of select="$classdesc"/> <xsl:text> \hfil </xsl:text> <xsl:value-of select="$testtype"/> <xsl:text>}\\ \vspace{5mm}
	\end{center}
	\begin{tabular}{l  l}
	\hline
	</xsl:text>
	<xsl:text>{\bf Name and Surname:} &amp;</xsl:text> <xsl:value-of select="DATA/NAME"/><xsl:text> </xsl:text><xsl:value-of select="DATA/SURNAME"/><xsl:text> \\</xsl:text>
	<xsl:text>{\bf Student ID:} &amp; </xsl:text><xsl:value-of select="DATA/ID"/>	<xsl:text>\\</xsl:text>
	<xsl:text>
	\hline
	\end{tabular}\par \vspace{15mm}
	\begin{tabular}{l|c}
	</xsl:text>
	<xsl:for-each select = "MARKS/PNT">
	<xsl:value-of select="@obj"/>  <xsl:text>&amp;</xsl:text> <xsl:value-of select="."/><xsl:text>\\
        \hline </xsl:text>
	</xsl:for-each>
	<xsl:text>\hline </xsl:text>
	<xsl:variable name="myTotal" select="sum(MARKS/PNT[number(.) = number(.)])"/>
	<xsl:text>{\bf Total (out of </xsl:text><xsl:value-of select="$max"/>
	<xsl:text> marks)} &amp;</xsl:text><xsl:text>{\bf </xsl:text> <xsl:value-of select="$myTotal"/><xsl:text>} \\</xsl:text>
	<xsl:text>
	\end{tabular} \par \vspace{15mm}</xsl:text>
	<xsl:value-of select="COMMENT"/>
	<xsl:text>
	\vfill
	For any question please contact </xsl:text><xsl:value-of select="$teacher"/><xsl:text>, e-mail:</xsl:text><xsl:value-of select="$email"/>
	<xsl:text>
	\end{document}
	</xsl:text>
        </xsl:result-document>
</xsl:template>

</xsl:stylesheet> 
