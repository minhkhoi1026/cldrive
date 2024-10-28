//{"f_out":2,"i1":0,"i2":1,"i_out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t s0 = 1 | 6 | 0x10;
const sampler_t s1 = 0 | 6 | 0x10;
kernel void foo(read_only image2d_t i1, read_only image2d_t i2, global float4* f_out, global int4* i_out) {
  *f_out = read_imagef(i1, s0, (float2)(0.0));
  *i_out = read_imagei(i2, s1, (float2)(0.0));
}