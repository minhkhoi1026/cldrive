


#pragma OPENCL EXTENSION cl_khr_fp64 : enable
__kernel void sepiaToning(__global uchar4 *inputImage,
                          __global uchar4 *outputImage)
{
    int dim = get_global_id(0);
    int dim1 = get_global_id(1);

    int width = get_global_size(0);

    int red, green, blue;

    int index = dim + width * dim1;

    red = inputImage[index].x;
    green = inputImage[index].y;
    blue = inputImage[index].z;

    float grayscale = (0.3 * red + 0.59 * green + 0.11 * blue);



    float depth = 1.8;

    red = (int)(grayscale + depth * 56.6 );
    if (red > 255)
    {
        red = 255;
    }

    green = (int)(grayscale + depth * 33.3 );
    if (green > 255)
    {
        green = 255;
    }

    blue = (int)(grayscale + depth * 10.1);

    if (blue > 255)
    {
        blue = 255;
    }
    if (dim == 1 && dim1 == 0)
    {
        
    }
    outputImage[index].x = red;
    outputImage[index].y = green;
    outputImage[index].z = blue;
    outputImage[index].w = inputImage[index].w;
}


__kernel void imageReverse(__read_only image2d_t inputImage,
                           __write_only image2d_t outputImage)
{
    int x = get_global_id(0);
    int y = get_global_id(1);
    int width = get_global_size(0);
    width--;
    int2 coord;
    coord.x = x;
    coord.y = y;

    sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP |
                        CLK_FILTER_NEAREST;

    uint4 pixel = read_imageui(inputImage, sampler, coord);

    coord.x = width-x;

    write_imageui(outputImage, coord, pixel);
}
