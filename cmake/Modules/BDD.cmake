option(BUILD_SHARED_LIBS        "Generate shared libraries" OFF)
option(CUKE_USE_STATIC_BOOST    "Statically link Boost (except boost::test)" ${WIN32})
option(CUKE_USE_STATIC_GTEST    "Statically link Google Test" ON)
option(CUKE_ENABLE_BOOST_TEST   "Enable Boost.Test framework" ON)
option(CUKE_ENABLE_EXAMPLES     "Build examples" OFF)
option(CUKE_ENABLE_GTEST        "Enable Google Test framework" ON)
option(CUKE_ENABLE_QT           "Enable Qt framework" ON)
option(CUKE_TESTS_E2E           "Enable end-to-end tests" ON)
option(CUKE_TESTS_UNIT          "Enable unit tests" ON)
option(CUKE_TESTS_VALGRIND      "Enable tests within Valgrind" OFF)
set(GMOCK_SRC_DIR "" CACHE STRING "Google Mock framework sources path (otherwise downloaded)")
set(GMOCK_VER "1.7.0" CACHE STRING "Google Mock framework version to be used")

set(Boost_USE_STATIC_RUNTIME OFF)
set(CUKE_CORE_BOOST_LIBS thread system regex date_time program_options filesystem)
if(CUKE_ENABLE_BOOST_TEST)
    # "An external test runner utility is required to link with dynamic library" (Boost User's Guide)
    set(Boost_USE_STATIC_LIBS OFF)
    set(CMAKE_CXX_FLAGS "-DBOOST_TEST_DYN_LINK ${CMAKE_CXX_FLAGS}")
    find_package(Boost ${BOOST_MIN_VERSION} COMPONENTS unit_test_framework)
endif()

if(CUKE_USE_STATIC_BOOST)
    set(Boost_USE_STATIC_LIBS ON)
    find_package(Boost ${BOOST_MIN_VERSION} COMPONENTS ${CUKE_CORE_BOOST_LIBS} REQUIRED)
else()
    set(CMAKE_CXX_FLAGS "-DBOOST_ALL_DYN_LINK ${CMAKE_CXX_FLAGS}")
    set(Boost_USE_STATIC_LIBS OFF)
    find_package(Boost ${BOOST_MIN_VERSION} COMPONENTS ${CUKE_CORE_BOOST_LIBS} REQUIRED)
endif()

# Create import targets for CMake versions older than 3.5 (actually older FindBoost.cmake)
if(Boost_USE_STATIC_LIBS)
    set(LIBRARY_TYPE STATIC)
else()
    # Just because we don't ask for static doesn't mean we're not getting static
    set(LIBRARY_TYPE UNKNOWN)
endif()
if(Boost_INCLUDE_DIRS AND NOT TARGET Boost::boost)
    add_library(Boost::boost INTERFACE IMPORTED)
    set_target_properties(Boost::boost PROPERTIES
        "INTERFACE_INCLUDE_DIRECTORIES" "${Boost_INCLUDE_DIRS}")
endif()
if(Boost_THREAD_LIBRARY AND NOT TARGET Boost::thread)
    find_package(Threads REQUIRED)
    add_library(Boost::thread ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::thread PROPERTIES
        "IMPORTED_LOCATION" "${Boost_THREAD_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Threads::Threads;Boost::boost"
    )
endif()
if(Boost_SYSTEM_LIBRARY AND NOT TARGET Boost::system)
    add_library(Boost::system ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::system PROPERTIES
        "IMPORTED_LOCATION" "${Boost_SYSTEM_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::boost"
    )
    if(Boost_USE_STATIC_LIBS)
        set_target_properties(Boost::system PROPERTIES
            "COMPILE_DEFINITIONS" BOOST_ERROR_CODE_HEADER_ONLY=1
        )
    endif()
endif()
if(Boost_FILESYSTEM_LIBRARY AND NOT TARGET Boost::filesystem)
    add_library(Boost::filesystem ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::filesystem PROPERTIES
        "IMPORTED_LOCATION" "${Boost_FILESYSTEM_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::system;Boost::boost"
    )
endif()
if(Boost_REGEX_LIBRARY AND NOT TARGET Boost::regex)
    add_library(Boost::regex ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::regex PROPERTIES
        "IMPORTED_LOCATION" "${Boost_REGEX_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::boost"
    )
endif()
if(Boost_DATE_TIME_LIBRARY AND NOT TARGET Boost::date_time)
    add_library(Boost::date_time ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::date_time PROPERTIES
        "IMPORTED_LOCATION" "${Boost_DATE_TIME_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::boost"
    )
endif()
if(Boost_PROGRAM_OPTIONS_LIBRARY AND NOT TARGET Boost::program_options)
    add_library(Boost::program_options ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::program_options PROPERTIES
        "IMPORTED_LOCATION" "${Boost_PROGRAM_OPTIONS_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::boost"
    )
endif()
if(Boost_UNIT_TEST_FRAMEWORK_LIBRARY AND NOT TARGET Boost::unit_test_framework)
    add_library(Boost::unit_test_framework ${LIBRARY_TYPE} IMPORTED)
    set_target_properties(Boost::unit_test_framework PROPERTIES
        "IMPORTED_LOCATION" "${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}"
        "INTERFACE_LINK_LIBRARIES" "Boost::boost"
    )
endif()

#
# GTest
#

if(CUKE_ENABLE_GTEST)
    set(GTEST_USE_STATIC_LIBS ${CUKE_USE_STATIC_GTEST})
    if(NOT GMOCK_ROOT)
        set(GMOCK_ROOT "${CMAKE_CURRENT_BINARY_DIR}/gmock")
    endif()
    find_package(GMock REQUIRED)
endif()

#
# Qt
#

if(CUKE_ENABLE_QT)
    find_package(Qt5Core)
    find_package(Qt5Gui)
    find_package(Qt5Widgets)
    find_package(Qt5Test)

    if(Qt5Core_FOUND AND Qt5Gui_FOUND AND Qt5Widgets_FOUND AND Qt5Test_FOUND)
        message(STATUS "Found Qt version: ${Qt5Core_VERSION_STRING}")
        if(NOT Qt5Core_VERSION_STRING VERSION_LESS 5.7 AND (NOT DEFINED CMAKE_CXX_STANDARD OR NOT CMAKE_CXX_STANDARD STREQUAL 98))
            message(STATUS "C++11 is needed from Qt version 5.7.0, building with c++11 enabled")
            set(CMAKE_CXX_STANDARD 11)
        endif()
        add_library(Qt::Core    INTERFACE IMPORTED)
        add_library(Qt::Gui     INTERFACE IMPORTED)
        add_library(Qt::Widgets INTERFACE IMPORTED)
        add_library(Qt::Test    INTERFACE IMPORTED)
        set_target_properties(Qt::Core    PROPERTIES INTERFACE_LINK_LIBRARIES Qt5::Core   )
        set_target_properties(Qt::Gui     PROPERTIES INTERFACE_LINK_LIBRARIES Qt5::Gui    )
        set_target_properties(Qt::Widgets PROPERTIES INTERFACE_LINK_LIBRARIES Qt5::Widgets)
        set_target_properties(Qt::Test    PROPERTIES INTERFACE_LINK_LIBRARIES Qt5::Test   )
    else()
        find_package(Qt4 COMPONENTS QtCore QtGui QtTest)
        if(QT4_FOUND)
            add_library(Qt::Core    INTERFACE IMPORTED)
            add_library(Qt::Gui     INTERFACE IMPORTED)
            add_library(Qt::Widgets INTERFACE IMPORTED)
            add_library(Qt::Test    INTERFACE IMPORTED)
            set_target_properties(Qt::Core    PROPERTIES INTERFACE_LINK_LIBRARIES Qt4::QtCore)
            set_target_properties(Qt::Gui     PROPERTIES INTERFACE_LINK_LIBRARIES Qt4::QtGui )
            set_target_properties(Qt::Widgets PROPERTIES INTERFACE_LINK_LIBRARIES Qt4::QtGui )
            set_target_properties(Qt::Test    PROPERTIES INTERFACE_LINK_LIBRARIES Qt4::QtTest)
            include(${QT_USE_FILE})
        endif()
    endif()
endif()

#
# Valgrind
#

if(CUKE_TESTS_VALGRIND)
    find_package(Valgrind REQUIRED)
    set(VALGRIND_ARGS --error-exitcode=2 --leak-check=full --undef-value-errors=no)
    if(NOT VALGRIND_VERSION_STRING VERSION_LESS 3.9)
        # Valgrind 3.9 no longer shows all leaks unless asked to
        list(APPEND VALGRIND_ARGS --show-leak-kinds=all)
    endif()
    function(add_test name)
        if(NOT name STREQUAL "NAME")
            _add_test(${VALGRIND_EXECUTABLE} ${VALGRIND_ARGS} ${ARGV})
            return()
        endif()

        set(TEST_ARGS ${ARGV})
        list(FIND TEST_ARGS COMMAND COMMAND_IDX)
        if(COMMAND_IDX EQUAL -1)
            message(AUTHOR_WARNING "Weird command-line given to add_test(), not injecting valgrind")
            _add_test(${ARGV})
            return()
        endif()

        # We want to operate on the COMMAND, not the 'COMMAND' keyword preceding it
        math(EXPR COMMAND_IDX "${COMMAND_IDX} + 1")

        # Keep add_test() behaviour of replacing COMMANDs, when executable targets, with their output files
        list(GET TEST_ARGS ${COMMAND_IDX} COMMAND)
        if(TARGET ${COMMAND})
            get_target_property(COMMAND_TYPE ${COMMAND} TYPE)
            if(COMMAND_TYPE STREQUAL "EXECUTABLE")
                # Inserting first, removing the original only after that, because inserting to the end of the list doesn't work
                math(EXPR ORIG_COMMAND_IDX "${COMMAND_IDX} + 1")
                list(INSERT TEST_ARGS ${COMMAND_IDX} "$<TARGET_FILE:${COMMAND}>")
                list(REMOVE_AT TEST_ARGS ${ORIG_COMMAND_IDX})
            endif()
        endif()

        # Insert the valgrind command line, before the command to execute
        list(INSERT TEST_ARGS ${COMMAND_IDX} ${VALGRIND_EXECUTABLE} ${VALGRIND_ARGS})

        _add_test(${TEST_ARGS})
    endfunction()
endif()

#
# Cucumber-Cpp
#

set(CUKE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
add_subdirectory(3rdparty/json_spirit)
add_subdirectory(src)

#
# Tests
#

if(CUKE_TESTS_UNIT)
    enable_testing()
    add_subdirectory(tests)
else()
    message(STATUS "Skipping unit tests")
endif()

if(NOT CUKE_TESTS_E2E)
    message(STATUS "Skipping end-to-end tests")
else()
    find_program(CUCUMBER_RUBY cucumber)
    if(CUCUMBER_RUBY)
        message(STATUS "Found Cucumber")
        set(CUKE_FEATURES_DIR "${CMAKE_SOURCE_DIR}/features")
        set(CUKE_FEATURES_TMP "${CMAKE_BINARY_DIR}/tmp")
        set(CUKE_TEST_FEATURES_DIR "${CUKE_FEATURES_TMP}/test_features")
        set(CUKE_DYNAMIC_CPP_STEPS "${CUKE_TEST_FEATURES_DIR}/step_definitions/cpp_steps.cpp")
        string(REPLACE "/tmp" "${CMAKE_FILES_DIRECTORY}/e2e-steps.dir/tmp" CUKE_DYNAMIC_CPP_STEPS_OBJ "${CUKE_DYNAMIC_CPP_STEPS}${CMAKE_CXX_OUTPUT_EXTENSION}")

        add_executable(e2e-steps EXCLUDE_FROM_ALL ${CUKE_DYNAMIC_CPP_STEPS})
        # Mark this file as generated so it isn't required at CMake generation time (it is necessary when the target gets built though)
        set_source_files_properties(${CUKE_DYNAMIC_CPP_STEPS} PROPERTIES GENERATED TRUE)
        target_link_libraries(e2e-steps PRIVATE cucumber-cpp)
        #Boost test lib required for boost specific scenario "Predicate Message"
        if(TARGET Boost::unit_test_framework)
            target_link_libraries(e2e-steps PRIVATE Boost::unit_test_framework)
        else()
            set(CUKE_E2E_TAGS "--tags ~@boost")
        endif()

        set(CUKE_COMPILE_DYNAMIC_CPP_STEPS '"${CMAKE_COMMAND}" --build "${CMAKE_BINARY_DIR}" --target e2e-steps')

        function(add_feature_target TARGET_NAME)
            # Ensure we get colored output from cucumber and give it direct terminal access if
            # possible. Direct terminal access would cause the output to be displayed as it's being
            # produced instead of when cucumber is finished.
            if(CMAKE_GENERATOR STREQUAL "Ninja")
                list(APPEND ARGN --color)
            endif()
            set(USES_TERMINAL)
            if(NOT CMAKE_VERSION VERSION_LESS 3.2)
                set(USES_TERMINAL USES_TERMINAL)
            endif()
            add_custom_target(${TARGET_NAME}
                COMMAND ${CUCUMBER_RUBY}
                TEST_FEATURES_DIR=${CUKE_TEST_FEATURES_DIR}
                TMP_DIR=${CUKE_FEATURES_TMP}
                DYNAMIC_CPP_STEPS_SRC=${CUKE_DYNAMIC_CPP_STEPS}
                DYNAMIC_CPP_STEPS_EXE=${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/e2e-steps
                DYNAMIC_CPP_STEPS_OBJ=${CUKE_DYNAMIC_CPP_STEPS_OBJ}
                COMPILE_DYNAMIC_CPP_STEPS=${CUKE_COMPILE_DYNAMIC_CPP_STEPS}
                CUCUMBER_RUBY=${CUCUMBER_RUBY}
                --format=junit "--out=${CMAKE_BINARY_DIR}/features"
                ${CUKE_E2E_TAGS}
                ${ARGN}
                ${CUKE_FEATURES_DIR}
                ${USES_TERMINAL}
                # Execute in same directory as where DLLs appear on Windows
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/src
                )
        endfunction(add_feature_target)

        add_feature_target(features         --format progress)
        add_feature_target(features-pretty  --format pretty)
        add_feature_target(features-wip     --format pretty --tags @wip)

    else()
        message(WARNING "Could not find Cucumber: skipping end-to-end tests")
    endif()

endif()