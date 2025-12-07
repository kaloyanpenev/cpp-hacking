# IPO/LTO configuration

if(ENABLE_IPO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT ipo_supported OUTPUT ipo_output)
  if(ipo_supported)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    message(STATUS "IPO/LTO enabled")
  else()
    message(WARNING "IPO requested but not supported: ${ipo_output}")
  endif()
endif()
