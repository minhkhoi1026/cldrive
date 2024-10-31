













#include <fstream>
#include <iostream>

const unsigned int PGMHeaderSize = 0x40;
#define MIN_EPSILON_ERROR 1e-3f










template<class T, class S>
bool compareDataAsFloatThreshold( const T* reference, const T* data, const unsigned int len, 
                    const S epsilon, const float threshold) 
{
    if( epsilon < 0)
		return false;

    
    float max_error = max( (float)epsilon, MIN_EPSILON_ERROR );
    int error_count = 0;
    bool result = true;

    for( unsigned int i = 0; i < len; ++i) {
        float diff = fabs((float)reference[i] - (float)data[i]);
        bool comp = (diff < max_error);
        result &= comp;

        if( ! comp) 
        {
            error_count++;
#ifdef _DEBUG
		if (error_count < 50) {
            printf("\n    ERROR(epsilon=%4.3f), i=%d, (ref)0x%02x / (data)0x%02x / (diff)%d\n", max_error, i, reference[i], data[i], (unsigned int)diff);
		}
#endif
        }
    }

    if (threshold == 0.0f) {
        if (error_count) {
            printf("total # of errors = %d\n", error_count);
        }
        return (error_count == 0);
    } else {

        if (error_count) {
            printf("%4.2f(%%) of bytes mismatched (count=%d)\n", (float)error_count*100/(float)len, error_count);
        }

        return ((len*threshold > error_count));
    }
}









bool Compareubt( const unsigned char* reference, const unsigned char* data,
             const unsigned int len, const float epsilon, const float threshold ) 
{
    return compareDataAsFloatThreshold( reference, data, len, epsilon, threshold );
}









bool savePPM( const char* file, unsigned char *data, 
         unsigned int w, unsigned int h, unsigned int channels) 
{
    if( NULL == data)
		return false;
    if( w <= 0)
		return false;
    if( h <= 0)
		return false;

    std::fstream fh( file, std::fstream::out | std::fstream::binary );
    if( fh.bad()) 
    {
        std::cerr << "savePPM() : Opening file failed." << std::endl;
        return false;
    }

    if (channels == 1)
    {
        fh << "P5\n";
    }
    else if (channels == 3) {
        fh << "P6\n";
    }
    else {
        std::cerr << "savePPM() : Invalid number of channels." << std::endl;
        return false;
    }

    fh << w << "\n" << h << "\n" << 0xff << std::endl;

    for( unsigned int i = 0; (i < (w*h*channels)) && fh.good(); ++i) 
    {
        fh << data[i];
    }
    fh.flush();

    if( fh.bad()) 
    {
        std::cerr << "savePPM() : Writing data failed." << std::endl;
        return false;
    } 
    fh.close();

    return true;
}









bool SavePPM4ub( const char* file, unsigned char *data, 
               unsigned int w, unsigned int h) 
{
    
    int size = w * h;
    unsigned char *ndata = (unsigned char*) malloc( sizeof(unsigned char) * size*3);
    unsigned char *ptr = ndata;
    for(int i=0; i<size; i++) {
        *ptr++ = *data++;
        *ptr++ = *data++;
        *ptr++ = *data++;
        data++;
    }
    
    return savePPM( file, ndata, w, h, 3);
}












bool loadPPM( const char* file, unsigned char** data, 
         unsigned int *w, unsigned int *h, unsigned int *channels ) 
{
    FILE *fp = NULL;
    if(NULL == (fp = fopen(file, "rb"))) 
    {
        std::cerr << "LoadPPM() : Failed to open file: " << file << std::endl;
        return false;
    }

    
    char header[PGMHeaderSize], *string = NULL;
    string = fgets( header, PGMHeaderSize, fp);
    if (strncmp(header, "P5", 2) == 0)
    {
        *channels = 1;
    }
    else if (strncmp(header, "P6", 2) == 0)
    {
        *channels = 3;
    }
    else {
        std::cerr << "LoadPPM() : File is not a PPM or PGM image" << std::endl;
        *channels = 0;
        return false;
    }

    
    unsigned int width = 0;
    unsigned int height = 0;
    unsigned int maxval = 0;
    unsigned int i = 0;
    while(i < 3) 
    {
        string = fgets(header, PGMHeaderSize, fp);
        if(header[0] == '#') 
            continue;

        if(i == 0) 
        {
            i += sscanf( header, "%u %u %u", &width, &height, &maxval);
        }
        else if (i == 1) 
        {
            i += sscanf( header, "%u %u", &height, &maxval);
        }
        else if (i == 2) 
        {
            i += sscanf(header, "%u", &maxval);
        }
    }

    
    if( NULL != *data) 
    {
        if (*w != width || *h != height) 
        {
            std::cerr << "LoadPPM() : Invalid image dimensions." << std::endl;
            return false;
        }
    } 
    else 
    {
        *data = (unsigned char*) malloc( sizeof( unsigned char) * width * height * *channels);
        *w = width;
        *h = height;
    }

    
    size_t fsize = 0;
    fsize = fread( *data, sizeof(unsigned char), width * height * *channels, fp);
    fclose(fp);

    return true;
}










bool LoadPPM4ub( const char* file, unsigned char** data, 
               unsigned int *w,unsigned int *h)
{
    unsigned char *idata = 0;
    unsigned int channels;
    
    if (loadPPM( file, &idata, w, h, &channels)) {
        
        int size = *w * *h;
        
        unsigned char* idata_orig = idata;
        *data = (unsigned char*) malloc( sizeof(unsigned char) * size * 4);
        unsigned char *ptr = *data;
        for(int i=0; i<size; i++) {
            *ptr++ = *idata++;
            *ptr++ = *idata++;
            *ptr++ = *idata++;
            *ptr++ = 0;
        }
        free( idata_orig);
        return true;
    }
    else
    {
        free( idata);
        return false;
    }
}












bool ComparePPM( const char *src_file, const char *ref_file, 
			  const float epsilon, const float threshold, bool verboseErrors )
{
	unsigned char *src_data, *ref_data;
	unsigned long error_count = 0;
	unsigned int ref_width, ref_height;
	unsigned int src_width, src_height;

	if (src_file == NULL || ref_file == NULL) {
		if(verboseErrors) std::cerr << "PPMvsPPM: src_file or ref_file is NULL.  Aborting comparison\n";
		return false;
	}

    if(verboseErrors) {
        std::cerr << "> Compare (a)rendered:  <" << src_file << ">\n";
        std::cerr << ">         (b)reference: <" << ref_file << ">\n";
    }

	if (LoadPPM4ub(ref_file, &ref_data, &ref_width, &ref_height) != true) 
	{
		if(verboseErrors) std::cerr << "PPMvsPPM: unable to load ref image file: "<< ref_file << "\n";
		return false;
	}

	if (LoadPPM4ub(src_file, &src_data, &src_width, &src_height) != true) 
	{
		std::cerr << "PPMvsPPM: unable to load src image file: " << src_file << "\n";
		return false;
	}

	if(src_height != ref_height || src_width != ref_width)
	{
		if(verboseErrors) std::cerr << "PPMvsPPM: source and ref size mismatch (" << src_width << 
			"," << src_height << ")vs(" << ref_width << "," << ref_height << ")\n";




	}

	if(verboseErrors) std::cerr << "PPMvsPPM: comparing images size (" << src_width << 
		"," << src_height << ") epsilon(" << epsilon << "), threshold(" << threshold*100 << "%)\n";

	if (Compareubt( ref_data, src_data, src_width*src_height*4, epsilon, threshold ) == false) 
	{
		error_count=1;
	}

	if (error_count == 0) 
	{ 
		if(verboseErrors) std::cerr << "    OK\n\n"; 
	} else 
	{
		if(verboseErrors) std::cerr << "    FAILURE!  "<<error_count<<" errors...\n\n";
	}
	return (error_count == 0);
}


