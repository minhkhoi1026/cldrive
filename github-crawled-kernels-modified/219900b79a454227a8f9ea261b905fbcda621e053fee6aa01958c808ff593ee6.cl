//{"dst1":2,"dst2":3,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_shuffle2(global float* src1, global float* src2, global float* dst1, global float* dst2) {
  int i = get_global_id(0);
  float2 x = (float2)(src1[hook(0, i)], src2[hook(1, i)]);
  float2 y = (float2)(1234, 5678);
  uint4 mask = (uint4)(1, 0, 0, 0);
  float4 v1 = shuffle2(x, y, mask);
  float16 x2 = 0;
  float16 y2 = (float16)(src1[hook(0, i)], src2[hook(1, i)], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  uint16 mask2 = (uint16)(17, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  float16 v2 = shuffle2(x2, y2, mask2);
  dst1[hook(2, i)] = v1.s0 + v2.s0;
  dst2[hook(3, i)] = v1.s1 + v2.s1;
}