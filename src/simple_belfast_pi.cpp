#include "simple_belfast_pi.h"
#include <wx/log.h>

extern "C" opencpn_plugin* create_pi(void* ppimgr) {
    return new simple_belfast_pi(ppimgr);
}

extern "C" void destroy_pi(opencpn_plugin* p) {
    delete p;
}

simple_belfast_pi::simple_belfast_pi(void *ppimgr)
    : opencpn_plugin_118(ppimgr) {
}

simple_belfast_pi::~simple_belfast_pi() {
}

int simple_belfast_pi::Init(void) {
    return 0;  // Start with minimal capabilities
}

bool simple_belfast_pi::DeInit(void) {
    return true;
}

bool simple_belfast_pi::RenderOverlay(wxDC &dc, PlugIn_ViewPort *vp) {
    // Minimal safe rendering - just return true for now
    return true;
}

wxString simple_belfast_pi::GetCommonName() {
    return _T("Simple Belfast Dot");
}

wxString simple_belfast_pi::GetShortDescription() {
    return _T("Displays a red dot near Belfast.");
}

wxString simple_belfast_pi::GetLongDescription() {
    return _T("This plugin draws a red dot near Belfast (approx. 54.6N, -5.9W).");
}
