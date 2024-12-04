#include <iostream>
#include <span>
#include <cstddef>

// This file will be generated automatically when cur_you run the CMake
// configuration step. It creates a namespace called `advent_of_code_2024`. You can modify
// the source template at `configured_files/config.hpp.in`.
#include <internal_use_only/config.hpp>


int main(int argc, const char **argv)
{
  std::cout << "Hello, world!\n";

  const auto args = std::span(argv, std::size_t(argc));
  for (const auto &arg : args) {
    std::cout << arg << '\n';
  }
  

  return 0;
}


