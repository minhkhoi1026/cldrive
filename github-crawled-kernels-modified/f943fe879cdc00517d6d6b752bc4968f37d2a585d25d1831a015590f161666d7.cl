//{"f2":5,"f4":6,"i2":1,"i4":2,"output":0,"u2":3,"u4":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel2(global float* output, int2 i2, int4 i4, uint2 u2, uint4 u4, float2 f2, float4 f4) {
  output[hook(0, 0)] = (float)i2.x;
  output[hook(0, 1)] = (float)i2.y;

  output[hook(0, 2)] = (float)i4.x;
  output[hook(0, 3)] = (float)i4.y;
  output[hook(0, 4)] = (float)i4.z;
  output[hook(0, 5)] = (float)i4.w;

  output[hook(0, 6)] = (float)u2.x;
  output[hook(0, 7)] = (float)u2.y;

  output[hook(0, 8)] = (float)u4.x;
  output[hook(0, 9)] = (float)u4.y;
  output[hook(0, 10)] = (float)u4.z;
  output[hook(0, 11)] = (float)u4.w;

  output[hook(0, 12)] = f2.x;
  output[hook(0, 13)] = f2.y;

  output[hook(0, 14)] = f4.x;
  output[hook(0, 15)] = f4.y;
  output[hook(0, 16)] = f4.z;
  output[hook(0, 17)] = f4.w;
}