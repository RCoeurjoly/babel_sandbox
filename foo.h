#include <string>

namespace foo {
  int bar(int i, int j)
  {
    return i + j;
  }

  std::string baz(int k)
    {
      return std::to_string(k);
    }
  int factorial(int number) { return number <= 1 ? number : factorial(number - 1) * number; }
}
