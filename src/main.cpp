#include <iostream>
#include <assert.h>

#include <yaml-cpp/yaml.h>
#include <dict-parsers/JishoParser.h>

using namespace std;

enum Dictionaries {
    Jisho
};

DictionaryParser *createDictionaryByName(Dictionaries name, DictionaryParser d) {
    switch (name) {
        case Dictionaries::Jisho:
            return new JishoParser(&d);
    }
}

int main() {
    string searchTerm;

    Dictionaries dictionaries;
    std::cout << "Type the word: ";
    getline(cin, searchTerm);
    YAML::Node config = YAML::LoadFile("./config.yaml");
    assert(config["_dicts"].IsSequence());
    //const std::list dicts = config["dicts"].as<std::list>();

    for (int i = 0; i < config["_dicts"].size(); ++i) {
        auto dictionary = config["_dicts"][i].as<std::string>();
        assert(config[dictionary].IsMap());
    }
    auto jName = config["_dicts"][0].as<std::string>();

    JishoParser *jp = (JishoParser *) createDictionaryByName(dictionaries, config[jName].as<DictionaryParser>());

    //printf("%s", jp->getDomain());
    jp->printURL();

    return 0;
}
