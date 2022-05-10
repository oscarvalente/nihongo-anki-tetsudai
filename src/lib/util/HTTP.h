//
// Created by Óscar Valente on 29/04/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_HTTP_H
#define NIHONGO_ANKI_TETSUDAI_HTTP_H

class HTTP {
public:
    static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp) {
        ((std::string *) userp)->append((char *) contents, size * nmemb);
        return size * nmemb;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_HTTP_H
