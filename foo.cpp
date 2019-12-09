#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <iostream>
#include <string>
#include "doctest.h"
#include "my_library.h"
#include "foo.h"

TEST_CASE("testing the factorial function") {
  std::string loo = "lol";
  CHECK(foo::factorial(0) == 1);
  CHECK(foo::factorial(1) == 1);
  CHECK(foo::factorial(2) == 2);
  CHECK(factorial_of_3() == 6);
  CHECK(factorial_of_4() == 24);
  CHECK(foo::factorial(10) == 3628800);
}
