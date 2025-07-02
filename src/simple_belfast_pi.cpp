#include "simple_belfast_pi.h"
#include <wx/dcclient.h>

extern "C" opencpn_plugin* create_pi(void* ppimgr) {
    return new simple_belfast_pi(ppimgr);
}

extern "C" void destroy_pi(opencpn_plugin* p) {
    delete p;
}

simple_belfast_pi::simple_belfast_pi(void *ppimgr)
    : opencpn_plugin(ppimgr) {}

simple_belfast_pi::~simple_belfast_pi() {}

int simple_belfast_pi::Init(void) {
    return WANTS_OVERLAY_CALLBACK;
}

bool simple_belfast_pi::RenderOverlay(wxDC &dc, PlugIn_ViewPort *vp) {
 if (!vp) return false;  // Check for valid viewport
    wxPoint p;
    GetCanvasPixLL(vp, &p, lat, lon);
     if (!GetCanvasPixLL(vp, &p, lat, lon)) {
            return false;  // Failed to get pixel coordinates
        }
    dc.SetPen(*wxRED_PEN);
    dc.SetBrush(*wxRED_BRUSH);
    dc.DrawCircle(p, 10);
    return true;
}

wxString simple_belfast_pi::GetCommonName() {
    return wxString("Simple Belfast Dot");
}

wxString simple_belfast_pi::GetShortDescription() {
    return wxString("Displays a red dot near Belfast.");
}

wxString simple_belfast_pi::GetLongDescription() {
    return wxString("This plugin draws a red dot near Belfast (approx. 54.6N, -5.9W).");
}
