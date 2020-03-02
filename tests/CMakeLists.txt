project(ageCalculator)

if(TARGET GTest::GTest)
  add_executable(ageCalculator ${PROJECT_SOURCE_DIR}/features/step_definitions/ageCalculator)
  # set(GMOCK_ROOT "${CMAKE_CURRENT_BINARY_DIR}/gmock")
  # find_package(GMock REQUIRED)
  target_link_libraries(ageCalculator PRIVATE cucumber-cpp GTest::GTest)
  add_test(NAME ageCalculatorTest COMMAND ${PROJECT_SOURCE_DIR}/ageTest.sh)
endif()
