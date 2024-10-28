//{"result":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(int2 source, global int2* result) {
  result[hook(1, 0)] = source;
}