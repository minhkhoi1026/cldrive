//{"dimension":6,"distanceSquared":5,"inputImage":0,"offset":7,"offsetInput":2,"offsetOutput":3,"output":1,"scope":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t SAMPLER_NEAREST = 0 | 2 | 0x10;
const sampler_t SAMPLER_NEAREST_CLAMP = 0 | 4 | 0x10;
constant const int2 zero = {0, 0};

kernel void dilateKernel(read_only image2d_t inputImage, write_only image2d_t output, int2 offsetInput, int2 offsetOutput, int scope, int distanceSquared, int2 dimension, int2 offset) {
  int2 coords = {get_global_id(0), get_global_id(1)};
  coords += offset;
  const int2 realCoordinate = coords + offsetOutput;

  const int2 minXY = max(realCoordinate - scope, zero);
  const int2 maxXY = min(realCoordinate + scope, dimension);

  float value = 0.0f;
  int nx, ny;
  int2 inputXy;

  for (ny = minXY.y, inputXy.y = ny - offsetInput.y; ny < maxXY.y; ny++, inputXy.y++) {
    const float deltaY = (realCoordinate.y - ny);
    for (nx = minXY.x, inputXy.x = nx - offsetInput.x; nx < maxXY.x; nx++, inputXy.x++) {
      const float deltaX = (realCoordinate.x - nx);
      const float measuredDistance = deltaX * deltaX + deltaY * deltaY;
      if (measuredDistance <= distanceSquared) {
        value = max(value, read_imagef(inputImage, SAMPLER_NEAREST, inputXy).s0);
      }
    }
  }

  float4 float3 = {value, 0.0f, 0.0f, 0.0f};
  write_imagef(output, coords, float3);
}