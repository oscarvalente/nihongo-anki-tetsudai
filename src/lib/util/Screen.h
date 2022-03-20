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

class Screen {
public:
    static void print_in_middle(WINDOW *win, int starty, int startx, int width, wchar_t *string, chtype color) {
        int length, x, y;
        float temp;
        if (win == NULL)
            win = stdscr;
        getyx(win, y, x);
        if (startx != 0)
            x = startx;
        if (starty != 0)
            y = starty;
        if (width == 0)
            width = 400;
        length = wcslen(string);
        temp = (width - length) / 2;
        x = startx + (int) temp;
        wattron(win, color);
        mvwprintw(win, y, x, "%ls", string);
        wattroff(win, color);
        refresh();
    }

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
        int choice;
        int highlight = 0;

        while (true) {
            for (int i = 0; i < ss->size(); i++) {
                if (i == highlight) {
                    wattron(menuwin, A_REVERSE);
                }
                mvwprintw(menuwin, i + 1, 1, "%ls", (wchar_t *) ss->at(i).toString().c_str());
                wattroff(menuwin, A_REVERSE);
            }
            choice = wgetch(menuwin);
            switch (choice) {
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
                default:
                    break;
            }
            if (choice == 21) break;
        }

        getch();
        endwin();

        return 0;
    }

};

#endif //NIHONGO_ANKI_TETSUDAI_SCREEN_H
