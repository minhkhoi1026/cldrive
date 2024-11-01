


#ifndef OPENCV_UTIL_H_
#define OPENCV_UTIL_H_



#include <opencv2/core/version.hpp>
#include <opencv2/core/core.hpp>


#include "SDKUtil.hpp"

namespace appsdk
{

class OpenCVCommandArgs : public SDKCmdArgsParser
{
  bool version;            

public:

  int iterations;  

  
  int initialize();

  
  OpenCVCommandArgs();
  
  
  ~OpenCVCommandArgs();

  
  int parseCommandLine(int argc, char **argv);
  
};


int OpenCVCommandArgs::initialize()
{
  int defaultOptions = 4;

  Option *optionList = new Option[defaultOptions];
  CHECK_ALLOCATION(optionList,
                   "Error. Failed to allocate memory (optionList)\n");

  optionList[0]._sVersion = "q";
  optionList[0]._lVersion = "quiet";
  optionList[0]._description = "Quiet mode. Suppress most text output.";
  optionList[0]._type = CA_NO_ARGUMENT;
  optionList[0]._value = &quiet;

  optionList[1]._sVersion = "e";
  optionList[1]._lVersion = "verify";
  optionList[1]._description =
                 "Verify results against reference implementation.";
  optionList[1]._type = CA_NO_ARGUMENT;
  optionList[1]._value = &verify;

  optionList[2]._sVersion = "t";
  optionList[2]._lVersion = "timing";
  optionList[2]._description = "Print timing related statistics.";
  optionList[2]._type = CA_NO_ARGUMENT;
  optionList[2]._value = &timing;

  optionList[3]._sVersion = "v";
  optionList[3]._lVersion = "version";
  optionList[3]._description = "OpenCV lib & runtime version string.";
  optionList[3]._type = CA_NO_ARGUMENT;
  optionList[3]._value = &version;

  _numArgs = defaultOptions;
  _options = optionList;
              
  return SDK_SUCCESS;
}


int OpenCVCommandArgs::parseCommandLine(int argc, char**argv)
{
    if(!parse(argv,argc))
    {
      usage();
      if(isArgSet("h",true) == true)
        exit(SDK_SUCCESS);
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
      std::cout << "APP SDK version : " << sampleVerStr.c_str() << std::endl;
      exit(0);
    }
  

  return SDK_SUCCESS;
}


OpenCVCommandArgs::OpenCVCommandArgs() : SDKCmdArgsParser()
{
  iterations = 1;
  
}


OpenCVCommandArgs::~OpenCVCommandArgs()
{
}
}
#endif
