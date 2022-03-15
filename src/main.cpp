
#include <iostream>

#include <assert.h>
#include <yaml-cpp/yaml.h>
#include <fmt/core.h>

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

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "en_US.utf8");

    char* searchTerm = argv[1];
    Dictionaries dictionaries = Jisho;
    YAML::Node config = YAML::LoadFile("./config.yaml");
    assert(config["_dicts"].IsSequence());
    //const std::list dicts = config["dicts"].as<std::list>();

    for (int i = 0; i < config["_dicts"].size(); ++i) {
        auto dictionary = config["_dicts"][i].as<std::string>();
        assert(config[dictionary].IsMap());
    }
    auto jName = config["_dicts"][0].as<std::string>();

    JishoParser *jp = (JishoParser *) createDictionaryByName(dictionaries, config[jName].as<DictionaryParser>());

    jp->printProperties();

    jp->getTermInfo(searchTerm);

    return 0;
}
