add_executable(intro main.cpp)

target_link_libraries(
  intro
  PRIVATE advent_of_code_2024::advent_of_code_2024_options
          advent_of_code_2024::advent_of_code_2024_warnings)

target_link_system_libraries(
  intro
  PRIVATE
          fmt::fmt)

target_include_directories(intro PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
