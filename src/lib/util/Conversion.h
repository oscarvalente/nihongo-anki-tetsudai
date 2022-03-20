//
// Created by Óscar Valente on 19/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_CONVERSION_H
#define NIHONGO_ANKI_TETSUDAI_CONVERSION_H

#include <vector>

class Conversion {
public:
    template<typename T>
    static T vectorToArray(std::vector<T> *v) {
        copy(v->begin(), v->end(),
             std::ostream_iterator<T>(std::cout, "; "));

        return v->data();
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_CONVERSION_H
