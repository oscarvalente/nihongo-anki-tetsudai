//
// Created by Óscar Valente on 09/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_TYPECONVERSION_H
#define NIHONGO_ANKI_TETSUDAI_TYPECONVERSION_H

#include <fstream>

class FileIO {
public:
    static void writeToFile(char* filepath, char* input, int size) {
        std::ofstream fout(filepath);
        fout.write((char *)input, size);
        fout.flush();
        fout.close();
    }
};


#endif //NIHONGO_ANKI_TETSUDAI_TYPECONVERSION_H
