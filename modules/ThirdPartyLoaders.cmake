function(load_google_test)
  include(FetchContent)

  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
endfunction()

function(load_library_from_git NAME REPO_URL)
  cmake_parse_arguments(ARG "" "GIT_TAG" "" ${ARGN})
  include(FetchContent)

  if(ARG_GIT_TAG)
    FetchContent_Declare(
      ${NAME}
      GIT_REPOSITORY ${REPO_URL}
      GIT_TAG ${ARG_GIT_TAG}
    )
  else()
    FetchContent_Declare(
      ${NAME}
      GIT_REPOSITORY ${REPO_URL}
    )
  endif()
  FetchContent_MakeAvailable(${NAME})
endfunction()

function(load_abseil)
  cmake_parse_arguments(ARG "" "GIT_TAG" "" ${ARGN})
  load_library_from_git(
    abseil
    https://github.com/abseil/abseil-cpp.git
    GIT_TAG ${ARG_GIT_TAG}
  )
  add_definitions(
    -DABSL_BUILD_TESTING=ON
    -DABSL_USE_GOOGLETEST_HEAD=ON
    -DABSL_PROPAGATE_CXX_STD=ON
  )
endfunction()

function(load_google_benchmark)
  cmake_parse_arguments(ARG "" "GIT_TAG" "" ${ARGN})
  load_library_from_git(
    google_benchmark
    https://github.com/google/benchmark.git
    GIT_TAG ${ARG_GIT_TAG}
  )
endfunction()
