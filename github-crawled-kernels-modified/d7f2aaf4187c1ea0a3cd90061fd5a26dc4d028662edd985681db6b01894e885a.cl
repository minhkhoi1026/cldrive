//{"Out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void source_lines_test(global int* Out) {
  int var0 = 0x777;
  int var1 = 0x888;
  int var2 = var0 + var1;
  *Out = var2;
}