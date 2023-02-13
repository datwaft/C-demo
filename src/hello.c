#include <stdio.h>
#include <stdlib.h>

int main() {
  srand(42);

  for (int c = 'A'; c < 'A' + 26; c++) {
    // Colors
    // 31 = RED, 36 = CYAN
    int color = rand() % (31 - 36 + 1) + 31;
    // Styles
    int style = rand() % (7 + 1);
    printf("\x1b[%d;%dm"
           "%c"
           "\x1b[0m",
           style, color, c);
  }
  putchar('\n');

  return 0;
}
