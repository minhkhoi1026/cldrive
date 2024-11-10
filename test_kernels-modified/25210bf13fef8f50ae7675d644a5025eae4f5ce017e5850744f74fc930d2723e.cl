//{"dest":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void g0(global unsigned int dest[], global const unsigned int src[]) {
  dest[hook(0, 0)] = src[hook(1, 0)];
}