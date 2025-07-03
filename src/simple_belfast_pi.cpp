#include "simple_belfast_pi.h"
#include <wx/dcclient.h>
#include <wx/log.h>

extern "C" opencpn_plugin* create_pi(void* ppimgr) {
    wxLogMessage("simple_belfast_pi: create_pi called");
    try {
        simple_belfast_pi* plugin = new simple_belfast_pi(ppimgr);
        wxLogMessage("simple_belfast_pi: Plugin created successfully");
        return plugin;
    } catch (...) {
        wxLogMessage("simple_belfast_pi: Exception in create_pi");
        return nullptr;
    }
}

extern "C" void destroy_pi(opencpn_plugin* p) {
    wxLogMessage("simple_belfast_pi: destroy_pi called");
    try {
        delete p;
        wxLogMessage("simple_belfast_pi: Plugin destroyed successfully");
    } catch (...) {
        wxLogMessage("simple_belfast_pi: Exception in destroy_pi");
    }
}

simple_belfast_pi::simple_belfast_pi(void *ppimgr)
    : opencpn_plugin(ppimgr) {
    wxLogMessage("simple_belfast_pi: Constructor called");
}

simple_belfast_pi::~simple_belfast_pi() {
    wxLogMessage("simple_belfast_pi: Destructor called");
}

int simple_belfast_pi::Init(void) {
    wxLogMessage("simple_belfast_pi: Init() called");
    try {
        wxLogMessage("simple_belfast_pi: Init() returning WANTS_OVERLAY_CALLBACK");
        return WANTS_OVERLAY_CALLBACK;
    } catch (...) {
        wxLogMessage("simple_belfast_pi: Exception in Init()");
        return 0;
    }
}

bool simple_belfast_pi::RenderOverlay(wxDC &dc, PlugIn_ViewPort *vp) {
    wxLogMessage("simple_belfast_pi: RenderOverlay called");
    
    try {
        if (!vp) {
            wxLogMessage("simple_belfast_pi: Invalid viewport pointer");
            return false;
        }
        
        wxLogMessage("simple_belfast_pi: Viewport valid, getting pixel coordinates");
        wxPoint p;
        if (!GetCanvasPixLL(vp, &p, lat, lon)) {
            wxLogMessage("simple_belfast_pi: GetCanvasPixLL failed");
            return false;
        }
        
        wxLogMessage("simple_belfast_pi: Got coordinates (%d, %d), setting up drawing", p.x, p.y);
        dc.SetPen(*wxRED_PEN);
        dc.SetBrush(*wxRED_BRUSH);
        
        wxLogMessage("simple_belfast_pi: Drawing circle");
        dc.DrawCircle(p, 10);
        
        wxLogMessage("simple_belfast_pi: RenderOverlay completed successfully");
        return true;
    } catch (...) {
        wxLogMessage("simple_belfast_pi: Exception in RenderOverlay");
        return false;
    }
}

wxString simple_belfast_pi::GetCommonName() {
    wxLogMessage("simple_belfast_pi: GetCommonName called");
    return wxString("Simple Belfast Dot");
}

wxString simple_belfast_pi::GetShortDescription() {
    wxLogMessage("simple_belfast_pi: GetShortDescription called");
    return wxString("Displays a red dot near Belfast.");
}

wxString simple_belfast_pi::GetLongDescription() {
    wxLogMessage("simple_belfast_pi: GetLongDescription called");
    return wxString("This plugin draws a red dot near Belfast (approx. 54.6N, -5.9W).");
}
