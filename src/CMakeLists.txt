set(OCPN_DIR "${CMAKE_SOURCE_DIR}/../OpenCPN")

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${OCPN_DIR}/include
    ${OCPN_DIR}/src
)

add_definitions(-DPLUGIN_DLL)

add_library(simple_belfast_pi SHARED
    simple_belfast_pi.cpp
)

find_package(wxWidgets REQUIRED COMPONENTS core base)
include(${wxWidgets_USE_FILE})
target_link_libraries(simple_belfast_pi ${wxWidgets_LIBRARIES})
