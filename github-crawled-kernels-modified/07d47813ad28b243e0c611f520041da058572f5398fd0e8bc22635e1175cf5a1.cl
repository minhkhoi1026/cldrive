//{"a":0,"b":1,"c":2,"num_els":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_vector(global float* a, global float* b, global float* c, int num_els) {
  int idx = get_global_id(0);
  if (idx < num_els) {
    c[hook(2, idx)] = a[hook(0, idx)] + b[hook(1, idx)];
  }
}