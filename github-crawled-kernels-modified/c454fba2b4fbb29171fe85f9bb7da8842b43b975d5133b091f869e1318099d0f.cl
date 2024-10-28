//{"atten_func":1,"gradient":0,"height":4,"k_alpha":2,"offset":5,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void coarsest_level_attenfunc(global float* gradient, global float* atten_func, global float* k_alpha, const int width, const int height, const int offset) {
  for (int gid = get_global_id(0); gid < width * height; gid += get_global_size(0)) {
    atten_func[hook(1, gid + offset)] = (k_alpha[hook(2, 0)] / gradient[hook(0, gid + offset)]) * pow(gradient[hook(0, gid + offset)] / k_alpha[hook(2, 0)], (float)0.5);
  }
}