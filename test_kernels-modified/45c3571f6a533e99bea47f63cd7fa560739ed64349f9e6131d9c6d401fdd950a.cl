//{"globalMin":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global uint4* src, global unsigned int* globalMin) {
  atom_min(globalMin, globalMin[hook(1, get_global_id(0))]);
}