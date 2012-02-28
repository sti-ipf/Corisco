<?xml version="1.0" encoding="UTF-8"?>

<!--
  flash.xsl

  Example of how to embed flash videos in the item summary page using
  the flv_player tool.

-->

<!--
   OhioLINK Flash video theme. 
-->    

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">
    
    <!--xsl:import href="../../dri2xhtml.xsl"/-->
    <xsl:output indent="yes"/>
    
    

<!-- An item rendered in the summaryView pattern. This is the default way to view a DSpace item in Manakin. 
     KRG 05/2008 Check for the video/x-flv filetype, and if found, embed the movie in the itemSummary page
     using the flv_player tool. 

     -Change to display filmstrip image if available
-->
    <xsl:template name="itemSummaryView-DIM">
			<!--	Call FLV templates    -->
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/x-flv']" mode="flashplay" />
                        <!--    Call MP4 templates    -->
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/mp4']" mode="flashplay" />
        <!-- Show Filmstrip thumbnail -->
         <xsl:if test="mets:fileSec/mets:fileGrp[@USE='FILMSTRIPTHUMB']">
           <img alt="Filmstrip Thumbnail">
             <xsl:attribute name="src">
               <xsl:value-of select="mets:fileSec/mets:fileGrp[@USE='FILMSTRIPTHUMB']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
             </xsl:attribute>
           </img>
         </xsl:if>
                
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
                <xsl:when test="not(./mets:fileSec/mets:fileGrp[@USE='CONTENT'])">
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                 <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                    <td colspan="4">
                        <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                        </tr>
                        </table>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']">
                            <xsl:with-param name="context" select="."/>
                            <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                        </xsl:apply-templates>
                </xsl:otherwise>
        </xsl:choose>

        <!-- Generate the license information from the file section -->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']"/>


    </xsl:template>




    <!-- Generate FLV maxi player objects for flash movie files in the CONTENT bundle -->
    <!-- METS file ID will be in the form file_xxxx, where xxxx
        Is the DSPace bitstream ID.  The substring function is used to strip
        the 'file_' portion from the ID -->

    <xsl:template match="mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/x-flv']" mode="flashplay" >
        <div style="text-align:center;">

        <object type="application/x-shockwave-flash" data="/themes/Flash/lib/player_flv_maxi.swf" width="480" height="385">
     <param name="movie" value="/themes/Flash/lib/player_flv_maxi.swf" />
     <param name="allowFullScreen" value="true" />
     <param name="FlashVars" value="flv={mets:FLocat/@xlink:href}&amp;width=480&amp;height=385&amp;showstop=1&amp;showvolume=1&amp;showtime=1&amp;showfullscreen=1&amp;bgcolor1=9999ff&amp;bgcolor2=cacafc&amp;playercolor=333333&amp;showplayer=always&amp;showiconplay=1&amp;iconplaycolor=ffffff" />
<embed src="/themes/Flash/lib/player_flv_maxi.swf" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" TYPE="application/x-shockwave-flash" WIDTH="480" HEIGHT="385" allowFullScreen="true" Flashvars="flv={mets:FLocat/@xlink:href}&amp;width=480&amp;height=385&amp;showstop=1&amp;showvolume=1&amp;showtime=1&amp;showfullscreen=1&amp;bgcolor1=9999ff&amp;bgcolor2=cacafc&amp;playercolor=333333i&amp;showplayer=always&amp;showiconplay=1&amp;iconplaycolor=ffffff" />

</object>

    </div>
    </xsl:template>

    <xsl:template match="mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='video/mp4']" mode="flashplay" >

        <div style="text-align:center;">

        <object type="application/x-shockwave-flash" data="/themes/Flash/lib/player_flv_maxi.swf" width="480" height="385">
     <param name="movie" value="/themes/Flash/lib/player_flv_maxi.swf" />
     <param name="allowFullScreen" value="true" />
     <param name="FlashVars" value="flv={mets:FLocat/@xlink:href}&amp;width=480&amp;height=385&amp;showstop=1&amp;showvolume=1&amp;showtime=1&amp;showfullscreen=1&amp;bgcolor1=9999ff&amp;bgcolor2=cacafc&amp;playercolor=333333&amp;showplayer=always&amp;showiconplay=1&amp;iconplaycolor=ffffff" />
<embed src="/themes/Flash/lib/player_flv_maxi.swf" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" TYPE="application/x-shockwave-flash" WIDTH="480" HEIGHT="385" allowFullScreen="true" Flashvars="flv={mets:FLocat/@xlink:href}&amp;width=480&amp;height=385&amp;showstop=1&amp;showvolume=1&amp;showtime=1&amp;showfullscreen=1&amp;bgcolor1=9999ff&amp;bgcolor2=cacafc&amp;playercolor=333333i&amp;showplayer=always&amp;showiconplay=1&amp;iconplaycolor=ffffff" />

</object>

    </div>
    </xsl:template>


<!-- KRG 2008-11-05
     The next two templates have been modified to display the filmstrip thumbnail in search and browse results
-->
 <!-- Generate the filmstrip thumbnail, if present, from the file section -->
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:if test="mets:fileGrp[@USE='FILMSTRIPTHUMB']">
            <div>
                <a href="{ancestor::mets:METS/@OBJID}">
                    <img alt="Filmstrip Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="mets:fileGrp[@USE='FILMSTRIPTHUMB']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                        </xsl:attribute>
                    </img>
                </a>
            </div>
        </xsl:if>
    </xsl:template>

     <!-- Resolve the reference tag to an external mets object -->
    <xsl:template match="dri:reference" mode="summaryList">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <!-- Since this is a summary only grab the descriptive metadata, and the filmstrip thumbnails -->
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=FILMSTRIPTHUMB</xsl:text>
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="document($externalMetadataURL)" mode="summaryList"/>
            <xsl:apply-templates />
        </li>
    </xsl:template>
 
</xsl:stylesheet>
