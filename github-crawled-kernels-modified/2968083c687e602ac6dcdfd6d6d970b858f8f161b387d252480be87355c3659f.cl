//{"A":0,"coord":3,"im":1,"sam":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 bar(float2 coord, read_only image2d_t im) {
  return coord + (float2)(2.5, 2.5);
}

kernel void foo(global float4* A, read_only image2d_t im, sampler_t sam, float2 coord) {
  *A = read_imagef(im, sam, bar(coord, im));
}