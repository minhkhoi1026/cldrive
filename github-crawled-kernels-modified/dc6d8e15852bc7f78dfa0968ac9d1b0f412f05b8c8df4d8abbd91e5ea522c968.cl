//{"num1":0,"num2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void first(global int* num1, global int* num2, global int* out) {
  int i = get_global_id(0);
  out[hook(2, i)] = num1[hook(0, i)] * num1[hook(0, i)] + num2[hook(1, i)] * num2[hook(1, i)];
}