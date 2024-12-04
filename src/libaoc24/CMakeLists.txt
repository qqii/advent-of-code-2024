include(GenerateExportHeader)


add_library(libaoc24 libaoc24.cpp)



add_library(advent_of_code_2024::libaoc24 ALIAS libaoc24)

target_link_libraries(libaoc24 PRIVATE advent_of_code_2024_options advent_of_code_2024_warnings)

target_include_directories(libaoc24 ${WARNING_GUARD} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                  $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

target_compile_features(libaoc24 PUBLIC cxx_std_20)

set_target_properties(
  libaoc24
  PROPERTIES VERSION ${PROJECT_VERSION}
             CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES)

generate_export_header(libaoc24 EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/include/advent_of_code_2024/libaoc24_export.hpp)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(libaoc24 PUBLIC LIBAOC24_STATIC_DEFINE)
endif()
