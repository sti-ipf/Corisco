<?xml version="1.0" encoding="UTF-8"?>

<!--
  bitstream-listing.xsl

  Version: 1

  Date: 2011-02-15 09:30:00 -0200 (Tue, 15 Feb 2011)

  Copyright (c) 2010-2011, Brasiliana Digital Library (http://brasiliana.usp.br).
  Copyright (c) 2002-2005, Hewlett-Packard Company and Massachusetts
  Institute of Technology.  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  - Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  - Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  - Neither the name of the Hewlett-Packard Company nor the name of the
  Massachusetts Institute of Technology nor the names of their
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  DAMAGE.
-->

<!--
    Description: Specialization of 'General-Handler.xsl', of the Reference theme.
    Author: Fabio N. Kepler
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
        exclude-result-prefixes="mets xlink xsl dim xhtml mods dc">

    <xsl:output indent="yes"/>

    <!-- Generate the thunbnail, if present, from the file section -->
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:param name="primaryBitstream" select="-1"/>
        <xsl:comment><xsl:value-of select="$primaryBitstream"/></xsl:comment>

        <a href="{ancestor::mets:METS/@OBJID}">
            <xsl:choose>
                
                <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']">
                    <img class="preview-thumbnail" alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                        </xsl:attribute>
                    </img>
                </xsl:when>

		<xsl:when test="$primaryBitstream != -1">
                    <xsl:choose>
                        <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']/mets:file[@ID=$primaryBitstream]">
                            <img class="preview-thumbnail" alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="mets:fileGrp[@USE='THUMBNAIL']/mets:file[@ID=$primaryBitstream]/mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="thumbnail-path">
                                <xsl:value-of select="$djatoka-thumbnail-base-url"/>
                                <xsl:value-of select="//mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']//mets:fptr[@FILEID=$primaryBitstream]/@FILEINTERNALID"/>
                            </xsl:variable>

                            <img class="preview-thumbnail" alt="Thumbnail" onerror="this.onerror=null;this.src='{$bookreader-path}images/video_01.jpg';">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$thumbnail-path"/>
                                </xsl:attribute>
                            </img>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>


                <xsl:when test="mets:fileGrp[@USE='LOGO']">
                    <xsl:comment>@USE='LOGO' preview-thumbnail</xsl:comment>
                    <xsl:apply-templates select="mets:fileGrp[@USE='LOGO']"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:variable name="fileid">
                        <xsl:value-of select="mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']/mets:file[1]/@ID"/>
                    </xsl:variable>
                    <xsl:variable name="thumbnail-path">
                        <xsl:value-of select="$djatoka-thumbnail-base-url"/>
                        <xsl:value-of select="//mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']//mets:fptr[@FILEID=$fileid]/@FILEINTERNALID"/>
                    </xsl:variable>

			<img class="preview-thumbnail" alt="Thumbnail" onerror="this.onerror=null;this.src='{$bookreader-path}images/video_01.jpg';">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$thumbnail-path"/>
                                </xsl:attribute>
                            </img>


                    <!--img class="preview-thumbnail test" alt="Thumbnail" onerror="this.onerror=null;this.src='{$bookreader-path}images/video_01.jpg';">
                        <xsl:attribute name="src">
                        	/xmlui/themes/Corisco/lib/img/videos_preview/<xsl:value-of select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']/mets:file[@ID=$fileid]/mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>.png
                        </xsl:attribute>
                    </img-->
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>

    <!-- Generate the bitstream information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>

        <xsl:choose>
            <xsl:when test="mets:file/@MIMETYPE='image/png'">
                <ul class="ds-list-media">
                    <xsl:choose>
                        <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                        <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                           <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <!-- Otherwise, iterate over and display all of them -->
                        <xsl:otherwise>
                           <xsl:apply-templates select="mets:file">
                                <xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />
                                <xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <script type="text/javascript">

                    function resizeFancybox(width, height) {
                        $("#fancybox-content").css("width", width);
                        $("#fancybox-wrap").css("width", width+20);
                        $.fancybox.center(true);
                        setTimeout("$.fancybox.center(true)", 1000);
                    }

                    $(function() {
                        <xsl:choose>
                            <xsl:when test="mets:file/@MIMETYPE='audio/x-mpegaaaaa'">
                                <xsl:for-each select="mets:file">
                                    var link = "<xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:href, '?')" />";
                                    var key = link.replace(/[\/%_\.]/g, "")

                                    var descItem = $('<p class="description-item" />').text('<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" />');
                                    var item =  $('<li class="item" />').append(descItem).append($('<a class="visualizar-midia fancybox" href="#' + key + '" rel="' + key + '" title="Ouvir áudio" />').append('<img alt="Ouvir áudio" src="{$theme-path}/images/chamada-video-pequena.png" />'));
                                    $(".lista-galeria-midia").append(item);

                                    var $hideBloco = $('<div style="display: none;" />');
                                    var $bloco = $('<div id="' + key + '" />');
                                    $bloco.append('<div id="jwp-' + key + '">Carregando...</div>');

                                    $(".blocos-midia").append($hideBloco.append($bloco));

                                    jwplayer("jwp-" + key).setup({
                                        'flashplayer': "/xmlui/themes/Corisco/lib/js/player.swf",
                                        'controlbar': 'bottom',
                                        'height': 24,
                                        'width': '480',
                                        'file': link
                                    });
                                </xsl:for-each>

                                $(".visualizar-midia.fancybox").fancybox({
                                    titleShow: false,
                                    'autoDimensions': false,
                                    'width': '490',
                                    'height': '30',
                                    onComplete: function(a) {
                                        jwplayer("jwp-" + a.attr("rel")).play();
                                    },
                                    onClose: function(e) {
                                      jwplayer("jwp-" + a.attr("rel")).pause();
                                    }
                                });
                            </xsl:when>
                            <xsl:otherwise>

				<xsl:variable name="identifier-other">
				    <xsl:value-of select="//dim:field[@element='identifier' and @qualifier='other']"/>
				</xsl:variable>
			
				var image_preview = 'http://177.11.48.108/acervo_preview_img/<xsl:value-of select="$identifier-other"/>.png';		
				function getStreamingFile(fullpath, type) {
					
					var path = '';
					if(type == 'audio')
						path = 'http://177.11.48.108/acervo_audios/';
					else
						path = 'http://177.11.48.108/acervo_videos/';
			
															
					var firstIndex = fullpath.lastIndexOf('/');
					var lastIndex = fullpath.length;
					
					var file = fullpath.substring(firstIndex + 1, lastIndex);
					return path + file;
				}

				function getMediaType(){
					var type = 'audio'; 	
                                	<xsl:for-each select="mets:file">
					   <xsl:if test="@MIMETYPE='video/ogg'">
                                            	type =  'video';
					   </xsl:if>
					</xsl:for-each>
					return type;		
				}	

                                function textoQualidade(sigla) {
                                    var texto = "";

                                    switch(sigla) {
                                        case "B":
                                            texto = "Baixa";
                                            break;
                                        case "M":
                                            texto = "Média";
                                            break;
                                        case "C":
                                            texto = "Celular";
                                            break;
                                        default:
                                            texto = "Outra";
                                            break;
                                    }

                                    return texto;
                                }

                                function getResolution(quality) {
                                    var resolution = {};

                                    if (quality == 'B') {
                                        resolution.width = 480;
                                        resolution.height = 320;
                                    } else {
                                        resolution.width = 720;
                                        resolution.height = 480;
                                    }

                                    return resolution;
                                }

                                function trocaQualidade() {
                                    var id = $(this).attr("rel");
                                    var conf = $(this).attr("alt").split("|");
                                    var type = $(this).attr("type");
				    var width = parseInt(conf[1]);
                                    var height = parseInt(conf[2]);
				    var filename = getStreamingFile(conf[0], type);
                                    jwplayer(id)
                                        .load([{
                                            'file': filename,
                                            'image': image_preview}])
                                        .resize(width, height)
                                        .play();

                                    resizeFancybox(width, height);

                                    return false;
                                }
				
				function getAttachFileType(mimetype){
					var index = mimetype.indexOf('/');
					return mimetype.substr(0, index);
				}

				function makeFileObjects(files){
					var obj = new Object()	
					for (var i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> files.length; i++) {
						var index = files[i][0].substr(0, files[i][0].lastIndexOf("_")).replace(/[\/%_]/g, "");
						var iPos = files[i][0].lastIndexOf("_")+1;
						var quality = files[i][0].substr(iPos, files[i][0].lastIndexOf(".")-iPos);
						var type = getAttachFileType(files[i][2]);

						if (eval("obj." + index) == undefined) eval("obj." + index + " = new Object({defaultQuality: '" + quality + "', type: '"+type+"', key: '"+index+"', name: '"+files[i][1]+"', list: new Object})");
						if (quality == "B") eval("obj." + index + ".defaultQuality = 'B'");

						eval("obj." + index + ".list." + quality + " = ['" + files[i][0] + "', '" + files[i][1] + "']");
					}

					if(getMediaType() == 'video'){
						for(var key in obj){
							var file = obj[key];
							if(file.type == 'audio'){
								delete obj[key];
								addAudioToYourVideo(file, obj);
							}
						}
					}

					return obj;

				}

				function addAudioToYourVideo(audioFile, fileObj){
					for(var key in fileObj){
						var file = fileObj[key];
						if(file.type == 'video'){
							if(file.name == audioFile.name)
							{
								file.audio = audioFile;
								break;
							}
						}
					}
				}

				function makeFancyBox(file){
					var $hideBloco = $('<div style="display: none;" />');
					var $bloco = $('<div class="div-midia-fancybox" id="' + file.key + '" />');
					$bloco.append($('<div class="div-item-description-video" />').text(file.list[file.defaultQuality][1]));
					$bloco.append('<div id="jwp-' + file.key + '">Carregando...</div>');

					var $listaDiv = $('<div class="listaNormal" id="'+file.key+'" />');
					makeFancyBoxLists(file, $listaDiv, file.key);
					$hideBloco.append($bloco.append($('<br />')).append($listaDiv));
					
					$(".blocos-midia").append($hideBloco);
				
					if(file.type == 'video'){
						if(file.audio){
							var $onlyAudioList = $('<div class="onlyAudioList" />');
							makeFancyBoxLists(file.audio, $onlyAudioList, file.key);
							$listaDiv.after($onlyAudioList);
							$listaDiv.css('border-right', 'solid 1px');
						}
					}

				}
				
				function putPipeSeparatorInList($lista){
					var pipesAdded = 0;
					$lista.children().each(function(index) {
							index += pipesAdded;
							var not_is_last_item = (index <xsl:text disable-output-escaping="yes">&lt;</xsl:text> ($lista.children().length - 1));
							if (not_is_last_item) {
							$(this).after($('<strong />').text('|'));
							pipesAdded += 1;
							}
							});
				}

				function makeFancyBoxLists(file, $divToAppend, jwplayerID){
					var visualizarLabel = file.type == 'video' ? "Visualizar em qualidade: " : "Ouvir em qualidade: ";
					var $labelVisualizarEmQualidade = $('<strong />').text(visualizarLabel);
					var $labelFazerDownloadEmQualidade = $('<strong />').text("Baixar/Copiar em qualidade: ");
					var $lista = $('<ul class="qualidades-video" />');
					var $listaDownloads = $('<ul class="qualidades-video" />');
					for (var quality in file.list) {
						var value = file.list[quality];

						$listaDownloads.append($('<li />').append($('<a href="' + value[0] + '" alt="' + value[0] + '">' + textoQualidade(quality) + '</a>')));
						if (quality != "C") {
							var resolution = getResolution(quality)
							value = value[0] + "|" + resolution.width + "|" + resolution.height;

							$lista.append($('<li />').append($('<a href="javascript:void(0);" type="'+file.type+'" rel="jwp-' +jwplayerID + '" alt="' + value + '">' + textoQualidade(quality) + '</a>').click(trocaQualidade)));
						}
					}

					var pipesAdded = 0;
					
					putPipeSeparatorInList($listaDownloads);
					putPipeSeparatorInList($lista);
					
					$divToAppend.append($labelVisualizarEmQualidade).append($lista).append($labelFazerDownloadEmQualidade).append($listaDownloads);
				}
				
				function buildFancyBox(file){
					var item =  getItemList(file);
					$(".lista-galeria-midia").append(item);
					makeFancyBox(file);
				}	

				function getItemList(file){
					var filename = file.name;
					var key = file.key;
					var filelink = file.list[file.defaultQuality][0];
					if(getMediaType() == 'video')
					{
						var descItem = $('<p class="description-item" />').text(filename);
						return $('<li class="item" />').append(descItem).append($('<a class="visualizar-midia fancybox" href="#' + key + '" rel="' + filelink + '" title="Clique aqui para assistir ou fazer cópia do vídeo" />').append('<img alt="Clique aqui para assistir ou fazer cópia do vídeo" onError="onErrorImgPreview(this);"  src="'+image_preview+'" />'));
					}
					else
					{
						if(!filename)
							filename = 'Audio';
						var descItem = $('<label class="description-item" />').text(filename);
						return $('<li class="item" />').append($('<a class="visualizar-midia fancybox" href="#' + key + '" rel="' + filelink + '" title="Clique aqui para assistir ou fazer cópia do vídeo" />').append(descItem));

					}

				}
				

				function makeHtml(fileObj){
					if(getMediaType() == 'audio'){
						var img = '<img alt="Clique aqui para assistir ou fazer cópia do vídeo" onError="onErrorImgPreview(this);"  src="'+image_preview+'" />';
						$('.blocos-midia').append('<div id="audio-title"></div>');
						$('.blocos-midia').append('<div class="audio-preview">'+img+'</div>');
						$('.blocos-midia').append('<ul class="lista-galeria-midia lista-galeria-audio"></ul>');
					}else
					{
						$('.blocos-midia').append('<ul class="lista-galeria-midia lista-galeria-video"></ul>');
						$('.blocos-midia').append('<p class="video-msg">Clique na imagem para assitir ou fazer cópia do vídeo</p>');
					}
					
					for (var key in fileObj) {
						buildFancyBox(fileObj[key]);
					}
		
					$(".visualizar-midia.fancybox").fancybox({
					    titleShow: false,
					    autoDimensions: true,
					    onComplete: function(a) {
						var filename = getStreamingFile(a.attr("rel"), getMediaType());
						var resolution = getResolution('B');
						resizeFancybox(resolution.width, resolution.height);
						jwplayer("jwp-" + a.attr("href").substring(1)).setup({
						    'flashplayer': '<xsl:value-of select="$theme-path"/>/lib/js/player.swf',
						    'autostart': true,
						    'image': image_preview,
						    'file':  filename,
						    'width': resolution.width,
						    'height': resolution.height,
						});
					    },
					    onClose: function(e) {
					      jwplayer("jwp-" + a.attr("href").substring(1)).pause();
					    }
					});
				

				}
				var files = [];
                                <xsl:for-each select="mets:file">
                                    files.push(["<xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:href, '?')" />", "<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" />", "<xsl:value-of select="@MIMETYPE" />"]);
                                </xsl:for-each>

				files.sort(sortFilesArray);
				if(getMediaType() == 'audio')
					prepareAudioArray(files);	
				var fileObj = makeFileObjects(files);
				makeHtml(fileObj);
								
                            </xsl:otherwise>
                        </xsl:choose>
                    });
                </script>
                <div class="blocos-midia"><span></span></div>

               
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Build a single row in the bitsreams table of the item view page -->
    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <li>
            <xsl:choose>
                <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                    mets:file[@GROUPID=current()/@GROUPID]">
                    <a class="fancybox" rel="fancybox">
                        <xsl:attribute name="href">
                            <xsl:call-template name="getFileViewURL">
                                <xsl:with-param name="file" select="."/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <img alt="Thumbnail" width="200" height="150">
                            <xsl:attribute name="src">
                                <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                        </img>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="getFileViewURL">
                                <xsl:with-param name="file" select="."/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!--
    File Type Mapping template

    This maps format MIME Types to human friendly File Type descriptions.
    Essentially, it looks for a corresponding 'key' in your messages.xml of this
    format: xmlui.dri2xhtml.mimetype.{MIME Type}

    (e.g.) <message key="xmlui.dri2xhtml.mimetype.application/pdf">PDF</message>

    If a key is found, the translated value is displayed as the File Type (e.g. PDF)
    If a key is NOT found, the MIME Type is displayed by default (e.g. application/pdf)
    -->
    <xsl:template name="getFileTypeDesc">
      <xsl:param name="mimetype"/>

      <!--Build full key name for MIME type (format: xmlui.dri2xhtml.mimetype.{MIME type})-->
      <xsl:variable name="mimetype-key">xmlui.dri2xhtml.mimetype.<xsl:value-of select='$mimetype'/></xsl:variable>

      <!--Lookup the MIME Type's key in messages.xml language file.  If not found, just display MIME Type-->
      <i18n:text i18n:key="{$mimetype-key}"><xsl:value-of select="$mimetype"/></i18n:text>
    </xsl:template>

    <xsl:template name="getFileViewURL">
        <xsl:param name="file"/>
        <xsl:variable name="original-link">
            <xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:href, '?')"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="@MIMETYPE = 'image/jpeg'">
                <xsl:variable name="viewer-link">
                    <xsl:value-of select="ancestor::mets:METS/@OBJID"/>
                    <xsl:text>/stream/</xsl:text>
                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                </xsl:variable>
                <xsl:value-of select="$viewer-link"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$original-link"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
        <div class="license-info">
            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></p>
            <ul>
                <xsl:if test="@USE='CC-LICENSE'">
                    <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
                </xsl:if>
                <xsl:if test="@USE='LICENSE'">
                    <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
                </xsl:if>
            </ul>
        </div>
    </xsl:template>

    <!-- Generate the logo, if present, from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LOGO']">
        <img class="preview-thumbnail" alt="Thumbnail" onerror="this.onerror=null;this.src='{$bookreader-path}/images/transparent.png';">
            <xsl:attribute name="src">
                <xsl:value-of select="mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <xsl:attribute name="alt">xmlui.dri2xhtml.METS-1.0.collection-logo-alt</xsl:attribute>
            <xsl:attribute name="attr" namespace="http://apache.org/cocoon/i18n/2.1">alt</xsl:attribute>
        </img>
    </xsl:template>

</xsl:stylesheet>
