//
// Created by Óscar Valente on 13/02/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
#define NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H

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

struct JishoParser : DictionaryParser {
public:
    JishoParser() : DictionaryParser() {
    }

    explicit JishoParser(DictionaryParser *d) : DictionaryParser(d) {
    }

    JishoParser(char *_url, char *_api) : DictionaryParser(_url, _api) {
        domain = _url;
        api = _api;
    }

    std::vector<Sentence> *fetchSampleSentences(char *);

    std::string getSearchURL(char *term) {
        std::string url(this->getURL());
        return fmt::format(url, term);
    }

    bool operator==(JishoParser &rhs) {
        return this->getDomain() == rhs.getDomain() && this->getAPI() == rhs.getAPI();
    }

    static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp) {
        ((std::string *) userp)->append((char *) contents, size * nmemb);
        return size * nmemb;
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
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
            res = curl_easy_perform(curl);
            curl_easy_cleanup(curl);
        }

        return readBuffer;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
