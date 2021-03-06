//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_XML_H
#define NIHONGO_ANKI_TETSUDAI_XML_H

#include <iostream>
#include <vector>
#include <libxml/xpath.h>

class XML {
public:
    static xmlNodeSet *findSubtreeRootInDocByXPath(xmlXPathContext *ctx, xmlChar *xpath, xmlXPathObject *subtreeObj) {
        subtreeObj = xmlXPathEval(xpath, ctx);
        if (xmlXPathNodeSetIsEmpty(subtreeObj->nodesetval)) {
            xmlXPathFreeObject(subtreeObj);
            printf("No result - finding subtree in doc\n");
            return nullptr;
        }
        return subtreeObj->nodesetval;
    }

    static xmlNodeSet *
    findSubtreeInSubtreeByXPath(xmlXPathContext *ctx, xmlNode *parentSubtreeNode, xmlChar *childSubtreeXpath,
                                xmlXPathObject *childSubtreeObject) {
        childSubtreeObject = xmlXPathNodeEval(parentSubtreeNode, childSubtreeXpath, ctx);

        if (xmlXPathNodeSetIsEmpty(childSubtreeObject->nodesetval)) {
            xmlXPathFreeObject(childSubtreeObject);
            printf("No result - finding child subtree in subtree - %s\n", childSubtreeXpath);

            return nullptr;
        }

        return childSubtreeObject->nodesetval;
    }

    static xmlChar *
    findTermsInSubtreeByXPath(xmlXPathContext *ctx, xmlNode *subtreeRoot, xmlChar *xpath, xmlXPathObject *termObj) {
        termObj = xmlXPathNodeEval(subtreeRoot, (xmlChar *) xpath, ctx);
        if (xmlXPathNodeSetIsEmpty(termObj->nodesetval)) {
            xmlXPathFreeObject(termObj);
            printf("No result - finding term in subtree\n");
            return nullptr;
        }
        return xmlNodeGetContent(termObj->nodesetval->nodeTab[0]);
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_XML_H
