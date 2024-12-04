include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


macro(advent_of_code_2024_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(advent_of_code_2024_setup_options)
  option(advent_of_code_2024_ENABLE_HARDENING "Enable hardening" ON)
  option(advent_of_code_2024_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    advent_of_code_2024_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    advent_of_code_2024_ENABLE_HARDENING
    OFF)

  advent_of_code_2024_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR advent_of_code_2024_PACKAGING_MAINTAINER_MODE)
    option(advent_of_code_2024_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(advent_of_code_2024_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(advent_of_code_2024_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(advent_of_code_2024_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(advent_of_code_2024_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(advent_of_code_2024_ENABLE_PCH "Enable precompiled headers" OFF)
    option(advent_of_code_2024_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(advent_of_code_2024_ENABLE_IPO "Enable IPO/LTO" ON)
    option(advent_of_code_2024_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(advent_of_code_2024_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(advent_of_code_2024_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(advent_of_code_2024_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(advent_of_code_2024_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(advent_of_code_2024_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(advent_of_code_2024_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(advent_of_code_2024_ENABLE_PCH "Enable precompiled headers" OFF)
    option(advent_of_code_2024_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      advent_of_code_2024_ENABLE_IPO
      advent_of_code_2024_WARNINGS_AS_ERRORS
      advent_of_code_2024_ENABLE_USER_LINKER
      advent_of_code_2024_ENABLE_SANITIZER_ADDRESS
      advent_of_code_2024_ENABLE_SANITIZER_LEAK
      advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED
      advent_of_code_2024_ENABLE_SANITIZER_THREAD
      advent_of_code_2024_ENABLE_SANITIZER_MEMORY
      advent_of_code_2024_ENABLE_UNITY_BUILD
      advent_of_code_2024_ENABLE_CLANG_TIDY
      advent_of_code_2024_ENABLE_CPPCHECK
      advent_of_code_2024_ENABLE_COVERAGE
      advent_of_code_2024_ENABLE_PCH
      advent_of_code_2024_ENABLE_CACHE)
  endif()

  advent_of_code_2024_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (advent_of_code_2024_ENABLE_SANITIZER_ADDRESS OR advent_of_code_2024_ENABLE_SANITIZER_THREAD OR advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(advent_of_code_2024_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(advent_of_code_2024_global_options)
  if(advent_of_code_2024_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    advent_of_code_2024_enable_ipo()
  endif()

  advent_of_code_2024_supports_sanitizers()

  if(advent_of_code_2024_ENABLE_HARDENING AND advent_of_code_2024_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED
       OR advent_of_code_2024_ENABLE_SANITIZER_ADDRESS
       OR advent_of_code_2024_ENABLE_SANITIZER_THREAD
       OR advent_of_code_2024_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${advent_of_code_2024_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED}")
    advent_of_code_2024_enable_hardening(advent_of_code_2024_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(advent_of_code_2024_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(advent_of_code_2024_warnings INTERFACE)
  add_library(advent_of_code_2024_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  advent_of_code_2024_set_project_warnings(
    advent_of_code_2024_warnings
    ${advent_of_code_2024_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(advent_of_code_2024_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    advent_of_code_2024_configure_linker(advent_of_code_2024_options)
  endif()

  include(cmake/Sanitizers.cmake)
  advent_of_code_2024_enable_sanitizers(
    advent_of_code_2024_options
    ${advent_of_code_2024_ENABLE_SANITIZER_ADDRESS}
    ${advent_of_code_2024_ENABLE_SANITIZER_LEAK}
    ${advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED}
    ${advent_of_code_2024_ENABLE_SANITIZER_THREAD}
    ${advent_of_code_2024_ENABLE_SANITIZER_MEMORY})

  set_target_properties(advent_of_code_2024_options PROPERTIES UNITY_BUILD ${advent_of_code_2024_ENABLE_UNITY_BUILD})

  if(advent_of_code_2024_ENABLE_PCH)
    target_precompile_headers(
      advent_of_code_2024_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(advent_of_code_2024_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    advent_of_code_2024_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(advent_of_code_2024_ENABLE_CLANG_TIDY)
    advent_of_code_2024_enable_clang_tidy(advent_of_code_2024_options ${advent_of_code_2024_WARNINGS_AS_ERRORS})
  endif()

  if(advent_of_code_2024_ENABLE_CPPCHECK)
    advent_of_code_2024_enable_cppcheck(${advent_of_code_2024_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(advent_of_code_2024_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    advent_of_code_2024_enable_coverage(advent_of_code_2024_options)
  endif()

  if(advent_of_code_2024_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(advent_of_code_2024_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(advent_of_code_2024_ENABLE_HARDENING AND NOT advent_of_code_2024_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR advent_of_code_2024_ENABLE_SANITIZER_UNDEFINED
       OR advent_of_code_2024_ENABLE_SANITIZER_ADDRESS
       OR advent_of_code_2024_ENABLE_SANITIZER_THREAD
       OR advent_of_code_2024_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    advent_of_code_2024_enable_hardening(advent_of_code_2024_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()
