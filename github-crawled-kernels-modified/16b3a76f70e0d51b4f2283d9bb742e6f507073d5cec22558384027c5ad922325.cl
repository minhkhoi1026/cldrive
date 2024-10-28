//{"discreet_laplacian":3,"discreet_laplacian[1 + i]":2,"input_image":0,"output_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
constant const float sampling_kernel[5] = {01.f / 16.f, 04.f / 16.f, 06.f / 16.f, 04.f / 16.f, 01.f / 16.f};

inline float sigma_squared_rgb(float4 pixel) {
  float4 squared = pown(pixel, 2);
  float mean = ((float)pixel.s0 + pixel.s1 + pixel.s2) / 3.0f;
  float mean_squared = pown(mean, 2);
  float mean_of_squared = ((float)squared.s0 + squared.s1 + squared.s2) / 3.0f;

  return sqrt(fabs(mean_of_squared - mean_squared));
}

inline float well_exposedness(float4 pixel) {
  float4 component_wise = 0.5f + cospi(1.75f * (pixel - 0.5f));

  return component_wise.s0 + component_wise.s1 + component_wise.s2;
}

inline float well_exposedness_naive(float4 pixel) {
  float const denominator = 0.08f;
  float4 component_wise = exp((float4) - (pown(pixel - 0.5f, 2) / denominator));

  return component_wise.s0 + component_wise.s1 + component_wise.s2;
}

constant const float discreet_laplacian[3][3] = {0.5f / 6.f, 1.f / 6.f, 0.5f / 6.f, 1.f / 6.f, -1.f, 1.f / 6.f, 0.5f / 6.f, 1.f / 6.f, 0.5f / 6.f};

kernel void compute_quality(read_only image2d_t input_image, write_only image2d_t output_image) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 laplacian = 0.0f;
  for (int i = -1; i < 2; ++i) {
    for (int j = -1; j < 2; ++j) {
      laplacian += read_imagef(input_image, g_sampler, coord + (int2)(i, j)) * discreet_laplacian[hook(3, 1 + i)][hook(2, 1 + j)];
    }
  }

  float laplacian_measure = fast_length(fabs(laplacian));

  float4 pixel = read_imagef(input_image, g_sampler, coord);

  float sigma = sigma_squared_rgb(pixel);
  float exposedness = well_exposedness_naive(pixel);

  pixel.s3 = (laplacian_measure * 3.0f) + (sigma * 1.5f) + (exposedness * 0.2f);

  write_imagef(output_image, coord, pixel);
}