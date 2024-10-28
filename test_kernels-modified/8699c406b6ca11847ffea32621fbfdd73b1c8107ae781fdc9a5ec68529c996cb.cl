//{"in1":1,"in2":2,"in3":3,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int func(int a, int b, int c);
kernel void vec_fma(global int* out, global const int* in1, global const int* in2, global const int* in3) {
  int i = get_global_id(0);
  out[hook(0, i)] = func(in1[hook(1, i)], in2[hook(2, i)], in3[hook(3, i)]);
}