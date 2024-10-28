//{"dimension":5,"filter_size":4,"gausstab":6,"inputImage":0,"offset":7,"offsetInput":1,"offsetOutput":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t SAMPLER_NEAREST = 0 | 2 | 0x10;
const sampler_t SAMPLER_NEAREST_CLAMP = 0 | 4 | 0x10;
constant const int2 zero = {0, 0};

kernel void gaussianYBlurOperationKernel(read_only image2d_t inputImage, int2 offsetInput, write_only image2d_t output, int2 offsetOutput, int filter_size, int2 dimension, global float* gausstab, int2 offset) {
  float4 float3 = {0.0f, 0.0f, 0.0f, 0.0f};
  int2 coords = {get_global_id(0), get_global_id(1)};
  coords += offset;
  const int2 realCoordinate = coords + offsetOutput;
  int2 inputCoordinate = realCoordinate - offsetInput;
  float weight = 0.0f;

  int ymin = max(realCoordinate.y - filter_size, 0) - offsetInput.y;
  int ymax = min(realCoordinate.y + filter_size + 1, dimension.y) - offsetInput.y;

  for (int ny = ymin, i = max(filter_size - realCoordinate.y, 0); ny < ymax; ++ny, ++i) {
    float w = gausstab[hook(6, i)];
    inputCoordinate.y = ny;
    float3 += read_imagef(inputImage, SAMPLER_NEAREST, inputCoordinate) * w;
    weight += w;
  }

  float3 *= (1.0f / weight);

  write_imagef(output, coords, float3);
}