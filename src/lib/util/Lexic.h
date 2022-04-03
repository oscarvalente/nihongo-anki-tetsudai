//
// Created by Óscar Valente on 28/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_LEXIC_H
#define NIHONGO_ANKI_TETSUDAI_LEXIC_H

#include <string>

const std::wstring GOJUUON_HIRAGANA[76] = {L"あ", L"い", L"う", L"え", L"お",
                                           L"か", L"き", L"く", L"け", L"こ",
                                           L"が", L"ぎ", L"ぐ", L"げ", L"ご",
                                           L"さ", L"し", L"す", L"せ", L"そ",
                                           L"ざ", L"じ", L"ず", L"ぜ", L"ぞ",
                                           L"た", L"ち", L"つ", L"て", L"と",
                                           L"だ", L"ぢ", L"づ", L"で", L"ど",
                                           L"は", L"い", L"ふ", L"へ", L"ほ",
                                           L"ぱ", L"ぺ", L"ぷ", L"ぺ", L"ぽ",
                                           L"な", L"に", L"ぬ", L"ね", L"の",
                                           L"ま", L"み", L"む", L"め", L"も",
                                           L"ら", L"り", L"る", L"れ", L"ろ",
                                           L"や", L"ゆ", L"よ",
                                           L"わ", L"ん", L"を",
                                           L"ぁ", L"ぃ", L"ぅ", L"ぇ", L"ぉ",
                                           L"ゃ", L"ゅ", L"ょ",
                                           L"っ", L"一"};
const std::wstring GOJUUON_KATAKANA[78] = {L"ア", L"イ", L"ウ", L"エ", L"オ",
                                           L"カ", L"キ", L"ク", L"ケ", L"コ",
                                           L"ガ", L"ギ", L"グ", L"ゲ", L"ゴ",
                                           L"サ", L"シ", L"ス", L"セ", L"ソ",
                                           L"ザ", L"ジ", L"ズ", L"ゼ", L"ゾ",
                                           L"タ", L"チ", L"ツ", L"デ", L"ト",
                                           L"ダ", L"ヂ", L"ヅ", L"デ", L"ド",
                                           L"ハ", L"ヒ", L"フ", L"ヘ", L"ホ",
                                           L"パ", L"ピ", L"プ", L"ペ", L"ポ",
                                           L"ナ", L"ニ", L"ヌ", L"ネ", L"ノ",
                                           L"マ", L"ミ", L"ム", L"メ", L"モ",
                                           L"ラ", L"リ", L"ル", L"レ", L"ロ",
                                           L"ヤ", L"ユ", L"ヨ",
                                           L"ワ", L"ン", L"ヲ",
                                           L"ァ", L"ィ", L"ゥ", L"ェ", L"ォ",
                                           L"ャ", L"ュ", L"ョ",
                                           L"ヵ", L"ヶ", // sometimes used for counters
                                           L"ッ", L"ー"};

class Lexic {
public:
    static bool isKana(const std::wstring &k) {
        bool isHiragana =
                std::find(std::begin(GOJUUON_HIRAGANA), std::end(GOJUUON_HIRAGANA), k) != std::end(GOJUUON_HIRAGANA);
        bool isKatakana =
                std::find(std::begin(GOJUUON_KATAKANA), std::end(GOJUUON_KATAKANA), k) != std::end(GOJUUON_KATAKANA);
        return isHiragana || isKatakana;
    }
};

#endif //NIHONGO_ANKI_TETSUDAI_LEXIC_H
