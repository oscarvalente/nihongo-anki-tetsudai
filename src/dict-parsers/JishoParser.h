//
// Created by Óscar Valente on 13/02/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
#define NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H

#include "DictionaryParser.h"


class JishoParser: public DictionaryParser {
    public:
    char* getTermSentence(char*);
};


#endif //NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
