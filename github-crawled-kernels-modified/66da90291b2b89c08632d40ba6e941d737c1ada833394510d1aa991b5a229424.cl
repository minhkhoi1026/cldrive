//{"a":2,"c":1,"i":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t s0 = 0 | 2 | 0x20;
constant sampler_t s1 = 0 | 2 | 0x10;
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(read_only image2d_t i, float2 c, global float4* a) {
  if (c.x < 0.0f) {
    *a = read_imagef(i, s0, c);
  } else {
    *a = read_imagef(i, s1, c);
  }
}