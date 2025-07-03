#ifndef _SIMPLE_BELFAST_PI_H_
#define _SIMPLE_BELFAST_PI_H_

#include "ocpn_plugin.h"
#include <wx/string.h>

class simple_belfast_pi : public opencpn_plugin {
public:
    simple_belfast_pi(void *ppimgr);
    ~simple_belfast_pi();

    int Init(void) override;
    bool RenderOverlay(wxDC &dc, PlugIn_ViewPort *vp) override;

    wxString GetCommonName() override;
    wxString GetShortDescription() override;
    wxString GetLongDescription() override;
    
    int GetAPIVersionMajor() override { return 1; }
    int GetAPIVersionMinor() override { return 16; }
    int GetPlugInVersionMajor() override { return 1; }
    int GetPlugInVersionMinor() override { return 0; }

private:
    double lat = 54.6;
    double lon = -5.9;
};

#endif
