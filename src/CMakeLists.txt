cmake_minimum_required(VERSION 3.10)

# Minimal plugin build without external dependencies
project(simple_belfast_pi)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Create the shared library
add_library(simple_belfast_pi SHARED
    simple_belfast_pi.cpp
)

# Set proper library properties
set_target_properties(simple_belfast_pi PROPERTIES
    PREFIX ""
    SUFFIX ".so"
)

if(WIN32)
    set_target_properties(simple_belfast_pi PROPERTIES
        SUFFIX ".dll"
    )
endif()

# Export all symbols for plugin interface
if(UNIX)
    set_target_properties(simple_belfast_pi PROPERTIES
        LINK_FLAGS "-Wl,--export-dynamic"
    )
endif()

# Install target
install(TARGETS simple_belfast_pi 
    RUNTIME DESTINATION .
    LIBRARY DESTINATION .
)
