
#include <iostream>

#include <assert.h>
#include <yaml-cpp/yaml.h>

#include <lib/dict-parsers/JishoParser.h>
#include <lib/util/Prompt.h>
#include <lib/core/Cache.h>

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
    Cache::getInstance(); // init cache
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

    std::vector<Sentence> sampleSentences = *jp->fetchSampleSentences(searchTerm);

    Prompt::listSampleSentences(&sampleSentences);

    return 0;
}
