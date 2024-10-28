//{"data":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int x[] = {1, 2, 3, 4};

kernel void foo(global int* data) {
  *data = x[hook(1, get_global_id(0))];
}