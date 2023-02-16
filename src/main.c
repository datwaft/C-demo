#include "foo.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  for (int c = 'A'; c < 'A' + 26; c++) {
    // Colors
    // 31 = RED, 36 = CYAN
    unsigned int color = arc4random_uniform(36 - 31 + 1) + 31;
    // Styles
    unsigned int style = arc4random_uniform(7 + 1);
    printf("\x1b[%d;%dm"
           "%c"
           "\x1b[0m",
           style, color, c);
  }
  putchar('\n');
  putchar('\n');

  int x = foo(3);
  printf("%d\n", x);

  return 0;
}
