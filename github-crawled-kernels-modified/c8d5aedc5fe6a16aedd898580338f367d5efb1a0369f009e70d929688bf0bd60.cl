//{"input":1,"n":0,"output":2,"p0":3,"p1":4,"p2":5,"p3":6,"p4":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float4 polyeval4d(float p0, float p1, float p2, float p3, float p4, float4 x) {
  return mad(x, mad(x, mad(x, mad(x, p4, p3), p2), p1), p0);
}

kernel void gpuStress(unsigned int n, const global float4* input, global float4* output, float p0, float p1, float p2, float p3, float p4) {
  size_t gid = get_global_id(0);

  for (unsigned int i = 0; i < 64; i++) {
    float4 x1 = input[hook(1, gid * 4)];
    float4 x2 = input[hook(1, gid * 4 + 1)];
    float4 x3 = input[hook(1, gid * 4 + 2)];
    float4 x4 = input[hook(1, gid * 4 + 3)];
    for (unsigned int j = 0; j < 64; j++) {
      x1 = polyeval4d(p0, p1, p2, p3, p4, x1);
      x2 = polyeval4d(p0, p1, p2, p3, p4, x2);
      x3 = polyeval4d(p0, p1, p2, p3, p4, x3);
      x4 = polyeval4d(p0, p1, p2, p3, p4, x4);
    }

    output[hook(2, gid * 4)] = x1;
    output[hook(2, gid * 4 + 1)] = x2;
    output[hook(2, gid * 4 + 2)] = x3;
    output[hook(2, gid * 4 + 3)] = x4;

    gid += get_global_size(0);
  }
}