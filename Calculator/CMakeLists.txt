cmake_minimum_required(VERSION 3.16)

project(Calculator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appCalculator
    main.cpp
    resources.qrc
)

qt_add_qml_module(appCalculator
    URI Calculator
    VERSION 1.0
    QML_FILES Main.qml ButtonTemplate.qml ButtonDigit.qml ButtonOperator.qml
)

qt_add_resources(appCalculator "app_font"
    PREFIX "/"
    FILES
        OpenSansSemibold.otf
        icons/branch.svg
        icons/division.svg
        icons/equal.svg
        icons/minus.svg
        icons/multi.svg
        icons/percent.svg
        icons/plus.svg
        icons/plus_minus.svg
)

set_target_properties(appCalculator PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCalculator
    PRIVATE Qt6::Quick
)

install(TARGETS appCalculator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
