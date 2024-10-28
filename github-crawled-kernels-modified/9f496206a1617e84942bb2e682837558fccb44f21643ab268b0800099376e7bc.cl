//{"c":3,"data":4,"i":0,"offset":2,"s":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(read_only image2d_t i, sampler_t s, constant float4* offset, float2 c, global float4* data) {
  *data = read_imagef(i, s, c) + *offset;
}