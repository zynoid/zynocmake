function(load_google_test)
  include(FetchContent)

  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
  enable_testing()
endfunction()

function(load_abseil)
  include(FetchContent)

  FetchContent_Declare(
    abseil
    GIT_REPOSITORY https://github.com/abseil/abseil-cpp.git
    GIT_TAG 20240116.2
  )
  FetchContent_MakeAvailable(abseil)
  add_definitions(
    -DABSL_BUILD_TESTING=ON
    -DABSL_USE_GOOGLETEST_HEAD=ON
    -DABSL_PROPAGATE_CXX_STD=ON
  )
endfunction()
