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

#include <lib/util/XML.h>
#include <lib/core/Sentence.h>
#include <lib/core/Cache.h>

xmlDoc *getDoc(const char *input, int size) {
    xmlDoc *doc = xmlParseMemory(input, size);

    if (doc == nullptr) {
        fprintf(stderr, "Document not parsed successfully. \n");
        return NULL;
    }

    return doc;
}

std::vector<Sentence> *JishoParser::fetchSampleSentences(char *term) {
    std::string result = JishoParser::getHTTP(term);

    const char *input = result.c_str();

    TidyBuffer output = {0};
    TidyBuffer errbuf = {0};
    TidyDoc tdoc = tidyCreate();                     // Initialize "document"

    int ok = JishoParser::parseXML(input, &output, &errbuf, &tdoc);
    if (ok < 0) {
        printf("OUCH!\n");
    }

    xmlDoc *doc = getDoc((char *) output.bp, output.size - 1);
    Cache::getInstance()->cacheDoc(doc);

    JishoParser::cleanXMLBuffers(&output, &errbuf, &tdoc);


    xmlXPathContext *ctx = xmlXPathNewContext(doc);

    auto *contentSubtreePath = (xmlChar *) "//*[@id=\"secondary\"]/div/ul"; // unique
    auto *sentenceSubtreePathTemp = ".//li{0}/div[2]"; // xpath relative to parent

    auto *termPathTemp = ".//ul/li{0}";
    auto *furiganaTermPath = (xmlChar *) ".//span[@class='furigana']";
    auto *originalTermPath = (xmlChar *) ".//span[@class='unlinked']";

    xmlXPathObject *contentObject = nullptr;
    xmlNodeSet *contentSubtreeSet = XML::findSubtreeRootInDocByXPath(ctx, contentSubtreePath, contentObject);

    if (contentSubtreeSet == nullptr) {
        return nullptr;
    }

    xmlXPathObject *sentenceListObject = nullptr;
    xmlNodeSet *sentenceListSubtreeSet = XML::findSubtreeInSubtreeByXPath(ctx, *contentSubtreeSet->nodeTab,
                                                                          (xmlChar *) fmt::format(
                                                                                  sentenceSubtreePathTemp,
                                                                                  "").c_str(),
                                                                          sentenceListObject); // faster than searching from doc root - has context node cache set

    int sentenceNodeSize = (sentenceListSubtreeSet != nullptr) ? sentenceListSubtreeSet->nodeNr : 0;

    std::vector<Sentence> sentences{};

    for (int s = 0; s < sentenceNodeSize; ++s) { // for each found sentence
        auto *sentence = new Sentence();
        xmlXPathObject *sentenceObject = nullptr;

        std::string sIndex("[" + std::to_string(s + 1) + "]");

        xmlNodeSet *sentenceSubtreeSet = XML::findSubtreeInSubtreeByXPath(ctx, *contentSubtreeSet->nodeTab,
                                                                          (xmlChar *) fmt::format(
                                                                                  sentenceSubtreePathTemp,
                                                                                  sIndex).c_str(),
                                                                          sentenceObject);

        xmlXPathObject *termListObject = nullptr;
        xmlNodeSet *termListSubtreeSet = XML::findSubtreeInSubtreeByXPath(ctx, sentenceListSubtreeSet->nodeTab[s],
                                                                          (xmlChar *) fmt::format(termPathTemp,
                                                                                                  "").c_str(),
                                                                          termListObject);

        int termListNodeSize = (termListSubtreeSet != nullptr) ? termListSubtreeSet->nodeNr : 0;

        for (int t = 0; t < termListNodeSize; ++t) {
            std::string tIndex("[" + std::to_string(t + 1) + "]");
            xmlXPathObject *termPairObject = nullptr;

            xmlNodeSet *termPairSet = XML::findSubtreeInSubtreeByXPath(ctx, sentenceSubtreeSet->nodeTab[0],
                                                                       (xmlChar *) fmt::format(termPathTemp,
                                                                                               tIndex).c_str(),
                                                                       termPairObject); // grouping furigana+original

            xmlXPathObject *furiganaTermObject = nullptr;
            xmlXPathObject *originalTermObject = nullptr;

            xmlChar *furiganaTerm = XML::findTermsInSubtreeByXPath(ctx, termPairSet->nodeTab[0], furiganaTermPath,
                                                                   furiganaTermObject);
            xmlChar *originalTerm = XML::findTermsInSubtreeByXPath(ctx, termPairSet->nodeTab[0], originalTermPath,
                                                                   originalTermObject);

            Term *theTerm;
            if (furiganaTerm == nullptr) {
                theTerm = new Term((wchar_t *) XML::xmlCharToWString(originalTerm).c_str());
            } else {
                theTerm = new Term((wchar_t *) XML::xmlCharToWString(furiganaTerm).c_str(),
                                   (wchar_t *) XML::xmlCharToWString(originalTerm).c_str());
            }

            sentence->addTerm(theTerm);

            if (furiganaTerm != nullptr) {
                xmlFree(furiganaTerm);
            }
            if (furiganaTermObject != nullptr) {
                xmlXPathFreeObject(furiganaTermObject);
            }
            if (originalTerm != nullptr) {
                xmlFree(originalTerm);
            }
            if (originalTermObject != nullptr) {
                xmlXPathFreeObject(originalTermObject);
            }

            if (termPairObject != nullptr) {
                xmlXPathFreeObject(termPairObject);
            }
        }

        sentences.push_back(*sentence);

        if (termListObject != nullptr) {
            xmlXPathFreeObject(termListObject);
        }

        if (sentenceObject != nullptr) {
            xmlXPathFreeObject(sentenceObject);
        }
    }

    Cache::getInstance()->cacheSampleSentences(&sentences);

    if (sentenceListObject != nullptr) {
        xmlXPathFreeObject(sentenceListObject);
    }


    if (contentObject != nullptr) {
        xmlXPathFreeObject(contentObject);
    }

    xmlXPathFreeContext(ctx);

    xmlFreeDoc(doc);
    xmlCleanupParser();

    return Cache::getInstance()->getSampleSentences();
}