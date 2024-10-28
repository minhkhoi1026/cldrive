//{"in1":1,"in2":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_add(global int* out, global const int* in1, global const int* in2) {
  int i = get_global_id(0);
  out[hook(0, i)] = in1[hook(1, i)] + in2[hook(2, i)];
}