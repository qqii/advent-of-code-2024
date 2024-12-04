add_executable(aoc2024 main.cpp)

target_link_libraries(
  aoc2024
  PRIVATE advent_of_code_2024::advent_of_code_2024_options
          advent_of_code_2024::advent_of_code_2024_warnings)

target_link_system_libraries(
  aoc2024
  PRIVATE
          fmt::fmt)

target_include_directories(aoc2024 PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
