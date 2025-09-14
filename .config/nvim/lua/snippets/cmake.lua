-- ==================== Snippets (cmake) ==================== --

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local _snippets = {}

local function add_snippet(trigger, replace, replace_table, dscr)
    table.insert(
        _snippets,
        s({
            trig = trigger,
            regTrig = false,
            wordTrig = true,
            dscr = dscr,
        }, fmta(replace, replace_table))
    )
end

add_snippet("export_compile_commands", [[set(CMAKE_EXPORT_COMPILE_COMMANDS ON)]], {}, "CMake export compile commands")

add_snippet(
    "cmake_simple_c",
    [[
cmake_minimum_required(VERSION 4.0)
project(<> VERSION 1.0)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_C_FLAGS
    "-Wall -Wextra -pedantic -Wno-unused-parameter -Wno-unused-value -Wshadow -Wdouble-promotion -Wformat=2 -Wformat-overflow -Wformat-truncation=2 -Wundef -fno-common -Wconversion"
)
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB SOURCES src/*.c)

add_executable(${CMAKE_PROJECT_NAME} ${SOURCES})

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/include")
]],
    { i(1, "project_name") },
    "CMake simple C project"
)

add_snippet(
    "cmake_simple_cpp",
    [[
cmake_minimum_required(VERSION 4.0)
project(<> VERSION 1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# TODO: flags
#set(CMAKE_CXX_FLAGS "")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB SOURCES src/*.cpp)

add_executable(${CMAKE_PROJECT_NAME} ${SOURCES})

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/include")
]],
    { i(1, "project_name") },
    "CMake simple C++ project"
)

return _snippets
