#ifndef SAMPLE_LIBRARY_HPP
#define SAMPLE_LIBRARY_HPP

#include <advent_of_code_2024/sample_library_export.hpp>

[[nodiscard]] SAMPLE_LIBRARY_EXPORT int factorial(int) noexcept;

[[nodiscard]] constexpr int factorial_constexpr(int input) noexcept
{
  if (input == 0) { return 1; }

  return input * factorial_constexpr(input - 1);
}

#endif
