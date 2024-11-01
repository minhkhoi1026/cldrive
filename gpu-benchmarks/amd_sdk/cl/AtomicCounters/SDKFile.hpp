
#ifndef SDKFILE_HPP_
#define SDKFILE_HPP_


#include <vector>
#include <string>
#include <fstream>
#include <malloc.h>


#if defined(_WIN32) || defined(__CYGWIN__)
#include <direct.h>
#define GETCWD _getcwd
#else 
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#define GETCWD ::getcwd
#endif 



namespace appsdk
{

static std::string getCurrentDir()
{
    const   size_t  pathSize = 4096;
    char    currentDir[pathSize];
    
    if (GETCWD(currentDir, pathSize) != NULL)
    {
        return std::string(currentDir);
    }
    return  std::string("");
}


class SDKFile
{
    public:
        
        SDKFile(): source_("") {}

        
        ~SDKFile() {};

        
        bool open(const char* fileName)
        {
            size_t      size;
            char*       str;
            
            std::fstream f(fileName, (std::fstream::in | std::fstream::binary));
            
            if (f.is_open())
            {
                size_t  sizeFile;
                
                f.seekg(0, std::fstream::end);
                size = sizeFile = (size_t)f.tellg();
                f.seekg(0, std::fstream::beg);
                str = new char[size + 1];
                if (!str)
                {
                    f.close();
                    return  false;
                }
                
                f.read(str, sizeFile);
                f.close();
                str[size] = '\0';
                source_  = str;
                delete[] str;
                return true;
            }
            return false;
        }

        
        int writeBinaryToFile(const char* fileName, const char* binary, size_t numBytes)
        {
            FILE *output = NULL;
            output = fopen(fileName, "wb");
            if(output == NULL)
            {
                return SDK_FAILURE;
            }
            fwrite(binary, sizeof(char), numBytes, output);
            fclose(output);
            return SDK_SUCCESS;
        }


        
        int readBinaryFromFile(const char* fileName)
        {
            FILE * input = NULL;
            size_t size = 0,val;
            char* binary = NULL;
            input = fopen(fileName, "rb");
            if(input == NULL)
            {
                return SDK_FAILURE;
            }
            fseek(input, 0L, SEEK_END);
            size = ftell(input);
            rewind(input);
            binary = (char*)malloc(size);
            if(binary == NULL)
            {
                return SDK_FAILURE;
            }
            val=fread(binary, sizeof(char), size, input);
            fclose(input);
            source_.assign(binary, size);
            free(binary);
            return SDK_SUCCESS;
        }


        
        void replaceNewlineWithSpaces()
        {
            size_t pos = source_.find_first_of('\n', 0);
            while(pos != -1)
            {
                source_.replace(pos, 1, " ");
                pos = source_.find_first_of('\n', pos + 1);
            }
            pos = source_.find_first_of('\r', 0);
            while(pos != -1)
            {
                source_.replace(pos, 1, " ");
                pos = source_.find_first_of('\r', pos + 1);
            }
        }

        
        const std::string&  source() const
        {
            return source_;
        }

    private:
        
        SDKFile(const SDKFile&);

        
        SDKFile& operator=(const SDKFile&);

        std::string     source_;    
};

} 

#endif  
