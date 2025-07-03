#include "simple_belfast_pi.h"

extern "C" void* create_pi(void* ppimgr) {
    return new simple_belfast_pi(ppimgr);
}

extern "C" void destroy_pi(void* p) {
    delete static_cast<simple_belfast_pi*>(p);
}

simple_belfast_pi::simple_belfast_pi(void *ppimgr)
    : m_parent_mgr(ppimgr) {
}

simple_belfast_pi::~simple_belfast_pi() {
}

int simple_belfast_pi::Init(void) {
    return 0;  // Minimal initialization
}

bool simple_belfast_pi::DeInit(void) {
    return true;
}

const char* simple_belfast_pi::GetCommonName() {
    return "Simple Belfast Dot";
}

const char* simple_belfast_pi::GetShortDescription() {
    return "Displays a red dot near Belfast.";
}

const char* simple_belfast_pi::GetLongDescription() {
    return "This plugin draws a red dot near Belfast (approx. 54.6N, -5.9W).";
}
