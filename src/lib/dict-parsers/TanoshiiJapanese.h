//
// Created by Óscar Valente on 29/04/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TANOSHIIJAPANESE_H
#define NIHONGO_ANKI_TETSUDAI_TANOSHIIJAPANESE_H

#include "DictionaryParser.h"

#include <memory>
#include <fmt/core.h>
#include <curl/curl.h>
#include <curl/easy.h>
#include <tidy.h>
#include <tidybuffio.h>
#include <cstdio>
#include <cerrno>

#include "lib/core/Sentence.h"
#include "lib/util/HTTP.h"

struct TanoshiiJapanese : DictionaryParser {
public:
    TanoshiiJapanese() : DictionaryParser() {
    }

    explicit TanoshiiJapanese(DictionaryParser *d) : DictionaryParser(d) {
    }

    TanoshiiJapanese(char *_url, char *_api) : DictionaryParser(_url, _api) {
        domain = _url;
        api = _api;
    }

    std::vector<Sentence> *fetchSampleSentences(char *);

    std::string getSearchURL(char *term) {
        std::string url(this->getURL());
        return fmt::format(url, term);
    }

    bool operator==(TanoshiiJapanese &rhs) {
        return this->getDomain() == rhs.getDomain() && this->getAPI() == rhs.getAPI();
    }

    std::string getHTTP(const char *term) {
        CURL *curl;
        CURLcode res;
        std::string readBuffer;
        curl = curl_easy_init();
        if (curl) {
            char *encodedSearchTerm = curl_easy_escape(curl, term, strlen(term));
            curl_easy_setopt(curl, CURLOPT_URL, this->getSearchURL(encodedSearchTerm).c_str());
            curl_easy_setopt(curl, CURLOPT_TIMEOUT, 4L);
            curl_easy_setopt(curl, CURLOPT_HTTPGET, 1);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, HTTP::WriteCallback);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
            res = curl_easy_perform(curl);
            curl_easy_cleanup(curl);
        }

        return readBuffer;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_TANOSHIIJAPANESE_H
