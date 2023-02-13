#include "../src/foo.h"
#include <criterion/criterion.h>

Test(foo_tests, execution) {
  int result = foo(1);
  cr_expect(result == 6, "foo should return 1.");
}
