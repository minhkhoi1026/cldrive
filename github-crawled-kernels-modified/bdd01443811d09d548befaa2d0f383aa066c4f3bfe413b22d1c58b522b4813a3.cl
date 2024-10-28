//{"atten_func":1,"c_height":7,"c_offset":8,"c_width":6,"gradient":0,"height":4,"k_alpha":2,"level":9,"offset":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void atten_func(global float* gradient, global float* atten_func, global float* k_alpha, const int width, const int height, const int offset, const int c_width, const int c_height, const int c_offset, const int level) {
  int2 pos;
  int2 c_pos;
  int2 neighbour;
  float k_xy_atten_func;
  float k_xy_scale_factor;
  for (pos.y = get_global_id(1); pos.y < height; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < width; pos.x += get_global_size(0)) {
      if (gradient[hook(0, pos.x + pos.y * width + offset)] != 0) {
        c_pos = pos / 2;

        neighbour.x = (pos.x & 1) ? 1 : -1;
        neighbour.y = (pos.y & 1) ? 1 : -1;

        if ((c_pos.x + neighbour.x) < 0)
          neighbour.x = 0;
        if ((c_pos.y + neighbour.y) < 0)
          neighbour.y = 0;
        if ((c_pos.x + neighbour.x) >= c_width)
          neighbour.x = 0;
        if ((c_pos.y + neighbour.y) >= c_height)
          neighbour.y = 0;
        if (c_pos.x == c_width)
          c_pos.x -= 1;
        if (c_pos.y == c_height)
          c_pos.y -= 1;

        k_xy_atten_func = 9.0 * atten_func[hook(1, c_pos.x + c_pos.y * c_width + c_offset)] + 3.0 * atten_func[hook(1, c_pos.x + neighbour.x + c_pos.y * c_width + c_offset)] + 3.0 * atten_func[hook(1, c_pos.x + (c_pos.y + neighbour.y) * c_width + c_offset)] + 1.0 * atten_func[hook(1, c_pos.x + neighbour.x + (c_pos.y + neighbour.y) * c_width + c_offset)];

        k_xy_scale_factor = (k_alpha[hook(2, level)] / gradient[hook(0, pos.x + pos.y * width + offset)]) * pow(gradient[hook(0, pos.x + pos.y * width + offset)] / k_alpha[hook(2, level)], (float)0.5);
        atten_func[hook(1, pos.x + pos.y * width + offset)] = (1.f / 16.f) * (k_xy_atten_func)*k_xy_scale_factor;
      } else
        atten_func[hook(1, pos.x + pos.y * width + offset)] = 0.f;
    }
  }
}