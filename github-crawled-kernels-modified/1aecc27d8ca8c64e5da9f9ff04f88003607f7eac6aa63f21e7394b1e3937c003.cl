//{"data":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* data, global float* x) {
  float y = data[hook(0, 0)];
  barrier(0x02);
  *x = frexp(y, data + 1);
}