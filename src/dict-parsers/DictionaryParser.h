//
// Created by Óscar Valente on 13/02/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_DICTIONARYPARSER_H
#define NIHONGO_ANKI_TETSUDAI_DICTIONARYPARSER_H

#include <yaml-cpp/yaml.h>

#include <iostream>

struct DictionaryParser {
protected:
    const char *domain{};
    const char *api{};
public:
    DictionaryParser() = default;

    explicit DictionaryParser(DictionaryParser *d) {
        domain = d->domain;
        api = d->api;
    }

    DictionaryParser(const char *_domain, const char *_api) {
        domain = _domain;
        api = _api;
    }

    //virtual char *getTermSentence(char *term) = 0;

    const char *getDomain() {
        return this->domain;
    }

    void setDomain(const char *url) {
        this->domain = url;
    }

    const char *getAPI() {
        return this->api;
    }

    void setAPI(const char *api) {
        this->api = api;
    }

    std::string getURL() {
        std::string url(this->domain);
        url.append(this->api);
        return url;
    }

    void printProperties() {
        std::cout << this->domain << this->api;
    }
};

namespace YAML {
    template<>
    struct convert<DictionaryParser> {
        static Node encode(DictionaryParser &rhs) {
            Node node;
            node["domain"] = rhs.getDomain();
            node["api"] = rhs.getAPI();
            return node;
        }

        static bool decode(const Node &node, DictionaryParser &dictParser) {
            if (!node.IsMap()) {
                return false;
            }

            std::string domain = node["domain"].as<std::string>();
            std::string api = node["api"].as<std::string>();

            dictParser.setDomain(strcpy(new char[domain.length() + 1],
                                        domain.c_str()));
            dictParser.setAPI(strcpy(new char[api.length() + 1],
                                     api.c_str()));
            return true;
        }
    };
}

#endif //NIHONGO_ANKI_TETSUDAI_DICTIONARYPARSER_H
