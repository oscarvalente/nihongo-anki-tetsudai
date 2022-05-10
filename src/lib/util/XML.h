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

    static int parseXML(const char *input, TidyBuffer *output, TidyBuffer *errbuf, TidyDoc *tdoc) {
        int rc = -1;
        Bool ok;

        ok = tidyOptSetBool(*tdoc, TidyXmlOut, yes);  // Convert to XML
        if (ok)
            rc = tidySetErrorBuffer(*tdoc, errbuf);      // Capture diagnostics
        if (rc >= 0)
            rc = tidyParseString(*tdoc, input);           // Parse the input
        if (rc >= 0)
            rc = tidyCleanAndRepair(*tdoc);               // Tidy it up!
        if (rc >= 0)
            rc = tidyRunDiagnostics(*tdoc);               // Kvetch
        if (rc > 1)                                    // If error, force output.
            rc = (tidyOptSetBool(*tdoc, TidyForceOutput, yes) ? rc : -1);
        if (rc >= 0)
            rc = tidySaveBuffer(*tdoc, output);          // Pretty Print

        if (rc >= 0) {
            if (rc > 0)
                printf("\nDiagnostics:\n\n%s", (*errbuf).bp);
//            printf("\nAnd here is the result:\n\n%s", (*output).bp);
        } else
            printf("A severe error (%d) occurred.\n", rc);
        return rc;
    }

    static void cleanXMLBuffers(TidyBuffer *output, TidyBuffer *errbuf, TidyDoc *tdoc) {
        tidyBufFree(output);
        tidyBufFree(errbuf);
        tidyRelease(*tdoc);
    }

    static xmlDoc *getDoc(const char *input, int size) {
        xmlDoc *doc = xmlParseMemory(input, size);

        if (doc == nullptr) {
            fprintf(stderr, "Document not parsed successfully. \n");
            return NULL;
        }

        return doc;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_XML_H
