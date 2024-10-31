

#ifndef __CL_BODYSYSTEMOPENCL_H__
#define __CL_BODYSYSTEMOPENCL_H__

#if defined (__APPLE__) || defined(MACOSX)
    #include <OpenCL/opencl.h>
#else
    #include <CL/opencl.h>
#endif 
#include "oclBodySystem.h"


class BodySystemOpenCL : public BodySystem
{
    public:
        BodySystemOpenCL(int numBodies, cl_device_id dev, cl_context ctx, cl_command_queue cmdq, unsigned int p, unsigned int q, bool usePBO, bool bDouble);
        virtual ~BodySystemOpenCL();

        virtual void update(float deltaTime);

        virtual void setSoftening(float softening);
        virtual void setDamping(float damping);

        virtual float* getArray(BodyArray array);
        virtual void   setArray(BodyArray array, const float* data);

        virtual size_t getCurrentReadBuffer() const 
        {
            if (m_bUsePBO) 
            {
                return m_pboGL[m_currentRead]; 
            } 
            else 
            {
                return (size_t) m_hPos;
            }
        }

        virtual void synchronizeThreads() const;

    protected: 
        BodySystemOpenCL() {}

        virtual void _initialize(int numBodies);
        virtual void _finalize();
        
    protected: 
        cl_device_id device;
        cl_context cxContext;
        cl_command_queue cqCommandQueue;

        cl_kernel MT_kernel;
        cl_kernel noMT_kernel;

        
        float* m_hPos;
        float* m_hVel;

        
        cl_mem m_dPos[2];
        cl_mem m_dVel[2];

        bool m_bUsePBO;

        float m_softeningSq;
        float m_damping;

        unsigned int m_pboGL[2];
        cl_mem       m_pboCL[2];
        unsigned int m_currentRead;
        unsigned int m_currentWrite;

        unsigned int m_p;
        unsigned int m_q;

		
		bool m_bDouble;
};

#endif 
