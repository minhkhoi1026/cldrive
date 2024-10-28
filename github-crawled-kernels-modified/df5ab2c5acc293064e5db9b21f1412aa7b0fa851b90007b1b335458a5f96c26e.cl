//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get() {
  return 1;
}

kernel void run() {
  int x = 16;
  int y = 32;
  int z = get();
}