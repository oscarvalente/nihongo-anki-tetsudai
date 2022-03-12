//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_SENTENCE_H
#define NIHONGO_ANKI_TETSUDAI_SENTENCE_H

#include <vector>

#include "Term.h"

class Sentence {
private:
    std::vector<Term> terms;
public:
    Sentence(std::vector<Term> tv) {
        terms = tv;
    }

    void addTermFragment(Term term) {
        terms.push_back(term);
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_SENTENCE_H
