#!/usr/bin/python
# -*- coding: utf-8 -*-

import psycopg2
import sys
from xml.dom.minidom import parseString


class GenerateMenu:

    connection = False

    def saveXml(self, filename):
        document = parseString("<communities>" + self.getTreeCommunities(1) + "</communities>")
        fileXml = open(filename, "w")
        fileXml.write(document.toxml("utf-8"))
        fileXml.close()

    def getConnection(self):
        if not self.connection:
            try:
                self.connection = psycopg2.connect("\
                    dbname='dspace'\
                    user='dspace'\
                    host='127.0.0.1'\
                    password='dspace9940'\
                ")
            except:
                print "Falha de conexão com o banco de dados."
                sys.exit()
        return self.connection

    def getSubCommunity(self, parent_id):
        query = self.getConnection().cursor()
        query.execute("\
            SELECT community.community_id, community.name, Handle.handle \
            FROM community, community2community, Handle \
            WHERE community2community.child_comm_id = community.community_id \
            AND Handle.resource_id = community.community_id \
            AND Handle.resource_type_id = 4 \
            AND community2community.parent_comm_id = " + str(parent_id) + "\
            ORDER BY community.name")
        return query.fetchall()

    def getCollections(self, community_id):
        query = self.getConnection().cursor()
        query.execute("\
            SELECT collection.collection_id, collection.name \
            FROM collection, community2collection, Handle \
            WHERE community2collection.collection_id = collection.collection_id \
            AND Handle.resource_id = collection.collection_id \
            AND Handle.resource_type_id = 3 \
            AND community2collection.community_id = " + str(community_id) + "\
            ORDER BY collection.name")
        return query.fetchall()

    def getTreeCommunities(self, parent_id):
        result = ""
        data = self.getSubCommunity(parent_id)
        for row in data:
            result += "<community>"
            result += "<handle>" + str(row[2]) + "</handle>"
            result += "<title>" + row[1] + "</title>"
            result += self.getTreeCommunities(row[0])
            result += self.getTreeCollections(row[0])
            result += "</community>"

        return result

    def getTreeCollections(self, community_id):
        result = "<collections>"
        data = self.getCollections(community_id)
        for row in data:
            result += "<collection>"
            result += "<id>" + str(row[0]) + "</id>"
            result += "<title>" + row[1] + "</title>"
            result += "</collection>"
        result += "</collections>"
        return result


GenerateMenu = GenerateMenu()
GenerateMenu.saveXml("../webapps/xmlui/themes/Corisco/xsl/menu.xml")
