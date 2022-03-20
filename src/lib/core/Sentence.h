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

    Sentence(const Sentence &sentence) {
        terms = std::vector<Term>(sentence.terms);
    }

    explicit Sentence(std::vector<Term> *tv) {
        terms = *tv;
    }

    void addTerm(Term *term) {
        terms.push_back(*term);
    }

    std::vector<Term> *getTerms() {
        return &terms;
    }

    std::wstring toString() {
        std::wstring sentence;
        for (auto &term: terms) {
            if (term.hasFurigana()) {
                sentence.append(term.getOriginal() + L"[" + term.getFurigana() + L"]");
            } else {
                sentence.append(term.getOriginal());
            }
        }

        return sentence;
    }

    void println_BracketsStyle() {
        for (auto &term: terms) {
            if (term.hasFurigana()) {
                std::wcout << term.getOriginal() << L"[" << term.getFurigana() << L"]";
            } else {
                std::wcout << term.getOriginal();
            }
        }
        std::wcout << std::endl;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_SENTENCE_H
