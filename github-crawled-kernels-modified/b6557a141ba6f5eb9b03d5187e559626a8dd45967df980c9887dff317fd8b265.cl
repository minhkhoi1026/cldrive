//{"image":0,"out":2,"s":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_int(read_only image1d_array_t image, sampler_t s, global int4* out) {
  out[hook(2, 0)] = read_imagei(image, s, (float2)(0));
  out[hook(2, 1)] = read_imagei(image, s, (int2)(0));
  out[hook(2, 2)] = read_imagei(image, (int2)(0));
}