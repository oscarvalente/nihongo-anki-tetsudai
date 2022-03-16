//
// Created by Óscar Valente on 16/03/2022.
//

#include "Cache.h"

Cache* Cache::instance= nullptr;

Cache *Cache::getInstance() {
    if (instance == nullptr) {
        instance = new Cache();
    }
    return instance;
}