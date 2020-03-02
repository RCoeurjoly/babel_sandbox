cmake_minimum_required(VERSION 2.8)

# set the project name
project(Tutorial)

enable_testing()
# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_BUILD_TYPE Debug)

message(STATUS "This is a test for the message")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

# add the executable
add_executable(test_foo ${PROJECT_SOURCE_DIR}/tests/test_foo.cpp)
add_test(NAME unit_test COMMAND test_foo -s)
target_include_directories(test_foo PUBLIC
  ${PROJECT_SOURCE_DIR}
  ${PROJECT_SOURCE_DIR}/doctest/doctest
  #doctest/doctest
  ${PROJECT_SOURCE_DIR}/includes
  #includes
  "/usr/include/c++"
  )

add_subdirectory(tests)
