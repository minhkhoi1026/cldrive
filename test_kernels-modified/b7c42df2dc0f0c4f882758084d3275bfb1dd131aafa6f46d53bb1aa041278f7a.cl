//{"config":0,"keys":1,"values":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelBitonic_B2(global unsigned int* restrict config, global unsigned int* restrict keys, global unsigned int* restrict values) {
  unsigned int inc = config[hook(0, 0)];
  unsigned int dir = config[hook(0, 1)];
  int t = get_global_id(0);
  int low = t & (inc - 1);
  int i = (t << 1) - low;
  bool reverse = ((dir & i) == 0);
  keys += i;
  values += i;

  unsigned int k0 = keys[hook(1, 0)];
  unsigned int v0 = values[hook(2, 0)];
  unsigned int k1 = keys[hook(1, inc)];
  unsigned int v1 = values[hook(2, inc)];

  bool swap = reverse ^ (k0 < k1);

  keys[hook(1, 0)] = (swap) ? k1 : k0;
  values[hook(2, 0)] = (swap) ? v1 : v0;
  keys[hook(1, inc)] = (swap) ? k0 : k1;
  values[hook(2, inc)] = (swap) ? v0 : v1;
}