//{"bokehImage":2,"boundingBox":0,"dimension":8,"inputImage":1,"offset":9,"offsetInput":4,"offsetOutput":5,"output":3,"radius":6,"step":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t SAMPLER_NEAREST = 0 | 2 | 0x10;
const sampler_t SAMPLER_NEAREST_CLAMP = 0 | 4 | 0x10;
constant const int2 zero = {0, 0};

kernel void bokehBlurKernel(read_only image2d_t boundingBox, read_only image2d_t inputImage, read_only image2d_t bokehImage, write_only image2d_t output, int2 offsetInput, int2 offsetOutput, int radius, int step, int2 dimension, int2 offset) {
  int2 coords = {get_global_id(0), get_global_id(1)};
  coords += offset;
  float tempBoundingBox;
  float4 float3 = {0.0f, 0.0f, 0.0f, 0.0f};
  float4 multiplyer = {0.0f, 0.0f, 0.0f, 0.0f};
  float4 bokeh;
  const float radius2 = radius * 2.0f;
  const int2 realCoordinate = coords + offsetOutput;
  int2 imageCoordinates = realCoordinate - offsetInput;

  tempBoundingBox = read_imagef(boundingBox, SAMPLER_NEAREST, coords).s0;

  if (tempBoundingBox > 0.0f && radius > 0) {
    const int2 bokehImageDim = get_image_dim(bokehImage);
    const int2 bokehImageCenter = bokehImageDim / 2;
    const int2 minXY = max(realCoordinate - radius, zero);
    const int2 maxXY = min(realCoordinate + radius, dimension);
    int nx, ny;

    float2 uv;
    int2 inputXy;

    if (radius < 2) {
      float3 = read_imagef(inputImage, SAMPLER_NEAREST, imageCoordinates);
      multiplyer = (float4)(1.0f, 1.0f, 1.0f, 1.0f);
    }

    for (ny = minXY.y, inputXy.y = ny - offsetInput.y; ny < maxXY.y; ny += step, inputXy.y += step) {
      uv.y = ((realCoordinate.y - ny) / radius2) * bokehImageDim.y + bokehImageCenter.y;

      for (nx = minXY.x, inputXy.x = nx - offsetInput.x; nx < maxXY.x; nx += step, inputXy.x += step) {
        uv.x = ((realCoordinate.x - nx) / radius2) * bokehImageDim.x + bokehImageCenter.x;
        bokeh = read_imagef(bokehImage, SAMPLER_NEAREST, uv);
        float3 += bokeh * read_imagef(inputImage, SAMPLER_NEAREST, inputXy);
        multiplyer += bokeh;
      }
    }
    float3 /= multiplyer;
  } else {
    float3 = read_imagef(inputImage, SAMPLER_NEAREST, imageCoordinates);
  }

  write_imagef(output, coords, float3);
}