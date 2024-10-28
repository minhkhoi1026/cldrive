//{"b":2,"c":3,"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefix_sum(global int* dst, global int* src, local int* b, local int* c) {
  const int g_id = get_global_id(0);
  const int len = get_global_size(0);

  int value = src[hook(1, g_id)];
  b[hook(2, g_id)] = value;
  c[hook(3, g_id)] = value;
  barrier(0x01);

  for (int offset = 1; offset < len; offset <<= 1) {
    if (g_id >= offset) {
      c[hook(3, g_id)] = b[hook(2, g_id)] + b[hook(2, g_id - offset)];
    } else {
      c[hook(3, g_id)] = b[hook(2, g_id)];
    }

    barrier(0x01);
    {
      local int* tmp = b;
      b = c;
      c = tmp;
    };
  }

  dst[hook(0, g_id)] = b[hook(2, g_id)];

  barrier(0x02);
}