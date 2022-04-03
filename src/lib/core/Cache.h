//
// Created by Óscar Valente on 16/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_CACHE_H
#define NIHONGO_ANKI_TETSUDAI_CACHE_H

#ifndef CACHE_XML_RECURSIVECOPY
#define CACHE_XML_RECURSIVECOPY 1 // must be != 0
#endif //CACHE_XML_RECURSIVECOPY


#include <vector>
#include <libxml/tree.h>

#include "Sentence.h"

class Cache {
private:
    static Cache *instance;
    xmlDoc doc;
    std::vector<Sentence> sampleSentences;
    std::wstring targetTerm;

    Cache() {}

    Cache(Cache const &) = delete;

    void operator=(Cache const &) = delete;

public:
    static Cache *getInstance();

    xmlDoc *cacheDoc(xmlDoc *d) {
        doc = *xmlCopyDoc(d, CACHE_XML_RECURSIVECOPY);
        return &doc;
    }

    xmlDoc *getDoc() {
        return &instance->doc;
    }

    std::vector<Sentence> *cacheSampleSentences(std::vector<Sentence> *ss) {
        sampleSentences = std::vector<Sentence>(*ss);
        return &sampleSentences;
    }

    std::vector<Sentence> *getSampleSentences() {
        return &instance->sampleSentences;
    }

    std::wstring *cacheTargetTerm(std::wstring t) {
        targetTerm = std::move(t);
        return &targetTerm;
    }

    void printDoc() {
        xmlChar *s;
        int size;
        xmlDocDumpMemory(&doc, &s, &size);
        std::cout << (char *) s << std::endl;
        xmlFree(s);
    }

    void printSentences() {
        int i = 0;
        for (auto s: instance->sampleSentences) {
            std::wcout << s.toString().c_str() << std::endl;
        }
    }

    void printInfo() {
        std::cout << "\t\033[4m\033[95m\033[41mCACHE STATE\033[m" << std::endl;
        std::cout << "\t\tTarget term:\n\n";
        std::wcout << targetTerm;
        std::cout << std::endl << std::endl;
        std::cout << "\t\tXML Doc:" << std::endl;
        std::cout << std::endl << std::endl;
        instance->printDoc();
        std::cout << std::endl << std::endl;
        std::cout << "\t\tSample Sentences (" << instance->sampleSentences.size() << "):\n\n" << std::endl;
        instance->printSentences();
        std::cout << std::endl;
    }
};


#endif //NIHONGO_ANKI_TETSUDAI_CACHE_H
