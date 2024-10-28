//{"pos":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void six_hump_camel_function(global float* pos, global float* value) {
  if (get_global_id(0) == 0) {
    *value = -1 * (4 * pow(pos[hook(0, 0)], 2) - 2.1 * pow(pos[hook(0, 0)], 4) + pow(pos[hook(0, 0)], 6) / 3 + pos[hook(0, 0)] * pos[hook(0, 1)] - 4 * pow(pos[hook(0, 1)], 2) + 4 * pow(pos[hook(0, 1)], 4));
  }
}