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

    void printDoc() {
        xmlChar *s;
        int size;
        xmlDocDumpMemory(&doc, &s, &size);
        std::cout << (char *) s << std::endl;
        xmlFree(s);
    }

    void printSentences() {
        for (auto s: instance->sampleSentences) {
            std::wcout << s.toString() << std::endl;
        }
    }

    void printInfo() {
        std::cout << "\tCache state" << std::endl;
        std::cout << "\t\tXML Doc:\n\n";
        instance->printDoc();
        std::cout << "\n\n\n";
        std::cout << "\t\tSample Sentences (" << instance->sampleSentences.size() << "):\n\n" << std::endl;
        instance->printSentences();
    }
};


#endif //NIHONGO_ANKI_TETSUDAI_CACHE_H
