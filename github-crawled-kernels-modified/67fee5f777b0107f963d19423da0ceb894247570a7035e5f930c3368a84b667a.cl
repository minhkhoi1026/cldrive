//{"kptmap":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
constant int4 noval = (int4)(-1, -1, -1, -1);
kernel void init_kpt_map(write_only image2d_t kptmap) {
  write_imagei(kptmap, (int2)(get_global_id(0), get_global_id(1)), noval);
}