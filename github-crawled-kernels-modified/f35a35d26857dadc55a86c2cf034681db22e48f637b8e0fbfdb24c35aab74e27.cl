//{"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_kernel(global int* res) {
  typedef int (^block_t)(int);
  constant block_t b1 = ^(int i) {
    return i + 1;
  };
  *res = b1(5);
}