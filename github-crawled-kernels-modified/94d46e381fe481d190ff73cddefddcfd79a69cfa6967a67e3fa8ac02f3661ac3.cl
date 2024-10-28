//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_add_half(global short* in1, global short* in2, global short* out) {
  int index = get_global_id(0);
  out[hook(2, index)] = in1[hook(0, index)] + in2[hook(1, index)];
}