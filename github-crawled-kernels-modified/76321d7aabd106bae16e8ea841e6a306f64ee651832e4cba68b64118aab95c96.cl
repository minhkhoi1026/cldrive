//{"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_ret_struct(global int* res) {
  struct A {
    int a;
  };
  struct A (^kernelBlock)(struct A) = ^struct A(struct A a) {
    a.a = 6;
    return a;
  };
  size_t tid = get_global_id(0);
  res[hook(0, tid)] = -1;
  struct A aa;
  aa.a = 5;
  res[hook(0, tid)] = kernelBlock(aa).a - 6;
}