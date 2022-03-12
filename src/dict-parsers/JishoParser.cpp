//
// Created by Óscar Valente on 13/02/2022.
//

#include "JishoParser.h"

#include <iostream>
#include <tidy.h>
#include <cstdio>
#include <libxml/parser.h>
#include <libxml/xpath.h>
#include <fmt/core.h>

#include <util/FileIO.h>

xmlDocPtr getdoc(const char *docname) {
    xmlDocPtr doc;
    doc = xmlParseFile(docname);

    if (doc == NULL) {
        fprintf(stderr, "Document not parsed successfully. \n");
        return NULL;
    }

    return doc;
}

xmlXPathObjectPtr getnodeset(xmlDocPtr doc, xmlChar *xpath) {

    xmlXPathContextPtr context;
    xmlXPathObjectPtr result;

    context = xmlXPathNewContext(doc);
    if (context == NULL) {
        printf("Error in xmlXPathNewContext\n");
        return NULL;
    }
    result = xmlXPathEvalExpression(xpath, context);
    xmlXPathFreeContext(context);
    if (result == NULL) {
        printf("Error in xmlXPathEvalExpression\n");
        return NULL;
    }
    if (xmlXPathNodeSetIsEmpty(result->nodesetval)) {
        xmlXPathFreeObject(result);
        printf("No result\n");
        return NULL;
    }
    return result;
}

wchar_t *JishoParser::getTermInfo(char *term) {
    std::string result = JishoParser::getHTTP(term);

    const char *input = result.c_str();

    TidyBuffer output = {0};
    TidyBuffer errbuf = {0};
    TidyDoc tdoc = tidyCreate();                     // Initialize "document"

    int ok = JishoParser::parseXML(input, &output, &errbuf, &tdoc);

    printf("\nResult: %d\n", ok);

    char *docname = ".file.xml";

    FileIO::writeToFile(docname, (char *) output.bp, output.size);

    JishoParser::cleanXMLBuffers(&output, &errbuf, &tdoc);

    xmlDocPtr doc;
    auto *xpath = (xmlChar *) "//*[@id=\"secondary\"]/div/ul";
    xmlNodeSetPtr nodeset;
    xmlXPathObjectPtr nodesetObject;
    int i;
    xmlChar *keyword;

    doc = getdoc(docname);
    nodesetObject = getnodeset(doc, xpath);
    if (nodesetObject) {
        nodeset = nodesetObject->nodesetval;
        std::cout << nodeset->nodeNr << std::endl;
        for (i = 0; i < nodeset->nodeNr; i++) {
            keyword = xmlNodeListGetString(doc, nodeset->nodeTab[i]->xmlChildrenNode, 1);
            printf("keyword: %s\n", keyword);
            xmlFree(keyword);
        }
        xmlXPathFreeObject(nodesetObject);
    }
    xmlFreeDoc(doc);
    xmlCleanupParser();

    static wchar_t *sentence;
    return sentence;
}