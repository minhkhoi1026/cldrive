//{"heads":2,"keys_high":0,"keys_low":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void create_heads(global unsigned int* restrict keys_high, global unsigned int* restrict keys_low, global unsigned int* restrict heads) {
  unsigned int idx = get_global_id(0);
  heads[hook(2, idx)] = (idx == 0) || (keys_high[hook(0, idx)] != keys_high[hook(0, idx - 1)]) || (keys_low[hook(1, idx)] != keys_low[hook(1, idx - 1)]);
}