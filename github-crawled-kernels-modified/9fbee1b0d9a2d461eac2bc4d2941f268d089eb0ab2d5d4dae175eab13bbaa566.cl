//{"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void x2(global const unsigned int* input, global unsigned int* output, unsigned int width) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);
  unsigned int idx = y * width + x;
  unsigned int sum = input[hook(0, idx)];
  unsigned int i;
  unsigned int cnt = 0;
  unsigned int mask = 1;
  for (i = 0; i < 32; i++) {
    if (sum & mask)
      cnt++;
    mask = mask << 1;
  }
  output[hook(1, idx)] = cnt;
}