# Sanitizer configuration
# Creates a project_sanitizers interface library

add_library(project_sanitizers INTERFACE)

if(NOT (ENABLE_ASAN OR ENABLE_LSAN OR ENABLE_TSAN OR ENABLE_UBSAN OR ENABLE_MSAN))
  return()
endif()

# Mutual exclusivity checks
if(ENABLE_ASAN AND ENABLE_TSAN)
  message(FATAL_ERROR "ASan and TSan cannot be enabled simultaneously")
endif()
if(ENABLE_ASAN AND ENABLE_MSAN)
  message(FATAL_ERROR "ASan and MSan cannot be enabled simultaneously")
endif()
if(ENABLE_TSAN AND ENABLE_MSAN)
  message(FATAL_ERROR "TSan and MSan cannot be enabled simultaneously")
endif()
if(ENABLE_LSAN AND ENABLE_TSAN)
  message(FATAL_ERROR "LSan and TSan cannot be enabled simultaneously")
endif()

if(MSVC)
  # MSVC only supports AddressSanitizer
  if(ENABLE_ASAN)
    target_compile_options(project_sanitizers INTERFACE /fsanitize=address /Zi)
    target_link_options(project_sanitizers INTERFACE /INCREMENTAL:NO)
    target_compile_definitions(project_sanitizers INTERFACE 
      _DISABLE_VECTOR_ANNOTATION _DISABLE_STRING_ANNOTATION)
  endif()
  if(ENABLE_LSAN OR ENABLE_TSAN OR ENABLE_UBSAN OR ENABLE_MSAN)
    message(WARNING "MSVC only supports AddressSanitizer")
  endif()

elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang|GNU")
  set(SANITIZERS "")
  
  if(ENABLE_ASAN)
    list(APPEND SANITIZERS "address")
  endif()
  if(ENABLE_LSAN)
    list(APPEND SANITIZERS "leak")
  endif()
  if(ENABLE_TSAN)
    list(APPEND SANITIZERS "thread")
  endif()
  if(ENABLE_UBSAN)
    list(APPEND SANITIZERS "undefined")
  endif()
  if(ENABLE_MSAN)
    if(NOT CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
      message(WARNING "MSan is only supported by Clang")
    else()
      message(WARNING "MSan requires all code (including libc++) to be MSan-instrumented")
      list(APPEND SANITIZERS "memory")
    endif()
  endif()

  list(JOIN SANITIZERS "," SANITIZER_LIST)
  if(SANITIZER_LIST)
    target_compile_options(project_sanitizers INTERFACE 
      -fsanitize=${SANITIZER_LIST} -fno-omit-frame-pointer)
    target_link_options(project_sanitizers INTERFACE 
      -fsanitize=${SANITIZER_LIST})
    # For GCC, link ASan statically when requested (helps gtest runs)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND "address" IN_LIST SANITIZERS)
      target_link_options(project_sanitizers INTERFACE -static-libasan)
    endif()
  endif()
endif()
