//{"divider":5,"g_height":3,"g_width":2,"gradient":1,"lum":0,"offset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void gradient_mag(global float* lum, global float* gradient, const int g_width, const int g_height, const int offset, const float divider) {
  int x_west;
  int x_east;
  int y_north;
  int y_south;
  float x_grad;
  float y_grad;
  int2 pos;
  for (pos.y = get_global_id(1); pos.y < g_height; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < g_width; pos.x += get_global_size(0)) {
      x_west = clamp(pos.x - 1, 0, g_width - 1);
      x_east = clamp(pos.x + 1, 0, g_width - 1);
      y_north = clamp(pos.y - 1, 0, g_height - 1);
      y_south = clamp(pos.y + 1, 0, g_height - 1);

      x_grad = (lum[hook(0, x_west + pos.y * g_width + offset)] - lum[hook(0, x_east + pos.y * g_width + offset)]) / divider;
      y_grad = (lum[hook(0, pos.x + y_south * g_width + offset)] - lum[hook(0, pos.x + y_north * g_width + offset)]) / divider;

      gradient[hook(1, pos.x + pos.y * g_width + offset)] = sqrt(pow(x_grad, 2.f) + pow(y_grad, 2.f));
    }
  }
}