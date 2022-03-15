//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TERM_H
#define NIHONGO_ANKI_TETSUDAI_TERM_H

#include <vector>

class Term {
private:
    std::string furigana;
    std::string original;
public:
    Term(std::string f, std::string o) {
        furigana = f;
        original = o;
    }

    Term(std::string o) {
        original = o;
        furigana = "";
    }

    std::string getFurigana() {
        return this->furigana;
    }

    std::string getOriginal() {
        return this->original;
    }

    bool hasFurigana() {
        return furigana != "";
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_TERM_H
