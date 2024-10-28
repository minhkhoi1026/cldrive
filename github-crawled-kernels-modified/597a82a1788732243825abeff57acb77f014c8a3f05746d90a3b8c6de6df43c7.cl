//{"result":0,"table":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern constant unsigned int table[256];
kernel void use_extern(global unsigned int* result) {
  result[hook(0, 0)] = table[hook(1, 0)];
}