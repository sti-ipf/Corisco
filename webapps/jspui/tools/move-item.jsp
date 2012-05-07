<%--
  - move-item.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
	
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.app.webui.servlet.admin.EditItemServlet" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.text.Collator" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
	Collection [] notLinkedCollections = (Collection[] )request.getAttribute("notLinkedCollections");
  TreeMap<String, Integer> notLinkedCollectionsSorted = new TreeMap<String, Integer>(Collator.getInstance());
  for (int i = 0; i < notLinkedCollections.length; i++)
  {
    String firstCommunity = (notLinkedCollections[i].getCommunities().length > 0) ? notLinkedCollections[i].getCommunities()[0].getMetadata("name") : "";
    notLinkedCollectionsSorted.put(firstCommunity + " - " + notLinkedCollections[i].getMetadata("name"), notLinkedCollections[i].getID());
  }

	Collection [] linkedCollections = (Collection[] )request.getAttribute("linkedCollections");
  TreeMap<String, Integer> linkedCollectionsSorted = new TreeMap<String, Integer>(Collator.getInstance());
  for (int i = 0; i < linkedCollections.length; i++)
  {
    String firstCommunity = (linkedCollections[i].getCommunities().length > 0) ? linkedCollections[i].getCommunities()[0].getMetadata("name") : "";
    linkedCollectionsSorted.put(firstCommunity + " - " + linkedCollections[i].getMetadata("name"), linkedCollections[i].getID());
  }
	
	Item item = (Item)request.getAttribute("item");
%>

<dspace:layout titlekey="jsp.tools.move-item.title">

   	<form action="<%=request.getContextPath()%>/tools/edit-item" method="post">
   		
	  <table class="miscTable" align="center">
        <tr>
          <td class="evenRowEvenCol" colspan="2">
            <table>
              <tr>
                <td class="standard">
				  <small><strong><fmt:message key="jsp.tools.move-item.item.name.msg"/></strong></small>
			    </td>
			    <td class="standard">
				  <font color="#FF0000"><%=item.getMetadata("dc", "title", null, Item.ANY)[0].value%></font>
				</td>
			  </tr>
			  <tr>
				<td class="standard">
					<small><strong><fmt:message key="jsp.tools.move-item.collection.from.msg"/></strong></small>
				</td>
				<td class="standard">
				<select name="collection_from_id">
<%
        for (String collection : linkedCollectionsSorted.keySet())
        {
%>
            <option value="<%= linkedCollectionsSorted.get(collection) %>"><%= collection %></option>
<%
        }
%>
				</select>
				</td>
			  </tr>
			  <tr>
				<td class="standard">
					<small><strong><fmt:message key="jsp.tools.move-item.collection.to.msg"/></strong></small>
				</td>
				<td class="standard">
				<select name="collection_to_id">
<%
        for (String collection : notLinkedCollectionsSorted.keySet())
        {
%>
            <option value="<%= notLinkedCollectionsSorted.get(collection) %>"><%= collection %></option>
<%
        }
%>
				</select>
			</td>
         </tr>
		 <tr>
       		<td class="standard"></td>
       		<td class="standard">
				<input type="submit" name="submit" value="<fmt:message key="jsp.tools.move-item.button"/>"/>
			</td>
         </tr>
        </table>
        </td>
      </tr>
     </table>
      <input type="hidden" name="action" value="<%=EditItemServlet.CONFIRM_MOVE_ITEM%>" />
      <input type="hidden" name="item_id" value="<%=item.getID() %>"/> 
    </form>


</dspace:layout>
