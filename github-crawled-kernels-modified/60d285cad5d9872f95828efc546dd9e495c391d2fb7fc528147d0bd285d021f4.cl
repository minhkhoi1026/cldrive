//{"dst1":2,"dst2":3,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_shuffle(global float* src1, global float* src2, global float* dst1, global float* dst2) {
  int i = get_global_id(0);
  float2 src = (float2)(src1[hook(0, i)], src2[hook(1, i)]);
  uint2 mask = (uint2)(1, 0);
  float2 dst = shuffle(src, mask);
  dst1[hook(2, i)] = dst.s0;
  dst2[hook(3, i)] = dst.s1;
}