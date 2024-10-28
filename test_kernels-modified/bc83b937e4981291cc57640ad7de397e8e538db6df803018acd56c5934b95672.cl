//{"c":0,"num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void profile_read(global char16* c, int num) {
  for (int i = 0; i < num; i++) {
    c[hook(0, i)] = (char16)(5);
  }
}