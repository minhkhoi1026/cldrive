//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buffer(global const float* a, global float* b) {
  int w = get_global_size(0);
  int h = get_global_size(1);
  int x = get_global_id(0);
  int y = get_global_id(1);

  float acc = 0;

  for (int i = 0; i < 8; i++) {
    int is = ((i * x) ^ (y + i)) % (w * h);
    acc += a[hook(0, is)];
  }

  acc = acc / 64;

  int id = (w - 1 - x) + w * (h - 1 - y);
  b[hook(1, id)] = acc;
}