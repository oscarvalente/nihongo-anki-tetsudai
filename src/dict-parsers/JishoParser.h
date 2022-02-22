//
// Created by Óscar Valente on 13/02/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
#define NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H

#include "DictionaryParser.h"

#include <memory>


struct JishoParser : DictionaryParser {
public:
    JishoParser() : DictionaryParser() {
    }

    JishoParser(DictionaryParser *d) : DictionaryParser(d) {
    }

    JishoParser(char *_url, char *_api) : DictionaryParser(_url, _api) {
        domain = _url;
        api = _api;
    }

    char *getTermSentence(char *);

    bool operator==(JishoParser &rhs) {
        return this->getDomain() == rhs.getDomain() && this->getAPI() == rhs.getAPI();
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
