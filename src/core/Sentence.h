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
    Sentence() {
        terms = std::vector<Term>{};
    }

    Sentence(std::vector<Term> tv) {
        terms = tv;
    }

    void addTerm(Term *term) {
        terms.push_back(*term);
    }

    void println_BracketsStyle() {
        for (int t = 0; t < terms.size(); ++t) {
            if (terms[t].hasFurigana()) {
                std::cout << terms[t].getOriginal() << "[" << terms[t].getFurigana() << "]";
            } else {
                std::cout << terms[t].getOriginal() << "";
            }
        }
        std::cout << std::endl;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_SENTENCE_H
