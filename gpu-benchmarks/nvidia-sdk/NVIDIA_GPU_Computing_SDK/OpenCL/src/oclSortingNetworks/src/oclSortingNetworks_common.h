




typedef unsigned int uint;




extern "C" int validateSortedKeys(
    uint *result,
    uint *data,
    uint batch,
    uint N,
    uint numValues,
    uint dir,
    uint *srcHist,
    uint *resHist
);

extern "C" void fillValues(
    uint *val,
    uint N
);

extern "C" int validateSortedValues(
    uint *resKey,
    uint *resVal,
    uint *srcKey,
    uint batchSize,
    uint arrayLength
);

extern "C" int validateValues(
    uint *oval,
    uint *okey,
    uint N
);




extern "C" void initBitonicSort(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);

extern "C" void closeBitonicSort(void);

extern"C" size_t bitonicSort(
    cl_command_queue cqCommandQueue,
    cl_mem d_DstKey,
    cl_mem d_DstVal,
    cl_mem d_SrcKey,
    cl_mem d_SrcVal,
    uint batch,
    uint arrayLength,
    uint dir
);
