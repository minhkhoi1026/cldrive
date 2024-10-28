//{"input":0,"maximum":2,"rids":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void create_rids(global unsigned int* restrict input, global unsigned int* restrict rids, private unsigned int maximum) {
  unsigned int idx = get_global_id(0);
  if (idx < maximum)
    rids[hook(1, idx)] = idx;
}