//{"index":1,"state":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void random_WELL512(global long* state, global int* index) {
  unsigned long a, b, c, d;
  a = state[hook(0, index[0hook(1, 0))];
  c = state[hook(0, (index[0hook(1, 0) + 13) & 15)];
  b = a ^ c ^ (a << 16) ^ (c << 15);
  c = state[hook(0, (index[0hook(1, 0) + 9) & 15)];
  c ^= (c >> 11);
  a = state[hook(0, index[0hook(1, 0))] = b ^ c;
  d = a ^ ((a << 5) & 0xDA442D24UL);
  index[hook(1, 0)] = (index[hook(1, 0)] + 15) & 15;
  a = state[hook(0, index[0hook(1, 0))];
  state[hook(0, index[0hook(1, 0))] = a ^ b ^ d ^ (a << 2) ^ (b << 18) ^ (c << 28);
}