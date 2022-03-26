//
// Created by Óscar Valente on 16/03/2022.
//

#ifndef NIHONGO_ANKI_TETSUDAI_SCREEN_H
#define NIHONGO_ANKI_TETSUDAI_SCREEN_H

#include <iostream>
#include <vector>
#include <ncurses.h>
#include <menu.h>
#include <wchar.h>

#include "lib/core/Sentence.h"
#include "Conversion.h"

#ifndef KEY_ENT
#define KEY_ENT 10
#endif
#ifndef KEY_ESCAPE
#define KEY_ESCAPE 27
#endif

class Screen {
public:
    static std::wstring convert(Sentence &s) {
        std::wstring str = s.toString();
        return (wchar_t *) str.c_str();
    }

    static int listSampleSentences(std::vector<Sentence> *ss) {
        initscr();
        noecho();
        cbreak();
        int yMax, xMax;
        getmaxyx(stdscr, yMax, xMax);

        // create a window for our input
        WINDOW *menuwin = newwin(60, xMax - 2, yMax - 50, 2);
        box(menuwin, 0, 0);
        refresh();
        wrefresh(menuwin);

        // makes it so we can use arrow keys
        keypad(menuwin, true);
        int key;
        int theChoice = -2;
        int highlight = 0;

        while (theChoice < -1) {
            for (int i = 0; i < ss->size(); i++) {
                if (i == highlight) {
                    wattron(menuwin, A_REVERSE);
                }
                mvwprintw(menuwin, i + 1, 1, "%ls", (wchar_t *) ss->at(i).toString().c_str());
                wattroff(menuwin, A_REVERSE);
            }

            key = wgetch(menuwin);
            switch (key) {
                case KEY_UP:
                    if (highlight > 0) {
                        highlight--;
                    }
                    break;
                case KEY_DOWN:
                    if (highlight < ss->size() - 1) {
                        highlight++;
                    }
                    break;
                case KEY_ENT:
                    theChoice = highlight;
                    break;
                case KEY_ESCAPE:
                    theChoice = -1;
                    break;
                default:
                    break;
            }
        }

        clrtoeol();
        refresh();
        endwin();

        return theChoice;
    }

};

#endif //NIHONGO_ANKI_TETSUDAI_SCREEN_H
