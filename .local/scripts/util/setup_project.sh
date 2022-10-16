#!/bin/bash

project_dir="$PWD"
if [ -d "$1" ]; then
    project_dir="$(realpath "$1")"
    shift
fi

case $1 in
"cpp-cmake")
    cat <<EOF >"$project_dir"/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

project(projectName)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

add_executable(\${PROJECT_NAME} main.cpp)
EOF
    cat <<EOF >"$project_dir"/main.cpp
#include <iostream>

int main()
{
    std::cout << "Hello World\n";
}
EOF
    mkdir -p "$project_dir"/build
    cd "$project_dir"/build && cmake "$project_dir"
    ;;
esac
