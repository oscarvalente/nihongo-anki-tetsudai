//
// Created by Óscar Valente on 13/02/2022.
//

#include "JishoParser.h"

#include <iostream>
#include <tidy.h>
#include <cstdio>
#include <libxml/parser.h>
#include <libxml/xpath.h>
#include <libxml/xmlstring.h>
#include <fmt/core.h>

#include <util/XML.h>

xmlDoc *getDoc(const char *input, int size) {
    xmlDoc *doc = xmlParseMemory(input, size);

    if (doc == nullptr) {
        fprintf(stderr, "Document not parsed successfully. \n");
        return NULL;
    }

    return doc;
}

wchar_t *JishoParser::getTermInfo(char *term) {
    std::string result = JishoParser::getHTTP(term);

    const char *input = result.c_str();

    TidyBuffer output = {0};
    TidyBuffer errbuf = {0};
    TidyDoc tdoc = tidyCreate();                     // Initialize "document"

    int ok = JishoParser::parseXML(input, &output, &errbuf, &tdoc);
    if (ok > 0) {
        printf("OUCH!\n");
    }

    xmlDoc *doc = getDoc((char *) output.bp, output.size - 1);
    JishoParser::cleanXMLBuffers(&output, &errbuf, &tdoc);


    auto *xpath = (xmlChar *) "//*[@id=\"secondary\"]/div/ul/li[1]";
    auto *xpathChild = (xmlChar *) ".//div[2]/ul/li[1]/span[@class='furigana'][1]";

    xmlXPathContext *ctx = xmlXPathNewContext(doc);

    xmlXPathObject *subtreeObject;
    xmlNode *subtree = XML::findSubtreeRootInDocByXPath(ctx, xpath, subtreeObject);
    xmlXPathObject *termObject;
    xmlChar *targetTerm = XML::findTermInSubtreeByXPath(subtree, ctx, xpathChild, termObject);

    printf("child: %s \n", targetTerm);

    xmlFree(targetTerm);

    xmlXPathFreeObject(subtreeObject);
    xmlXPathFreeContext(ctx);

    xmlFreeDoc(doc);
    xmlCleanupParser();

    static wchar_t *sentence;
    return sentence;
}