//{"majorRadius":3,"minorRadius":4,"output":0,"posX":1,"posY":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
constant sampler_t samplerInterpolation = 0 | 4 | 0x20;
bool outOfBounds(int2 pos, float radius, unsigned int width, unsigned int height) {
  return pos.x - radius < 0 || pos.y - radius < 0 || pos.x + radius >= width || pos.y + radius >= height;
}

kernel void createSegmentation(write_only image2d_t output, private float posX, private float posY, private float majorRadius, private float minorRadius) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float a = majorRadius;
  float b = minorRadius;
  float x = pos.x - posX;
  float y = pos.y - posY;

  float test = pow(x / a, 2.0f) + pow(y / b, 2.0f);

  if (test < 1) {
    write_imageui(output, pos, 3);
  }
}