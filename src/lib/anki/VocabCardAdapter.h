//
// Created by Óscar Valente on 26/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_VOCABCARDADAPTER_H
#define NIHONGO_ANKI_TETSUDAI_VOCABCARDADAPTER_H

#include "lib/core/VocabCard.h"
#include "lib/core/Sentence.h"
#include "lib/util/Lexic.h"

class VocabCardAdapter {
private:
    static std::wstring convertSentenceOriginal(Sentence *s) {
        std::wstring so;
        for (auto t: *(s->getTerms())) {
            so.append(t.getOriginal());
        }
        return so;
    }

    static std::wstring convertSentenceFurigana(Sentence *s) {
        std::wstring so;
        std::vector<Term> *terms = s->getTerms();
        for (int t = 0; t < terms->size(); ++t) {
            std::wstring firstChar = terms->at(t).getOriginal().substr(0, 1);
            if (t > 0 && terms->at(t).hasFurigana() && !Lexic::isKana(firstChar)) {
                so.append(L" ");
            }
            so.append(terms->at(t).getOriginal());
            if (terms->at(t).hasFurigana()) {
                so.append(L"[");
                so.append(terms->at(t).getFurigana());
                so.append(L"]");
            }
        }

        return so;
    }

    static std::wstring convertSentenceKana(Sentence *s) {
        std::wstring so;
        std::vector<Term> *terms = s->getTerms();
        for (int t = 0; t < terms->size(); ++t) {
            if (!terms->at(t).hasFurigana()) {
                so.append(terms->at(t).getOriginal());
            } else {
                so.append(terms->at(t).toKana());
            }
        }

        return so;
    }

public:
    void static convert(Sentence *s) {
        std::wstring sentenceOriginal = convertSentenceOriginal(s);
        std::wstring sentenceFurigana = convertSentenceFurigana(s);
        std::wstring sentenceKana = convertSentenceKana(s);
        std::wcout << L"original: " << sentenceOriginal << std::endl;
        std::wcout << L"furigana: " << sentenceFurigana << std::endl;
        std::wcout << L"kana: " << sentenceKana << std::endl;
//        std::wstring vocabOriginal;
//        std::wstring vocabFurigana;
//        std::wstring vocabKana;
//        std::string vocabEnglish;
//        std::string wordType;
//        std::wstring sentenceFurigana;
//        std::wstring sentenceKana;
//        std::string sentenceEnglish;
//        std::wstring sentenceClozed;
//        VocabCard *vocabCard = new VocabCard();
//        return *vocabCard;

    }
};

#endif //NIHONGO_ANKI_TETSUDAI_VOCABCARDADAPTER_H
