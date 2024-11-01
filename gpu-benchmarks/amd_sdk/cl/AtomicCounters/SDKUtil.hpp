


#ifndef SDKUTIL_HPP_
#define SDKUTIL_HPP_


#include <iostream>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <ctime>
#include <cmath>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <vector>
#include <malloc.h>
#include <math.h>
#include <numeric>
#include <stdint.h>


#if defined(__MINGW32__) && !defined(__MINGW64_VERSION_MAJOR)
#define _aligned_malloc __mingw_aligned_malloc
#define _aligned_free  __mingw_aligned_free
#endif 


#ifndef _WIN32
#if defined(__INTEL_COMPILER)
#pragma warning(disable : 1125)
#endif
#endif

#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#include <linux/limits.h>
#include <unistd.h>
#endif


#define SDK_SUCCESS 0
#define SDK_FAILURE 1
#define SDK_EXPECTED_FAILURE 2

#define SDK_VERSION_MAJOR 2
#define SDK_VERSION_MINOR 9
#define SDK_VERSION_SUB_MINOR 1
#define SDK_VERSION_BUILD 1
#define SDK_VERSION_REVISION 1


#define CHECK_ALLOCATION(actual, msg) \
    if(actual == NULL) \
    { \
        error(msg); \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return SDK_FAILURE; \
    }

#define CHECK_ERROR(actual, reference, msg) \
    if(actual != reference) \
    { \
        error(msg); \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return SDK_FAILURE; \
    }

#define FREE(ptr) \
    { \
        if(ptr != NULL) \
        { \
            free(ptr); \
            ptr = NULL; \
        } \
    }

#ifdef _WIN32
#define ALIGNED_FREE(ptr) \
    { \
        if(ptr != NULL) \
        { \
            _aligned_free(ptr); \
            ptr = NULL; \
        } \
    }
#endif



namespace appsdk
{


static struct sdkVersionStr
{
    int major;      
    int minor;      
    int subminor;   
    int build;      
    int revision;   

    
     inline sdkVersionStr()
    {
        major = SDK_VERSION_MAJOR;
        minor = SDK_VERSION_MINOR;
        subminor = SDK_VERSION_SUB_MINOR;
        build = SDK_VERSION_BUILD;
        revision = SDK_VERSION_REVISION;
    }
} sdkVerStr;



enum CmdArgsEnum
{
    CA_ARG_INT,
    CA_ARG_FLOAT,
    CA_ARG_DOUBLE,
    CA_ARG_STRING,
    CA_NO_ARGUMENT
};


struct Option
{
    std::string  _sVersion;
    std::string  _lVersion;
    std::string  _description;
    std::string  _usage;
    CmdArgsEnum  _type;
    void *       _value;
};


static void error(std::string errorMsg)
{
    std::cout<<"Error: "<<errorMsg<<std::endl;
}


static void expectedError(const char* errorMsg)
{
    std::cout<<"Expected Error: "<<errorMsg<<std::endl;
}


static void expectedError(std::string errorMsg)
{
    std::cout<<"Expected Error: "<<errorMsg<<std::endl;
}



static bool compare(const float *refData, const float *data,
             const int length, const float epsilon = 1e-6f)
{
    float error = 0.0f;
    float ref = 0.0f;
    for(int i = 1; i < length; ++i)
    {
        float diff = refData[i] - data[i];
        error += diff * diff;
        ref += refData[i] * refData[i];
    }
    float normRef =::sqrtf((float) ref);
    if (::fabs((float) ref) < 1e-7f)
    {
        return false;
    }
    float normError = ::sqrtf((float) error);
    error = normError / normRef;
    return error < epsilon;
}
static bool compare(const double *refData, const double *data,
             const int length, const double epsilon = 1e-6)
{
    double error = 0.0;
    double ref = 0.0;
    for(int i = 1; i < length; ++i)
    {
        double diff = refData[i] - data[i];
        error += diff * diff;
        ref += refData[i] * refData[i];
    }
    double normRef =::sqrt((double) ref);
    if (::fabs((double) ref) < 1e-7)
    {
        return false;
    }
    double normError = ::sqrt((double) error);
    error = normError / normRef;
    return error < epsilon;
}


static bool strComparei(std::string a, std::string b)
{
    int sizeA = (int)a.size();
    if (b.size() != sizeA)
    {
        return false;
    }
    for (int i = 0; i < sizeA; i++)
    {
        if (tolower(a[i]) != tolower(b[i]))
        {
            return false;
        }
    }
    return true;
}


template<typename T>
std::string toString(T t, std::ios_base & (*r)(std::ios_base&) = std::dec)
{
    std::ostringstream output;
    output << r << t;
    return output.str();
}


static int fileToString(std::string &fileName, std::string &str)
{
    size_t      size;
    char*       buf;
    
    std::fstream f(fileName.c_str(), (std::fstream::in | std::fstream::binary));
    
    if (f.is_open())
    {
        size_t  sizeFile;
        
        f.seekg(0, std::fstream::end);
        size = sizeFile = (size_t)f.tellg();
        f.seekg(0, std::fstream::beg);
        buf = new char[size + 1];
        if (!buf)
        {
            f.close();
            return  SDK_FAILURE;
        }
        
        f.read(buf, sizeFile);
        f.close();
        str[size] = '\0';
        str = buf;
        return SDK_SUCCESS;
    }
    else
    {
        error("Converting file to string. Cannot open file.");
        str = "";
        return SDK_FAILURE;
    }
}


template<typename T>
void printArray(
    const std::string header,
    const T * data,
    const int width,
    const int height)
{
    std::cout<<"\n"<<header<<"\n";
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j < width; j++)
        {
            std::cout<<data[i*width+j]<<" ";
        }
        std::cout<<"\n";
    }
    std::cout<<"\n";
}


template<typename T>
void printArray(
    const std::string header,
    const T * data,
    const int width,
    const int height,
	int veclen)
{
    std::cout<<"\n"<<header<<"\n";
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j < width; j++)
        {
            std::cout << "(";
			for(int k=0; k<veclen; k++)
			{
				std::cout<<data[i*width+j].s[k]<<", ";
			}
			std::cout << ") ";
        }
        std::cout<<"\n";
    }
    std::cout<<"\n";
}



template<typename T>
void printArray(
    const std::string header,
    const std::vector<T>& data,
    const int width,
    const int height)
{
    std::cout<<"\n"<<header<<"\n";
    for(int i = 0; i < height; i++)
    {
        for(int j = 0; j < width; j++)
        {
            std::cout<<data[i*width+j]<<" ";
        }
        std::cout<<"\n";
    }
    std::cout<<"\n";
}


static void printStatistics(std::string *statsStr, std::string * stats, int n)
{
    int *columnWidth = new int[n];
    if(columnWidth == NULL)
    {
        return;
    }
    std::cout << std::endl << "|";
    for(int i=0; i<n; i++)
    {
        columnWidth[i] = (int) ((statsStr[i].length() > stats[i].length())?
                                statsStr[i].length() : stats[i].length());
        std::cout << " " << std::setw(columnWidth[i]+1) << std::left << statsStr[i] <<
                  "|";
    }
    std::cout << std::endl << "|";
    for(int i=0; i<n; i++)
    {
        for(int j=0; j<(columnWidth[i]+2); j++)
        {
            std::cout << "-";
        }
        std::cout << "|";
    }
    std::cout << std::endl << "|";
    for(int i=0; i<n; i++)
    {
        std::cout << " " << std::setw(columnWidth[i]+1) << std::left << stats[i] << "|";
    }
    std::cout << std::endl;
    if(columnWidth)
    {
        delete[] columnWidth;
    }
}


template<typename T>
int fillRandom(
    T * arrayPtr,
    const int width,
    const int height,
    const T rangeMin,
    const T rangeMax,
    unsigned int seed=123)
{
    if(!arrayPtr)
    {
        error("Cannot fill array. NULL pointer.");
        return SDK_FAILURE;
    }
    if(!seed)
    {
        seed = (unsigned int)time(NULL);
    }
    srand(seed);
    double range = double(rangeMax - rangeMin) + 1.0;
    
    for(int i = 0; i < height; i++)
        for(int j = 0; j < width; j++)
        {
            int index = i*width + j;
            arrayPtr[index] = rangeMin + T(range*rand()/(RAND_MAX + 1.0));
        }
    return SDK_SUCCESS;
}


template<typename T>
int fillPos(
    T * arrayPtr,
    const int width,
    const int height)
{
    if(!arrayPtr)
    {
        error("Cannot fill array. NULL pointer.");
        return SDK_FAILURE;
    }
    
    for(T i = 0; i < height; i++)
        for(T j = 0; j < width; j++)
        {
            T index = i*width + j;
            arrayPtr[index] = index;
        }
    return SDK_SUCCESS;
}


template<typename T>
int fillConstant(
    T * arrayPtr,
    const int width,
    const int height,
    const T val)
{
    if(!arrayPtr)
    {
        error("Cannot fill array. NULL pointer.");
        return SDK_FAILURE;
    }
    
    for(int i = 0; i < height; i++)
        for(int j = 0; j < width; j++)
        {
            int index = i*width + j;
            arrayPtr[index] = val;
        }
    return SDK_SUCCESS;
}



template<typename T>
T roundToPowerOf2(T val)
{
    int bytes = sizeof(T);
    val--;
    for(int i = 0; i < bytes; i++)
    {
        val |= val >> (1<<i);
    }
    val++;
    return val;
}


template<typename T>
int isPowerOf2(T val)
{
    long long _val = val;
    if((_val & (-_val))-_val == 0 && _val != 0)
    {
        return SDK_SUCCESS;
    }
    else
    {
        return SDK_FAILURE;
    }
}


static std::string getPath()
{
#ifdef _WIN32
    char buffer[MAX_PATH];
#ifdef UNICODE
    if(!GetModuleFileName(NULL, (LPWCH)buffer, sizeof(buffer)))
    {
        throw std::string("GetModuleFileName() failed!");
    }
#else
    if(!GetModuleFileName(NULL, buffer, sizeof(buffer)))
    {
        throw std::string("GetModuleFileName() failed!");
    }
#endif
    std::string str(buffer);
    
    int last = (int)str.find_last_of((char)92);
#else
    char buffer[PATH_MAX + 1];
    ssize_t len;
    if((len = readlink("/proc/self/exe",buffer, sizeof(buffer) - 1)) == -1)
    {
        throw std::string("readlink() failed!");
    }
    buffer[len] = '\0';
    std::string str(buffer);
    
    int last = (int)str.find_last_of((char)47);
#endif
    return str.substr(0, last + 1);
}



static std::string getSdkVerStr()
{
    char str[1024];
    std::string dbgStr("");
    std::string internal("");
#ifdef _WIN32
#ifdef _DEBUG
    dbgStr.append("-dbg");
#endif
#else
#ifdef NDEBUG
    dbgStr.append("-dbg");
#endif
#endif
#if defined (_WIN32) && !defined(__MINGW32__)
    sprintf_s(str, 256, "AMD-APP-SDK-v%d.%d.%d%s%s (%d.%d)",
              sdkVerStr.major,
              sdkVerStr.minor,
              sdkVerStr.subminor,
              internal.c_str(),
              dbgStr.c_str(),
              sdkVerStr.build,
              sdkVerStr.revision);
#else
    sprintf(str, "AMD-APP-SDK-v%d.%d.%d%s%s (%d.%d)",
            sdkVerStr.major,
            sdkVerStr.minor,
            sdkVerStr.subminor,
            internal.c_str(),
            dbgStr.c_str(),
            sdkVerStr.build,
            sdkVerStr.revision);
#endif
    return std::string(str);
}



class SDKTimer
{
    private:

        struct Timer
        {
            std::string name;   
            long long _freq;    
            long long _clocks;  
            long long _start;   
        };

        std::vector<Timer*> _timers;      
        

    public :
        double totalTime;                 
        
        SDKTimer()
        {
        }

        
        ~SDKTimer()
        {
            while(!_timers.empty())
            {
                Timer *temp = _timers.back();
                _timers.pop_back();
                delete temp;
            }
        }

        
        int createTimer()
        {
            Timer* newTimer = new Timer;
            newTimer->_start = 0;
            newTimer->_clocks = 0;
#ifdef _WIN32
            QueryPerformanceFrequency((LARGE_INTEGER*)&newTimer->_freq);
#else
            newTimer->_freq = (long long)1.0E3;
#endif
            
            _timers.push_back(newTimer);
            return (int)(_timers.size() - 1);
        }

        
        int resetTimer(int handle)
        {
            if(handle >= (int)_timers.size())
            {
                error("Cannot reset timer. Invalid handle.");
                return -1;
            }
            (_timers[handle]->_start) = 0;
            (_timers[handle]->_clocks) = 0;
            return SDK_SUCCESS;
        }
        
        int startTimer(int handle)
        {
            if(handle >= (int)_timers.size())
            {
                error("Cannot reset timer. Invalid handle.");
                return SDK_FAILURE;
            }
#ifdef _WIN32
            QueryPerformanceCounter((LARGE_INTEGER*)&(_timers[handle]->_start));
#else
            struct timeval s;
            gettimeofday(&s, 0);
            _timers[handle]->_start = (long long)s.tv_sec * (long long)1.0E3 +
                                      (long long)s.tv_usec / (long long)1.0E3;
#endif
            return SDK_SUCCESS;
        }

        
        int stopTimer(int handle)
        {
            long long n=0;
            if(handle >= (int)_timers.size())
            {
                error("Cannot reset timer. Invalid handle.");
                return SDK_FAILURE;
            }
#ifdef _WIN32
            QueryPerformanceCounter((LARGE_INTEGER*)&(n));
#else
            struct timeval s;
            gettimeofday(&s, 0);
            n = (long long)s.tv_sec * (long long)1.0E3+ (long long)s.tv_usec /
                (long long)1.0E3;
#endif
            n -= _timers[handle]->_start;
            _timers[handle]->_start = 0;
            _timers[handle]->_clocks += n;
            return SDK_SUCCESS;
        }

        
        double readTimer(int handle)
        {
            if(handle >= (int)_timers.size())
            {
                error("Cannot read timer. Invalid handle.");
                return SDK_FAILURE;
            }
            double reading = double(_timers[handle]->_clocks);
            reading = double(reading / _timers[handle]->_freq);
            return reading;
        }


};


class SDKCmdArgsParser
{
    protected:
        int _numArgs;               
        int _argc;                  
        int _seed;                  
        char ** _argv;              
        Option * _options;          
        bool version;                           
        std::string name;                       
        sdkVersionStr sdkVerStr;     
    public:
        bool quiet;                 
        bool verify;                
        bool timing;                
		std::string sampleVerStr;   

    protected:

        
        void usage()
        {
            std::cout<<"Usage\n";
            help();
        }

        
        SDKCmdArgsParser (void)
        {
            _options = NULL;
            _numArgs = 0;
            _argc = 0;
            _argv = NULL;
            _seed = 123;
            quiet = 0;
            verify = 0;
            timing = 0;
        }
    private:

        
        int match(char ** argv, int argc)
        {
            int matched  = 0;
            int shortVer = true;
            char * arg = *argv;
            if ( *arg == '-' && *(arg+1) == '-')
            {
                shortVer = false;
                arg++;
            }
            else if (*arg != '-')
            {
                return matched;
            }
            arg++;
            for (int count = 0; count < _numArgs; count++)
            {
                if (shortVer)
                {
                    matched = _options[count]._sVersion.compare(arg) == 0 ? 1 : 0;
                }
                else
                {
                    matched = _options[count]._lVersion.compare(arg) == 0 ? 1 : 0;
                }
                if (matched == 1)
                {
                    if (_options[count]._type == CA_NO_ARGUMENT)
                    {
                        *((bool *)_options[count]._value) = true;
                    }
                    else if (_options[count]._type == CA_ARG_FLOAT)
                    {
                        if(argc > 1)
                        {
                            sscanf(*(argv+1), "%f", (float *)_options[count]._value);
                            matched++;
                        }
                        else
                        {
                            std::cout<<"Error. Missing argument for \""<<(*argv)<<"\"\n";
                            return SDK_FAILURE;
                        }
                    }
                    else if (_options[count]._type == CA_ARG_DOUBLE)
                    {
                        if(argc > 1)
                        {
                            sscanf(*(argv+1), "%lf", (double *)_options[count]._value);
                            matched++;
                        }
                        else
                        {
                            std::cout<<"Error. Missing argument for \""<<(*argv)<<"\"\n";
                            return SDK_FAILURE;
                        }
                    }
                    else if (_options[count]._type == CA_ARG_INT)
                    {
                        if(argc > 1)
                        {
                            sscanf(*(argv+1), "%d", (int *)_options[count]._value);
                            matched++;
                        }
                        else
                        {
                            std::cout<<"Error. Missing argument for \""<<(*argv)<<"\"\n";
                            return SDK_FAILURE;
                        }
                    }
                    else
                    {
                        if(argc > 1)
                        {
                            std::string * str = (std::string *)_options[count]._value;
                            str->clear();
                            str->append(*(argv+1));
                            matched++;
                        }
                        else
                        {
                            std::cout<<"Error. Missing argument for \""<<(*argv)<<"\"\n";
                            return SDK_FAILURE;
                        }
                    }
                    break;
                }
            }
            return matched;
        }

    public:

        
        ~SDKCmdArgsParser ()
        {
            if(_options)
            {
                delete[] _options;
            }
        }
        
        int AddOption(Option* op)
        {
            if(!op)
            {
                std::cout<<"Error. Cannot add option, NULL input";
                return -1;
            }
            else
            {
                Option* save = NULL;
                if(_options != NULL)
                {
                    save = _options;
                }
                _options = new Option[_numArgs + 1];
                if(!_options)
                {
                    std::cout<<"Error. Cannot add option ";
                    std::cout<<op->_sVersion<<". Memory allocation error\n";
                    return SDK_FAILURE;
                }
                if(_options != NULL)
                {
                    for(int i=0; i< _numArgs; ++i)
                    {
                        _options[i] = save[i];
                    }
                }
                _options[_numArgs] = *op;
                _numArgs++;
                delete []save;
            }
            return SDK_SUCCESS;
        }

        
        int DeleteOption(Option* op)
        {
            if(!op || _numArgs <= 0)
            {
                std::cout<<"Error. Cannot delete option."
                         <<"Null pointer or empty option list\n";
                return SDK_FAILURE;
            }
            for(int i = 0; i < _numArgs; i++)
            {
                if(op->_sVersion == _options[i]._sVersion ||
                        op->_lVersion == _options[i]._lVersion )
                {
                    for(int j = i; j < _numArgs-1; j++)
                    {
                        _options[j] = _options[j+1];
                    }
                    _numArgs--;
                }
            }
            return SDK_SUCCESS;
        }

        
        int parse(char ** p_argv, int p_argc)
        {
            int matched = 0;
            int argc;
            char **argv;
            _argc = p_argc;
            _argv = p_argv;
            argc = p_argc;
            argv = p_argv;
            if(argc == 1)
            {
                return SDK_FAILURE;
            }
            while (argc > 0)
            {
                matched = match(argv,argc);
                argc -= (matched > 0 ? matched : 1);
                argv += (matched > 0 ? matched : 1);
            }
            return matched;
        }

        
        bool isArgSet(std::string str, bool shortVer = false)
        {
            bool enabled = false;
            for (int count = 0; count < _argc; count++)
            {
                char * arg = _argv[count];
                if (*arg != '-')
                {
                    continue;
                }
                else if (*arg == '-' && *(arg+1) == '-' && !shortVer)
                {
                    arg++;
                }
                arg++;
                if (str.compare(arg) == 0)
                {
                    enabled = true;
                    break;
                }
            }
            return enabled;
        }

        
        void help(void)
        {
            std::cout <<  "-h, " << std::left << std::setw(14)
                      << "" "--help" << std::left << std::setw(32) <<" "
                      << "Display this information\n";
            for (int count = 0; count < _numArgs; count++)
            {
                if (_options[count]._sVersion.length() > 0)
                {
                    std::cout<< std::left << std::setw(4) <<  "-" + _options[count]._sVersion +
                             ", ";
                }
                else
                {
                    std::cout << "    ";
                }
                std::cout<< std::left<< std::setw(14) <<  "--" + _options[count]._lVersion;
                if(!_options[count]._usage.empty())
                {
                    std::cout <<std::left <<std::setw(32) << _options[count]._usage ;
                }
                else
                {
                    std::cout <<std::left <<std::setw(32) << "";
                }
                std::cout<< _options[count]._description + "\n";
            }
        }
        
        virtual int parseCommandLine(int argc, char **argv) = 0;
};

}
#endif