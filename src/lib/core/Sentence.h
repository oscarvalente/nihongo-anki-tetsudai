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

    std::string toString() {
        std::string sentence;
        for (auto &term: terms) {
            if (term.hasFurigana()) {
                sentence.append(term.getOriginal() + "[" + term.getFurigana() + "]");
            } else {
                sentence.append(term.getOriginal() + "");
            }
        }
        return sentence;
    }

    void println_BracketsStyle() {
        for (auto &term: terms) {
            if (term.hasFurigana()) {
                std::cout << term.getOriginal() << "[" << term.getFurigana() << "]";
            } else {
                std::cout << term.getOriginal() << "";
            }
        }
        std::cout << std::endl;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_SENTENCE_H
