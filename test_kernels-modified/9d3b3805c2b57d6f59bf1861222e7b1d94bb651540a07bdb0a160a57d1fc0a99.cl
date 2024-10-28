//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void comma(global int* out) {
  out[hook(0, 0)] = (0, 0, 1);
  out[hook(0, 1)] = 1, 0, 0;
  out[hook(0, 3)] = (out[hook(0, 2)] = 1, 1);
  out[hook(0, 5)] = out[hook(0, 4)] = 1, 0;
}