//{"data":0,"output":1,"size":2,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void readGlobalMemory(global float* data, global float* output, int size, int stride) {
  int gid = get_global_id(0);
  int j = 0;
  float sum = 0;
  int s = gid * stride;
  for (j = 0; j < 1024; ++j) {
    float a0 = data[hook(0, (s + 0) & (size - 1))];
    float a1 = data[hook(0, (s + 15360) & (size - 1))];
    float a2 = data[hook(0, (s + 30720) & (size - 1))];
    float a3 = data[hook(0, (s + 46080) & (size - 1))];
    float a4 = data[hook(0, (s + 61440) & (size - 1))];
    float a5 = data[hook(0, (s + 76800) & (size - 1))];
    float a6 = data[hook(0, (s + 92160) & (size - 1))];
    float a7 = data[hook(0, (s + 107520) & (size - 1))];
    float a8 = data[hook(0, (s + 122880) & (size - 1))];
    float a9 = data[hook(0, (s + 138240) & (size - 1))];
    float a10 = data[hook(0, (s + 153600) & (size - 1))];
    float a11 = data[hook(0, (s + 168960) & (size - 1))];
    float a12 = data[hook(0, (s + 184320) & (size - 1))];
    float a13 = data[hook(0, (s + 199680) & (size - 1))];
    float a14 = data[hook(0, (s + 215040) & (size - 1))];
    float a15 = data[hook(0, (s + 230400) & (size - 1))];
    sum += a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + a15;
    s = (s + 245760) & (size - 1);
  }
  output[hook(1, gid)] = sum;
}