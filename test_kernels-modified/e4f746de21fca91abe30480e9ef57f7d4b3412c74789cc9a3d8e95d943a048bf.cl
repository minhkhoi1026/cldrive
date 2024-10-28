//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_add_byte_improved(global char4* in1, global char4* in2, global char4* out) {
  int index = get_global_id(0);
  out[hook(2, index)] = in1[hook(0, index)] + in2[hook(1, index)];
}