//{"in":0,"index":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_elem_vector(global float* in, const int index, global float* out) {
  if (get_global_id(0) == 0)
    out[hook(2, index)] = (*in);
}