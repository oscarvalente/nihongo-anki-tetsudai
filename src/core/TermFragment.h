//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TERMFRAGMENT_H
#define NIHONGO_ANKI_TETSUDAI_TERMFRAGMENT_H

class TermFragment {
private:
    char* furigana;
    char* original;
public:
    TermFragment(char* f, char* o) {
        furigana = f;
        original = o;
    }
    TermFragment(char* o) {
        original = o;
    }

    bool hasFurigana() {
        return furigana == nullptr;
    }
};


#endif //NIHONGO_ANKI_TETSUDAI_TERMFRAGMENT_H
