//
// Created by Óscar Valente on 12/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TERM_H
#define NIHONGO_ANKI_TETSUDAI_TERM_H

#include <vector>

#include "TermFragment.h"

class Term {
private:
    std::vector<TermFragment> fragments;
public:
    Term(std::vector<TermFragment> fv) {
        fragments = fv;
    }

    void addTermFragment(TermFragment termFragment) {
        fragments.push_back(termFragment);
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_TERM_H
