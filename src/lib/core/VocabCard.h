//
// Created by Óscar Valente on 26/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_VOCABCARD_H
#define NIHONGO_ANKI_TETSUDAI_VOCABCARD_H

#include <string>
#include <utility>

class VocabCard {
private:
    std::wstring vocabOriginal;
    std::wstring vocabFurigana;
    std::wstring vocabKana;
    std::string vocabEnglish;
    std::string wordType;
    std::wstring sentenceOriginal;
    std::wstring sentenceFurigana;
    std::wstring sentenceKana;
    std::string sentenceEnglish;
    std::wstring sentenceClozed;
public:
    VocabCard(std::wstring vo, std::wstring vf, std::wstring vk, std::string ve, std::string wt, std::wstring so,
              std::wstring sf, std::wstring sk, std::string se, std::wstring sc) {
        vocabOriginal = std::move(vo);
        vocabFurigana = std::move(vf);
        vocabKana = std::move(vk);
        vocabEnglish = std::move(ve);
        wordType = std::move(wt);
        sentenceOriginal = std::move(so);
        sentenceFurigana = std::move(sf);
        sentenceKana = std::move(sk);
        sentenceEnglish = std::move(se);
        sentenceClozed = std::move(sc);
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_VOCABCARD_H
