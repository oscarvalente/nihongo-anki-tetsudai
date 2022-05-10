
#include <iostream>
#include <string>
#include <cstdio>
#include <cstdlib>
#include <locale.h>

#include <assert.h>
#include <yaml-cpp/yaml.h>

#define NCURSES_WIDECHAR 1

#include <ncursesw/curses.h>

#include <lib/dict-parsers/JishoParser.h>
#include <lib/dict-parsers/TanoshiiJapanese.h>
#include <lib/util/Screen.h>
#include <lib/util/Conversion.h>
#include <lib/util/Lexic.h>
#include <lib/core/Cache.h>
#include <lib/anki/VocabCardAdapter.h>

using namespace std;

enum Dictionaries {
    Jisho,
    Tanoshiijapanese
};

DictionaryParser *createDictionaryByName(Dictionaries name, DictionaryParser d) {
    switch (name) {
        case Dictionaries::Jisho:
            return new JishoParser(&d);
        case Dictionaries::Tanoshiijapanese:
            return new TanoshiiJapanese(&d);
    }
}

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "");
    std::wcout.imbue(std::locale(""));

    Cache::getInstance(); // init cache
    char *searchTerm = argv[1];
    Cache::getInstance()->cacheTargetTerm((wchar_t *) Conversion::charToWString(searchTerm).c_str());
    Dictionaries dictionaries = Jisho;
    YAML::Node config = YAML::LoadFile("./config.yaml");
    assert(config["_dicts"].IsSequence());
    //const std::list dicts = config["dicts"].as<std::list>();

    for (int i = 0; i < config["_dicts"].size(); ++i) {
        auto dictionary = config["_dicts"][i].as<std::string>();
        assert(config[dictionary].IsMap());
    }
    auto jName = config["_dicts"][0].as<std::string>(); // using tanoshii - [1]

    JishoParser *jp = (JishoParser *) createDictionaryByName(dictionaries, config[jName].as<DictionaryParser>());

    jp->printProperties();

    std::vector<Sentence> *sampleSentences = jp->fetchSampleSentences(searchTerm);

//    Cache::getInstance()->printInfo();

    VocabCardAdapter::convert(&sampleSentences->at(0));

//    int choice = Screen::listSampleSentences(sampleSentences);

//    std::cout << "choice: " <<  choice;


    return 0;
}
