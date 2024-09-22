# 静态库声明
# cc_library(
#   name
#   STATIC/SHARED/INTERFACE
#   NS namespace  # 库名为 namespace::name
#   SRCS
#     source_files...
#   DEPS
#     deps...
#   INCLUDE_DIRS
#     header_dirs...
# )
function(cc_library NAME)
  set(options STATIC SHARED INTERFACE)
  set(oneValueArgs NS)
  set(multiValueArgs SRCS DEPS INCLUDE_DIRS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  if(ARG_NS)
    set(ORI_NAME ${NAME})
    string(REPLACE "::" "__" NS_PREFIX "${ARG_NS}")
    set(NAME ${NS_PREFIX}__${NAME})
  endif()

  if(ARG_STATIC)
    add_library(${NAME} STATIC ${ARG_SRCS})
  elseif(ARG_SHARED)
    add_library(${NAME} SHARED ${ARG_SRCS})
  elseif(ARG_INTERFACE)
    add_library(${NAME} INTERFACE)
    if (ARG_INCLUDE_DIRS)
      target_include_directories(${NAME} INTERFACE ${ARG_INCLUDE_DIRS})
    endif()
    if (ARG_SRCS)
      target_sources(${NAME} INTERFACE ${ARG_SRCS})
    endif()
  else()
    message(FATAL_ERROR "You must specify either STATIC, SHARED or INTERFACE for cc_library")
  endif()

  if(ARG_DEPS)
    add_dependencies(${NAME} ${ARG_DEPS})
    if (ARG_INTERFACE)
      target_link_libraries(${NAME} INTERFACE ${ARG_DEPS})
    else()
      target_link_libraries(${NAME} PRIVATE ${ARG_DEPS})
    endif()
  endif()
  if (ARG_INCLUDE_DIRS AND NOT ARG_INTERFACE)
    target_include_directories(${NAME} PUBLIC ${ARG_INCLUDE_DIRS})
  endif()
  if(ARG_NS)
    # 库文件名 ns1__ns2__name, 库别名 ns1::ns2::name
    add_library(${ARG_NS}::${ORI_NAME} ALIAS ${NAME})
  endif()
endfunction()

# 二进制可运行文件声明
function(cc_binary NAME)
  set(oneValueArgs "")
  set(multiValueArgs SRCS DEPS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  add_executable(${NAME} ${ARG_SRCS})

  if(ARG_DEPS)
    add_dependencies(${NAME} ${ARG_DEPS})
    target_link_libraries(${NAME} PRIVATE ${ARG_DEPS})
  endif()
endfunction()

# 测试程序声明
# cc_test(
#   name
#   [GTEST]  # 是否为 gtest 测试
#   NS namespace  # 测试名为 namespace.name
#   SRCS
#     ...
#   DEPS
#     ...
# )
function(cc_test NAME)
  set(options GTEST)
  set(oneValueArgs NS)
  set(multiValueArgs SRCS DEPS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  if(ARG_NS)
    set(NAME ${ARG_NS}.${NAME})
  endif()

  add_executable(${NAME} ${ARG_SRCS})

  if(ARG_DEPS)
    add_dependencies(${NAME} ${ARG_DEPS})
    target_link_libraries(${NAME} PRIVATE ${ARG_DEPS})
  endif()

  if(ARG_GTEST)
    include(GoogleTest)
    target_link_libraries(${NAME} PRIVATE GTest::gtest_main)
    gtest_discover_tests(${NAME})
  else()
    add_test(NAME ${NAME} COMMAND ${NAME})
  endif()
endfunction()