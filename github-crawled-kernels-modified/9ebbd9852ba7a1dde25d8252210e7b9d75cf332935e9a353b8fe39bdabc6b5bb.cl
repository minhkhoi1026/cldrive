//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void memcpy(long dest, size_t n);
void some_other_fn(void* ptr);
kernel void memcpy_test(void) {
  char buffer[4];

  memcpy((int)buffer, 4);
}