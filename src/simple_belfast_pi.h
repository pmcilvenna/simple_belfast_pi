#ifndef _SIMPLE_BELFAST_PI_H_
#define _SIMPLE_BELFAST_PI_H_

#include "ocpn_plugin.h"
#include <wx/string.h>

class simple_belfast_pi : public opencpn_plugin_117 {
public:
    simple_belfast_pi(void *ppimgr);
    ~simple_belfast_pi();

    int Init(void) override;
    bool RenderOverlay(wxDC &dc, PlugIn_ViewPort *vp);

    wxString GetCommonName() override;
    wxString GetShortDescription() override;
    wxString GetLongDescription() override;

private:
    double lat = 54.6;
    double lon = -5.9;
};

#endif
