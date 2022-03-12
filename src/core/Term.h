//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TERM_H
#define NIHONGO_ANKI_TETSUDAI_TERM_H

#include <vector>

class Term {
private:
    char *furigana;
    char *original;
public:
    Term(char *f, char *o) {
        furigana = f;
        original = o;
    }

    Term(char *o) {
        original = o;
    }

    bool hasFurigana() {
        return furigana == nullptr;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_TERM_H
