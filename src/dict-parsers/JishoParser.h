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

    wchar_t *getTermInfo(char *);

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

    int parseXML(const char *input, TidyBuffer *output, TidyBuffer *errbuf, TidyDoc *tdoc) {
        int rc = -1;
        Bool ok;

        ok = tidyOptSetBool(*tdoc, TidyXmlOut, yes);  // Convert to XML
        if (ok)
            rc = tidySetErrorBuffer(*tdoc, errbuf);      // Capture diagnostics
        if (rc >= 0)
            rc = tidyParseString(*tdoc, input);           // Parse the input
        if (rc >= 0)
            rc = tidyCleanAndRepair(*tdoc);               // Tidy it up!
        if (rc >= 0)
            rc = tidyRunDiagnostics(*tdoc);               // Kvetch
        if (rc > 1)                                    // If error, force output.
            rc = (tidyOptSetBool(*tdoc, TidyForceOutput, yes) ? rc : -1);
        if (rc >= 0)
            rc = tidySaveBuffer(*tdoc, output);          // Pretty Print

        if (rc >= 0) {
            if (rc > 0)
                printf("\nDiagnostics:\n\n%s", (*errbuf).bp);
//            printf("\nAnd here is the result:\n\n%s", (*output).bp);
        } else
            printf("A severe error (%d) occurred.\n", rc);
        return rc;
    }

    void cleanXMLBuffers(TidyBuffer *output, TidyBuffer *errbuf, TidyDoc *tdoc) {
        tidyBufFree(output);
        tidyBufFree(errbuf);
        tidyRelease(*tdoc);
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_JISHOPARSER_H
