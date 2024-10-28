//{"a":5,"block":4,"height":3,"idata":1,"odata":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline int getLocalIdx(int i, int k, int num_systems) {
  return i + num_systems * k;
}

__inline float4 load(global float* a, int i) {
  return (float4)(a[hook(5, i)], a[hook(5, i + 1)], a[hook(5, i + 2)], a[hook(5, i + 3)]);
}

__inline void store(global float* a, int i, float4 v) {
  a[hook(5, i)] = v.x;
  a[hook(5, i + 1)] = v.y;
  a[hook(5, i + 2)] = v.z;
  a[hook(5, i + 3)] = v.w;
}

kernel void transpose(global float* odata, global float* idata, int width, int height, local float* block) {
  int blockIdxx = get_group_id(0);
  int blockIdxy = get_group_id(1);

  int threadIdxx = get_local_id(0);
  int threadIdxy = get_local_id(1);

  int i0 = mul24(blockIdxx, 2) + threadIdxx;
  int j0 = mul24(blockIdxy, 2) + threadIdxy;

  if (i0 >= width || j0 >= height)
    return;

  int i1 = mul24(blockIdxy, 2) + threadIdxx;
  int j1 = mul24(blockIdxx, 2) + threadIdxy;

  if (i1 >= height || j1 >= width)
    return;

  int idx_a = i0 + mul24(j0, width);
  int idx_b = i1 + mul24(j1, height);

  block[hook(4, threadIdxy * (2 + 1) + threadIdxx)] = idata[hook(1, idx_a)];

  barrier(0x01);

  odata[hook(0, idx_b)] = block[hook(4, threadIdxx * (2 + 1) + threadIdxy)];
}