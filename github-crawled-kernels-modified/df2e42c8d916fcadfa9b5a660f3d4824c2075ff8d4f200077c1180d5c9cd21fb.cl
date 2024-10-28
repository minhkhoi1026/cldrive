//{"value":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void one_item_double(global ulong* value) {
  *value = *value * 2;
}