//{"in":0,"limit":2,"out":1,"temp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cfc(global const int* in, global int* out, int limit) {
  size_t x = get_global_id(0);

  int temp[32];
  for (int i = 0; i < 32; ++i) {
    temp[hook(3, i)] = in[hook(0, i)];
  }

  if (x < limit) {
    out[hook(1, x)] = x;
  } else {
    out[hook(1, x)] = temp[hook(3, x % 32)];
  }
}