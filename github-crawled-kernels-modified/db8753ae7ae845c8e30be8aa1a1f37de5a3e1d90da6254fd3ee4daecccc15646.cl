//{"center":7,"inputImage":0,"iterations":3,"offset":8,"offsetOutput":2,"output":1,"rotation":5,"scale":4,"translate":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t SAMPLER_NEAREST = 0 | 2 | 0x10;
const sampler_t SAMPLER_NEAREST_CLAMP = 0 | 4 | 0x10;
constant const int2 zero = {0, 0};

kernel void directionalBlurKernel(read_only image2d_t inputImage, write_only image2d_t output, int2 offsetOutput, int iterations, float scale, float rotation, float2 translate, float2 center, int2 offset) {
  int2 coords = {get_global_id(0), get_global_id(1)};
  coords += offset;
  const int2 realCoordinate = coords + offsetOutput;

  float4 col;
  float2 ltxy = translate;
  float lsc = scale;
  float lrot = rotation;

  col = read_imagef(inputImage, SAMPLER_NEAREST, realCoordinate);

  for (int i = 0; i < iterations; ++i) {
    const float cs = cos(lrot), ss = sin(lrot);
    const float isc = 1.0f / (1.0f + lsc);

    const float v = isc * (realCoordinate.s1 - center.s1) + ltxy.s1;
    const float u = isc * (realCoordinate.s0 - center.s0) + ltxy.s0;
    float2 uv = {cs * u + ss * v + center.s0, cs * v - ss * u + center.s1};

    col += read_imagef(inputImage, SAMPLER_NEAREST_CLAMP, uv);

    ltxy += translate;
    lrot += rotation;
    lsc += scale;
  }

  col *= (1.0f / (iterations + 1));

  write_imagef(output, coords, col);
}