cmake_minimum_required(VERSION 2.8)

# set the project name
project(emacs_docker_gdb_issue)
# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_BUILD_TYPE Debug)

# add the executable
add_executable(infinite_loop infinite_loop.cpp)

target_include_directories(infinite_loop PUBLIC
  "/usr/include/c++"
  )
