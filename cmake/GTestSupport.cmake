include(FetchContent)
# clone gtest build and install it 
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG main
)
FetchContent_Makeavailable(googletest)
include(googletest)
