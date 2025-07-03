#ifndef _SIMPLE_BELFAST_PI_H_
#define _SIMPLE_BELFAST_PI_H_

// Minimal plugin interface without external dependencies
class simple_belfast_pi {
public:
    simple_belfast_pi(void *ppimgr);
    ~simple_belfast_pi();

    int Init(void);
    bool DeInit(void);

    const char* GetCommonName();
    const char* GetShortDescription();
    const char* GetLongDescription();
    
    int GetAPIVersionMajor() { return 1; }
    int GetAPIVersionMinor() { return 18; }
    int GetPlugInVersionMajor() { return 1; }
    int GetPlugInVersionMinor() { return 0; }

private:
    void* m_parent_mgr;
};

#endif
