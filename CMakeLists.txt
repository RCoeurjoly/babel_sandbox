cmake_minimum_required(VERSION 2.8)

# set the project name
project(Tutorial)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_BUILD_TYPE Debug)

message(STATUS "This is a test for the message")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

# add the executable
add_executable(test_foo ${PROJECT_SOURCE_DIR}/tests/test_foo.cpp)
add_test(NAME mytest
  COMMAND test_foo)
target_include_directories(test_foo PUBLIC
  "~/doctest/doctest"
  "/doctest/doctest"
  "~/babel_sandbox"
  "/babel_sandbox"
  "~/babel_sandbox/includes"
  "/babel_sandbox/includes"
  "/usr/include/c++"
  )

add_subdirectory(tests)
