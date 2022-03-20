//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TERM_H
#define NIHONGO_ANKI_TETSUDAI_TERM_H

#include <vector>
#include <string>
#include <iostream>

class Term {
private:
    std::wstring furigana;
    std::wstring original;
public:
    Term(std::wstring f, std::wstring o) {
        furigana = f;
        original = o;
    }

    Term(std::wstring o) {
        original = o;
        furigana = L"";
    }

    Term(const Term &term) {
        furigana = std::wstring(term.furigana);
        original = std::wstring(term.original);
    }

    std::wstring getFurigana() {
        return this->furigana;
    }

    std::wstring getOriginal() {
        return this->original;
    }

    bool hasFurigana() {
        return furigana != L"";
    }

    void print() {
        std::wcout << original << "[" << furigana << "]" << std::endl;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_TERM_H
