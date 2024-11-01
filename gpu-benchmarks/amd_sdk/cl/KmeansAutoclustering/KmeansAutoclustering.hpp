


#ifndef KMEANS_H_
#define KMEANS_H_
#include <GL/glut.h>
#include "CLUtil.hpp"
#include <map>

using namespace appsdk;

#define GROUP_SIZE      64
#define MAX_FLOAT       0x1.FFFFFEp127f
#define PI 3.14159265
#define ALIGNMENT 4096
#define uint unsigned int
#define MAX_COORD 10
#define MAX_PERCENT_TOLERENCE 1.0
#define MAX_CLUSTERS 16
#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef max
#define max(a,b) (((a) > (b)) ? (a) : (b))
#endif



class KMeans
{
private:
    cl_double setupTime;                
    cl_double kernelTime;               
    cl_double refImplTime;               

    cl_float2 *refPointPos;             
    cl_uint *refKMeansCluster;  
    cl_float2 *refCentroidPos;         
    cl_float2 *newCentroidPos;          
    cl_float2 *refNewCentroidPos;       
    cl_uint *centroidPtsCount;          
    cl_uint *refCentroidPtsCount;          
    cl_float *silhouetteValue;          
    std::map<int,float> silhouettesMap, refSilhouettesMap;
    int lowerBoundForClustering;   
    int upperBoundForClustering;   
    
    bool isSaturated;               
    int bestClusterNums;            
    int numPoints;      
    float bestSilhouetteValue;
    bool isNumClustersSpecified;    
    int numClusters;    
    static const unsigned int vecLen = 4;

    cl_context context;                 
    cl_device_id *devices;              
    cl_mem clPointPos;                  
    cl_mem clKMeansCluster;             
    cl_mem clCentroidPos;           
    cl_mem clNewCentroidPos;            
    cl_mem clCentroidPtsCount;             
    cl_mem clSilhoutteValue;            
    cl_command_queue commandQueue;      
    cl_program program;                 
    cl_kernel kernelAssignCentroid, kernelComputeSilhouette;         
    size_t groupSize;                   

    int iterations;
    float erfc;
    int maxIter;                   
    
    
    int randClusterNums;        
    
    SDKDeviceInfo         deviceInfo;            
    KernelWorkGroupInfo        kernelInfo;      
    SDKTimer    *sampleTimer;                   

public:
    CLCommandArgs   *sampleArgs;   
    float random(int randMax, int randMin);
    int sanityCheck();
    int computeKMeans(int);
    int computeSilhouette(int, float&);
    int computeRefKMeans(int);
    int computeRefSilhouette(int, float&);
    void setInitialCentroidPos(int);
    void initializeCentroidPos(void *, int);
    void initializeCentroidPos(cl_mem, int);
    float getSilhouetteMapValue(int);
    bool getIsNumClustersSpecified();
    bool getIsSaturated();
    void setIsSaturated(bool val);
    int getNumClusters();
    int getNumPoints();
    float getBestSilhouetteValue();
    int getBestClusterNums();
    cl_mem getclCentroidPos();
    template<typename T> int mapBuffer(cl_mem, T* &, size_t, cl_map_flags);
    int unmapBuffer(cl_mem, void*);

    cl_float2 *pointPos;                
    cl_uint *KMeansCluster;             
    cl_float2 *centroidPos;         
    cl_float2 *backupCentroidPos;

    
    
    

    
    explicit KMeans():
        setupTime(0),
        kernelTime(0),
        refImplTime(0),
        pointPos(NULL),
        refPointPos(NULL),
        KMeansCluster(NULL),
        refKMeansCluster(NULL),
        centroidPos(NULL),
        refCentroidPos(NULL),
        newCentroidPos(NULL),
        refNewCentroidPos(NULL),
        centroidPtsCount(NULL),
        refCentroidPtsCount(NULL),
        clPointPos(NULL),
        clKMeansCluster(NULL),
        clCentroidPos(NULL),
        clNewCentroidPos(NULL),
        clCentroidPtsCount(NULL),
        devices(NULL),
        groupSize(GROUP_SIZE),
        iterations(1),
        isSaturated(false)
    {
        erfc = 1e-2;
        maxIter = 50;
        numPoints = 1024;
        numClusters = 0;
        lowerBoundForClustering = 2;
        upperBoundForClustering = 10;
        bestClusterNums = 0;
        bestSilhouetteValue = -1;
        isNumClustersSpecified = false;

        
        
        randClusterNums = 0;
        sampleArgs = new CLCommandArgs();
        sampleTimer = new SDKTimer();
    }

    ~KMeans();

    
    int checkCentroidSaturation(int);

    
    int setupKMeans();

    
    int genBinaryImage();

    
    int setupCL();

    
    int setupCLKernels();

    
    int runCLKernels();

    
    void KMeansCPUReference();

    
    void printStats();

    
    int initialize();

    
    int setup();

    
    int run();

    
    int cleanup();

    
    int verifyResults();
};

#endif 

