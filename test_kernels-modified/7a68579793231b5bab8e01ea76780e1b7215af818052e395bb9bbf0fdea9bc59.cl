//{"ci":3,"cr":2,"di":5,"dr":4,"gi":1,"gr":0,"len":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gridkernel(global double* gr, global double* gi, global double* cr, global double* ci, double dr, double di, int len) {
  int idx = get_global_id(0);

  if (idx < len) {
    gi[hook(1, idx)] = gi[hook(1, idx)] + dr * ci[hook(3, idx)] + di * cr[hook(2, idx)];
    gr[hook(0, idx)] = gr[hook(0, idx)] + dr * cr[hook(2, idx)] - di * ci[hook(3, idx)];
  }
}