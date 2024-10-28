//{"output":0,"size":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void writeGlobalMemory(global float* output, int size, int stride) {
  int gid = get_global_id(0);
  int j = 0;
  int s = gid * stride;
  for (j = 0; j < 1024; ++j) {
    output[hook(0, (s + 0) & (size - 1))] = gid;
    output[hook(0, (s + 15360) & (size - 1))] = gid;
    output[hook(0, (s + 30720) & (size - 1))] = gid;
    output[hook(0, (s + 46080) & (size - 1))] = gid;
    output[hook(0, (s + 61440) & (size - 1))] = gid;
    output[hook(0, (s + 76800) & (size - 1))] = gid;
    output[hook(0, (s + 92160) & (size - 1))] = gid;
    output[hook(0, (s + 107520) & (size - 1))] = gid;
    output[hook(0, (s + 122880) & (size - 1))] = gid;
    output[hook(0, (s + 138240) & (size - 1))] = gid;
    output[hook(0, (s + 153600) & (size - 1))] = gid;
    output[hook(0, (s + 168960) & (size - 1))] = gid;
    output[hook(0, (s + 184320) & (size - 1))] = gid;
    output[hook(0, (s + 199680) & (size - 1))] = gid;
    output[hook(0, (s + 215040) & (size - 1))] = gid;
    output[hook(0, (s + 230400) & (size - 1))] = gid;
    s = (s + 245760) & (size - 1);
  }
}