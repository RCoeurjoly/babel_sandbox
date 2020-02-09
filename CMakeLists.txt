cmake_minimum_required(VERSION 2.8)

# set the project name
project(Tutorial)
# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_BUILD_TYPE Debug)

# add the executable
add_executable(foo foo.cpp)

target_include_directories(foo PUBLIC
  "~/doctest/doctest"
  "/doctest/doctest"
  "~/babel_sandbox"
  "/babel_sandbox"
  "~/babel_sandbox/includes"
  "/babel_sandbox/includes"
  "/usr/include/c++"
  )
