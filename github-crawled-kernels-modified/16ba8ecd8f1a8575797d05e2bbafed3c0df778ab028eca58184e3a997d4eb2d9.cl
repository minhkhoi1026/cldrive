//{"a":1,"b":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mod(global unsigned int* out, unsigned int a, unsigned int b) {
  out[hook(0, 0)] = a % b;
}