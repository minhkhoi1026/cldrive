//{"buffer":0,"offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DownSweep(global int* buffer, unsigned int offset) {
  unsigned int stride = offset << 1;
  unsigned int id = (get_global_id(0) + 1) * stride - 1;

  int val = buffer[hook(0, id)];
  buffer[hook(0, id)] += buffer[hook(0, id - offset)];
  buffer[hook(0, id - offset)] = val;
}