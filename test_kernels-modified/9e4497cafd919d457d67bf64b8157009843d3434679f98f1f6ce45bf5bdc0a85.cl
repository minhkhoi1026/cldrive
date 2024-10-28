//{"buf_size":2,"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memsum(global float4* dst, global float4* src, const int buf_size) {
  unsigned int gid = get_global_id(0);
  float4 sum = (float4)0.0f;
  for (int i = 0; i < buf_size; i++) {
    sum += src[hook(1, i)];
  }
  dst[hook(0, gid)] = sum;
}