#pragma once

#include <advent_of_code_2024/libaoc24_export.hpp>

[[nodiscard]] LIBAOC24_EXPORT int factorial(int) noexcept;

[[nodiscard]] constexpr int factorial_constexpr(int input) noexcept
{
  if (input == 0) { return 1; }

  return input * factorial_constexpr(input - 1);
}
