//{"E":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void group_size(global int* E) {
  int lo_id = get_local_id(0);
  int gl_id = get_global_id(0);
  int gr_id = get_group_id(0);
  int s = get_local_size(0);

  E[hook(0, gl_id)] = s;
}