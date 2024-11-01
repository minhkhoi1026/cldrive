




#ifndef AMPSAMPLE_H_
#define AMPSAMPLE_H_


#include<amp.h>
#include "SDKUtil.hpp"


using namespace Concurrency;


namespace appsdk
{

class AMPCommandArgs: public SDKCmdArgsParser
{
    public:
        unsigned int deviceId;       
        bool enableDeviceId;         
        accelerator deviceAccl;      

    

        
        int initialize()
        {
            int defaultOptions = 5;
            Option *optionList = new Option[defaultOptions];
            CHECK_ALLOCATION(optionList, "Error. Failed to allocate memory (optionList)\n");
            optionList[0]._sVersion = "q";
            optionList[0]._lVersion = "quiet";
            optionList[0]._description = "Quiet mode. Suppress all text output.";
            optionList[0]._type = CA_NO_ARGUMENT;
            optionList[0]._value = &quiet;
            optionList[1]._sVersion = "e";
            optionList[1]._lVersion = "verify";
            optionList[1]._description = "Verify results against reference implementation.";
            optionList[1]._type = CA_NO_ARGUMENT;
            optionList[1]._value = &verify;
            optionList[2]._sVersion = "t";
            optionList[2]._lVersion = "timing";
            optionList[2]._description = "Print timing.";
            optionList[2]._type = CA_NO_ARGUMENT;
            optionList[2]._value = &timing;
            optionList[3]._sVersion = "v";
            optionList[3]._lVersion = "version";
            optionList[3]._description = "AMD APP SDK version string.";
            optionList[3]._type = CA_NO_ARGUMENT;
            optionList[3]._value = &version;
            optionList[4]._sVersion = "d";
            optionList[4]._lVersion = "deviceId";
            optionList[4]._description =
                "Select deviceId to be used[0 to N-1 where N is number devices available].";
            optionList[4]._type = CA_ARG_INT;
            optionList[4]._value = &deviceId;
            _numArgs = defaultOptions;
            _options = optionList;
            return SDK_SUCCESS;
        }


        
        virtual ~AMPCommandArgs()
        {
        }

        
        AMPCommandArgs()
        {
            deviceId = 0;
            enableDeviceId = false;
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
            if(isArgSet("h",true) == true)
            {
                usage();
                exit(SDK_SUCCESS);
            }
            if(isArgSet("v", true)
                    || isArgSet("version", false))
            {
                std::cout << "SDK version : " << sampleVerStr.c_str()
                          << std::endl;
                exit(0);
            }
            if(isArgSet("d",true)
                    || isArgSet("deviceId",false))
            {
                enableDeviceId = true;
                if(validateDeviceOptions() != SDK_SUCCESS)
                {
                    std::cout << "validateDeviceOptions failed.\n ";
                    return SDK_FAILURE;
                }
            }
            return SDK_SUCCESS;
        }

        
        int printDeviceList()
        {
            std::vector<accelerator> allAccl = accelerator::get_all();
            unsigned int numAccelerator = (unsigned int)allAccl.size();
            std::cout << "Available Accelerators:" << std::endl;
            for (unsigned i = 0; i < numAccelerator; ++i)
            {
                std::wcout<<"Accelerator " <<i;
                std::wcout<< " : " << allAccl[i].get_description() << std::endl;
            }
            std::cout << "\n";
            return SDK_SUCCESS;
        }

        
        int validateDeviceOptions()
        {
            std::vector<accelerator> allAccl = accelerator::get_all();
            unsigned int numAccelerator = (unsigned int)allAccl.size();
            if(deviceId >= numAccelerator)
            {
                if(deviceId - 1 == 0)
                {
                    std::cout << "deviceId should be 0" << std::endl;
                }
                else
                {
                    std::cout << "deviceId should be 0 to " << numAccelerator - 1
                              << std::endl;
                }
                usage();
                return SDK_FAILURE;
            }
            return SDK_SUCCESS;
        }


        
        int setDefaultAccelerator()
        {
            std::vector<accelerator> allAccl = accelerator::get_all();
            
            if(!enableDeviceId)
            {
                for (unsigned i = 0; i < allAccl.size(); ++i)
                {
                    if (allAccl[i].get_description().find(L"AMD Radeon") != std::wstring::npos ||
                            allAccl[i].get_description().find(L"ATI Radeon") != std::wstring::npos )
                    {
                        deviceAccl = allAccl[i];
                        break;
                    }
                }
            }
            else
            {
                deviceAccl = allAccl[deviceId];
            }
            accelerator::set_default(deviceAccl.device_path);
            std::wcout << L"Selected accelerator : " << deviceAccl.get_description()
                       << std::endl;
            if (deviceAccl == accelerator(accelerator::direct3d_ref))
            {
                std::cout << "WARNING!! Running on very slow emulator!" << std::endl;
            }
            if(deviceAccl == accelerator(accelerator::cpu_accelerator))
            {
                std::cout << "There is no need to run on single CPU !"<<std::endl;
                return SDK_FAILURE;
            }
            return SDK_SUCCESS;
        }

};


}
#endif