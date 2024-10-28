#define CL_USE_DEPRECATED_OPENCL_1_1_APIS
#define REDUCTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define DEFAULT_INPUT_SIZE 1024
#define VALUES_PRINTED 20
#define INIT_CL_EXT_FCN_PTR(name) \
#define FLUID_SIMULATION2D_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE  256
#define LBWIDTH     256
#define LBHEIGHT    256
#define TEMPLATE_H_
#define SDK_SUCCESS 0
#define SDK_FAILURE 1
#define BUFFER_BANDWIDTH_H_
#define  MAX_WAVEFRONT_SIZE 64
#define BLACK_SCHOLES_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define FASTWALSHTRANSFORM_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BITONICSORT_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define REDUCTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define VECTOR_SIZE 4
#define MULTIPLY  2
#define LUDECOMPOSITION_HPP_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define KERNELFILE "LUDecomposition_Kernels.cl"
#define COMMON_DECLARE_HPP__
#define DISPLAY_DEVICE_ACTIVE    0x00000001
#define clGetGLContextInfoKHR clGetGLContextInfoKHR_proc
#define BOX_FILTER_GL_SAT_H_
#define INPUT_IMAGE "BoxFilterGL_Input.bmp"
#define OUTPUT_SAT_IMAGE "BoxFilterGLSAT_Output.bmp"
#define GROUP_SIZE 256
#define FILTER 9
#define SAT_FETCHES 16
#define min(a,b) (((a) < (b)) ? (a) : (b))
#define screenWidth  512
#define screenHeight 512
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BOX_FILTER_GL_SEPARABLE_H_
#define INPUT_IMAGE "BoxFilterGL_Input.bmp"
#define OUTPUT_SEPARABLE_IMAGE "BoxFilterGLSeparable_Output.bmp"
#define GROUP_SIZE 256
#define FILTER_WIDTH 9
#define GAUSSIAN_NOISE_GL_SEPARABLE_H_
#define INPUT_IMAGE "GaussianNoiseGL_Input.bmp"
#define OUTPUT_SEPARABLE_IMAGE "GaussianNoiseGL_Output.bmp"
#define GROUP_SIZE 64
#define FACTOR 60
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define COMMON_DECLARE_HPP__
#define DISPLAY_DEVICE_ACTIVE    0x00000001
#define clGetGLContextInfoKHR clGetGLContextInfoKHR_proc
#define __MANDELBROTGL_H_
#define GLUT_ESCAPE_KEY (27)
#define MANDELBROT_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MAX_ITER 16384
#define MIN_ITER 32
#define MAX_DEVICES 4
#define MATRIXTRANSPOSE_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BINOMIAL_OPTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define RISKFREE 0.02f
#define VOLATILITY 0.30f
#define SOBEL_FILTER_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define INPUT_IMAGE "SobelFilter_Input.bmp"
#define OUTPUT_IMAGE "SobelFilter_Output.bmp"
#define GROUP_SIZE 256
#define SIMPLECONVOLUTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define QUASIRANDOMSEQUENCE_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define N_DIRECTIONS 32
#define MAX_DIMENSIONS 10200
#define GROUP_SIZE 256
#define SOBOL_PRIMITIVES_H
#define max_m 17
#define BINOMIAL_OPTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define CHECK_OPENCL_ERROR_RETURN_NULL(actual, msg) \
#define RISKFREE 0.02f
#define VOLATILITY 0.30f
#define BINARYSEARCH_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MATRIXMULTIPLICATION_IMAGE_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define SIMPLE_IMAGE_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define INPUT_IMAGE "SimpleImage_Input.bmp"
#define OUTPUT_IMAGE "SimpleImage_Output.bmp"
#define GROUP_SIZE 256
#define min(a, b)            (((a) < (b)) ? (a) : (b))
#define BOX_FILTER_SEPARABLE_H_
#define INPUT_IMAGE "BoxFilter_Input.bmp"
#define OUTPUT_IMAGE "BoxFilter_Output.bmp"
#define GROUP_SIZE 256
#define FILTER_WIDTH 8
#define BOX_FILTER_SAT_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define INPUT_IMAGE "BoxFilter_Input.bmp"
#define OUTPUT_IMAGE "BoxFilter_Output.bmp"
#define GROUP_SIZE 256
#define FILTER 6
#define SAT_FETCHES 16
#define min(a,b) (((a) < (b)) ? (a) : (b))
#define URNG_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define INPUT_IMAGE "URNG_Input.bmp"
#define OUTPUT_IMAGE "URNG_Output.bmp"
#define GROUP_SIZE 64
#define FACTOR 25
#define REDUCTION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define REMOVE_GPU  1
#define GROUP_SIZE 256
#define DEFAULT_INPUT_SIZE 1024
#define VALUES_PRINTED 20
#define INIT_CL_EXT_FCN_PTR(name) \
#define MATRIXMULTIPLICATION_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MULTI_DEVICE_H_
#define KERNEL_ITERATIONS 100
#define GROUP_SIZE 64
#define NUM_THREADS 1024 * 64
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define HISTOGRAM_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define WIDTH 1024
#define HEIGHT 1024
#define BIN_SIZE 256
#define GROUP_SIZE 128
#define GROUP_ITERATIONS (BIN_SIZE / 2)
#define SUB_HISTOGRAM_COUNT ((WIDTH * HEIGHT) /(GROUP_SIZE * GROUP_ITERATIONS))
#define STRINGSEARCH_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define LOCAL_SIZE      256
#define COMPARE(x,y)    ((caseSensitive) ? (x==y) : (toupper(x) == toupper(y)))
#define SEARCH_BYTES_PER_WORKITEM   512
#define MONTECARLOASIAN_H_
#define GROUP_SIZE 256
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define CHECK_OPENCL_ERROR_RETURN_NULL(actual, msg) \
#define DISPLAY_DEVICE_ACTIVE    0x00000001
#define screenWidth  512
#define screenHeight 512
#define GROUP_SIZE 256
#define WINDOW_WIDTH 512
#define WINDOW_HEIGHT 512
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define clGetGLContextInfoKHR clGetGLContextInfoKHR_proc
#define RADIXSORT_H_
#define max(a,b) (((a) > (b)) ? (a) : (b))
#define min(a,b) (((a) < (b)) ? (a) : (b))
#define ELEMENT_COUNT (8192)
#define RADIX 8
#define RADICES (1 << RADIX)
#define RADIX_MASK (RADICES - 1)
#define GROUP_SIZE 64
#define NUM_GROUPS (ELEMENT_COUNT / (GROUP_SIZE * RADICES))
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define DWTHAAR1D_H_
#define SIGNAL_LENGTH (1 << 10)
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define RECURSIVE_GAUSSIAN_H_
#define INPUT_IMAGE "RecursiveGaussian_Input.bmp"
#define OUTPUT_IMAGE "RecursiveGaussian_Output.bmp"
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define DCT_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define M_PI (3.14159265358979323846f)
#define MONTECARLOASIANDP_H_
#define GROUP_SIZE 256
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define NBODY_H_
#define GROUP_SIZE 128
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BUFFER_BANDWIDTH_H_
#define  GROUP_SIZE 256
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE      64
#define MAX_FLOAT       0x1.FFFFFEp127f
#define PI 3.14159265
#define ALIGNMENT 4096
#define uint unsigned int
#define MAX_COORD 10
#define MAX_PERCENT_TOLERENCE 1.0
#define MAX_CLUSTERS 16
#define min(a,b) (((a) < (b)) ? (a) : (b))
#define max(a,b) (((a) > (b)) ? (a) : (b))
#define _SCANLARGEARRAYS_H_
#define max(a, b) (((a) > (b)) ? (a) : (b))
#define min(a, b) (((a) < (b)) ? (a) : (b))
#define GROUP_SIZE 256
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BUFFER_BANDWIDTH_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define  MAX_WAVEFRONT_SIZE 64
#define SIMPLE_IMAGE_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MAP_IMAGE "ImageOverlap_map.bmp"
#define MAP_VERIFY_IMAGE "ImageOverlap_verify_map.bmp"
#define GROUP_SIZE 256
#define min(a, b)            (((a) < (b)) ? (a) : (b))
#define PREFIXSUM_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define BLACK_SCHOLES_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define GROUP_SIZE 256
#define FLOYDWARSHALL_H_
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MAXDISTANCE    (200)
#define BUFFER_IMAGE_INTEROP_H_
#define INPUT_IMAGE "BufferImageInterop_Input.bmp"
#define OUTPUT_IMAGE "BufferImageInterop_Output.bmp"
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define MONTECARLOASIAN_H_
#define GROUP_SIZE 64
#define VECTOR_SIZE 4
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
