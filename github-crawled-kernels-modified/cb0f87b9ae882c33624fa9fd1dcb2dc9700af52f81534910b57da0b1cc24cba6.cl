//{"dimx":1,"dual":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t image_sampler = 0 | 2 | 0x10;
constant float2 zero2 = (float2)(0.0f, 0.0f);
kernel void init_dual(global float2* dual, int dimx) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  dual[hook(0, mad24(coord.y, dimx, coord.x))] = zero2;
}