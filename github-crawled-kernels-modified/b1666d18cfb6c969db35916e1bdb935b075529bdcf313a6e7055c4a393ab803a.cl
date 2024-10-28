//{"pos_u":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void euler(global float4* pos_u) {
  int i = get_global_id(0);
}