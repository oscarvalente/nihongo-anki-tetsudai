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
        return &doc;
    }

    std::vector<Sentence> *cacheSampleSentences(std::vector<Sentence> *ss) {
        sampleSentences = std::vector<Sentence>(*ss);
        return &sampleSentences;
    }

    std::vector<Sentence> *getSampleSentences() {
        return &sampleSentences;
    }
};


#endif //NIHONGO_ANKI_TETSUDAI_CACHE_H
