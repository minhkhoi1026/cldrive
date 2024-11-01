


#ifndef BOLTSAMPLE_H_
#define BOLTSAMPLE_H_



#include <bolt/boltVersion.h>
#include <bolt/amp/bolt.h>

#include "SDKUtil.hpp"

#define CHECK_BOLT_ERROR(actual, msg) CHECK_ERROR(actual, SDK_SUCCESS, msg)


namespace appsdk
{


struct BoltVersionStr
{
    int major;      
    int minor;      
    int patch;      

    
    BoltVersionStr()
    {
        major = BoltVersionMajor;
        minor = BoltVersionMinor;
        patch = BoltVersionPatch;
    }
};



class BoltCommandArgs :  public SDKCmdArgsParser
{
    protected:
        BoltVersionStr boltVerStr;     

    public:
        bolt::amp::control
        *boltControlObj;      
        double totalTime;                       
        std::string runMode;                    
        int iterations;
        int samples;

    protected:
        
        int initialize()
        {
            int defaultOptions = 7;
            Option *optionList = new Option[defaultOptions];
            CHECK_ALLOCATION(optionList, "Error. Failed to allocate memory (optionList)\n");
            optionList[0]._sVersion = "";
            optionList[0]._lVersion = "device";
            optionList[0]._description = "Explicit device selection for Bolt";
            std::string optionStr = "[auto|";
            optionStr.append(  "gpu" );
            optionStr.append("|SerialCpu");
            optionStr.append( ((enable_tbb)? "|MultiCoreCpu" : "") );
            optionStr.append("]");
            optionList[0]._usage = optionStr;
            optionList[0]._type = CA_ARG_STRING;
            optionList[0]._value = &runMode;
            optionList[1]._sVersion = "q";
            optionList[1]._lVersion = "quiet";
            optionList[1]._description = "Quiet mode. Suppress most text output.";
            optionList[1]._usage = "";
            optionList[1]._type = CA_NO_ARGUMENT;
            optionList[1]._value = &quiet;
            optionList[2]._sVersion = "e";
            optionList[2]._lVersion = "verify";
            optionList[2]._description = "Verify results against reference implementation.";
            optionList[2]._usage = "";
            optionList[2]._type = CA_NO_ARGUMENT;
            optionList[2]._value = &verify;
            optionList[3]._sVersion = "t";
            optionList[3]._lVersion = "timing";
            optionList[3]._description = "Print timing related statistics.";
            optionList[3]._usage = "";
            optionList[3]._type = CA_NO_ARGUMENT;
            optionList[3]._value = &timing;
            optionList[4]._sVersion = "v";
            optionList[4]._lVersion = "version";
            optionList[4]._description = "Bolt lib & runtime version string.";
            optionList[4]._usage = "";
            optionList[4]._type = CA_NO_ARGUMENT;
            optionList[4]._value = &version;
            optionList[5]._sVersion = "x";
            optionList[5]._lVersion = "samples";
            optionList[5]._description = "Number of sample input values.";
            optionList[5]._usage = "[value]";
            optionList[5]._type = CA_ARG_INT;
            optionList[5]._value = &samples;
            optionList[6]._sVersion = "i";
            optionList[6]._lVersion = "iterations";
            optionList[6]._description = "Number of iterations.";
            optionList[6]._usage = "[value]";
            optionList[6]._type = CA_ARG_INT;
            optionList[6]._value = &iterations;
            _numArgs = defaultOptions;
            _options = optionList;
            return SDK_SUCCESS;
        }

    public:
        bool enable_tbb;                        

        
        BoltCommandArgs(unsigned numSamples, bool enableTBB=false)
        {
            boltControlObj = NULL;
            iterations = 1;
            samples = numSamples;
            enable_tbb = enableTBB;
            initialize();
        }


        
        std::string getBoltVerStr()
        {
            char str[1024];
            unsigned libMajor = 0, libMinor = 0, libPatch = 0;
            bolt::amp::getVersion( libMajor, libMinor, libPatch );
#if defined (_WIN32) && !defined(__MINGW32__)
            sprintf_s(str, 256,
                      "Application compiled with Bolt: v%d.%d.%d\nBolt library compiled with Bolt: v%d.%d.%d",
                      boltVerStr.major,
                      boltVerStr.minor,
                      boltVerStr.patch,
                      libMajor,
                      libMinor,
                      libPatch);
#else
            sprintf(str,
                    "Application compiled with Bolt: v%d.%d.%d\nBolt library compiled with Bolt: v%d.%d.%d",
                    boltVerStr.major,
                    boltVerStr.minor,
                    boltVerStr.patch,
                    libMajor,
                    libMinor,
                    libPatch);
#endif
            return std::string(str);
        }

        
        ~BoltCommandArgs()
        {
        }

        
        int parseCommandLine(int argc, char **argv)
        {
            if(!parse(argv,argc))
            {
                usage();
                if(isArgSet("h",true) == true)
                {
                    exit(SDK_SUCCESS);
                }
                return SDK_FAILURE;
            }
            if(isArgSet("h", true) == true)
            {
                usage();
                exit(SDK_SUCCESS);
            }
            if(isArgSet("v", true) || isArgSet("version", false))
            {
                std::cout << "APP SDK version : " << std::endl
                          << sampleVerStr.c_str() << std::endl;
                std::cout << "Bolt version : " << std::endl
                          << getBoltVerStr().c_str() << std::endl;
                exit(SDK_SUCCESS);
            }
            if(samples <= 0)
            {
                std::cout << "Number input samples should be more than Zero"
                          << std::endl << "Exiting..." << std::endl;
                return SDK_FAILURE;
            }
            if(iterations <= 0)
            {
                std::cout << "Number iterations should be more than Zero"
                          << std::endl << "Exiting..." << std::endl;
                return SDK_FAILURE;
            }
            if( !(runMode.empty()) )                    
            {
                if( (strComparei(runMode, "gpu") == false) &&
                        (strComparei(runMode, "serialcpu") == false) &&
                        (strComparei(runMode, "auto") == false) &&
                        (strComparei(runMode, "multicorecpu") == false) )
                {
                    std::cout << "Specified device is incorrect"
                              << std::endl << "Exiting..." << std::endl;
                    return SDK_FAILURE;
                }
            }
            return SDK_SUCCESS;
        }


        
        void displayRunmodeInfo()
        {
            if(boltControlObj == NULL)
            {
                std::cout << "boltControlObj is not initialized!";
                return;
            }
            switch(boltControlObj->getForceRunMode())
            {
            case (bolt::amp::control::SerialCpu):
                std::cout << "Running in serial cpu mode" << std::endl;
                break;
            case (bolt::amp::control::MultiCoreCpu):
                std::cout << "Running in multi-core cpu mode(TBB)" << std::endl;
                break;
            case (bolt::amp::control::Gpu):
            case (bolt::amp::control::Automatic):
                std::cout << "Running in GPU mode  " << std::endl;
                break;
            default :
                std::cout << "Invalid runmode" << std::endl;
            }
        }



};
}
#endif