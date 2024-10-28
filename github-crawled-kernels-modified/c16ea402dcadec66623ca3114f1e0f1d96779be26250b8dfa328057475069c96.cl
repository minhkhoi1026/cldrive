//{"image":0,"n":1,"radius":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void highPassFilter(global float2* image, int n, int radius) {
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);

  int2 n_2 = (int2)(n >> 1, n >> 1);
  int2 mask = (int2)(n - 1, n - 1);

  int2 gid = ((int2)(xgid, ygid) + n_2) & mask;

  int2 diff = n_2 - gid;
  int2 diff2 = diff * diff;
  int dist2 = diff2.x + diff2.y;

  int2 window;

  if (dist2 < radius * radius) {
    window = (int2)(0L, 0L);
  } else {
    window = (int2)(-1L, -1L);
  }

  image[hook(0, ygid * n + xgid)] = __builtin_astype((__builtin_astype((image[hook(0, ygid * n + xgid)]), int2) & window), float2);
}