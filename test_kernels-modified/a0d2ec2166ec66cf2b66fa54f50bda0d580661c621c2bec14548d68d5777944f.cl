//{"src":0,"trgt":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_operation(global const int* src, global int* trgt) {
  int gidx = get_global_id(0);

  float r = src[hook(0, gidx)];
  trgt[hook(1, gidx)] = (int)((sin(r)) / 1319 + (cos(r)) / 1317 + (cos(r + 13)) * (sin(r - 13)));
}