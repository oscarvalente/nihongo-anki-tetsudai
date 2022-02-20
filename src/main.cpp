#include <iostream>
#include <assert.h>

#include <yaml-cpp/yaml.h>


using namespace std;

int main() {
    string searchTerm;
    std::cout << "Type the word: ";
    getline(cin, searchTerm);
    YAML::Node config = YAML::LoadFile("./config.yaml");
    assert(config["dicts"].Type() == YAML::NodeType::Sequence);
    //const std::list dicts = config["dicts"].as<std::list>();

    std::cout << "xD";
    //std::cout << "xD" << dicts;
    for (int i = 0; i < config["dicts"].size(); ++i) {
        std::cout << config["dicts"][i];
    }


    return 0;
}
