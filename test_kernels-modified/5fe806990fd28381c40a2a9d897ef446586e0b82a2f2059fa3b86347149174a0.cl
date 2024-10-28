//{"out":0,"test":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomTest2(global int* out) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  local int test[6];
  if (lid < 6)
    test[hook(1, lid)] = 0;

  int a = 1;
  int t1 = atomic_min(&out[hook(0, 0)], gid);
  int t2 = atomic_min(&test[hook(1, 0)], lid);
  out[hook(0, 1)] = test[hook(1, 0)];

  int t3 = atomic_max(&out[hook(0, 2)], gid);
  int t4 = atomic_max(&test[hook(1, 1)], lid);
  out[hook(0, 3)] = test[hook(1, 1)];

  int t5 = atomic_and(&out[hook(0, 4)], a);
  int t6 = atomic_and(&test[hook(1, 2)], a);
  out[hook(0, 5)] = test[hook(1, 2)];

  int t7 = atomic_or(&out[hook(0, 6)], t1);
  int t8 = atomic_or(&test[hook(1, 3)], t2);
  out[hook(0, 7)] = test[hook(1, 3)];

  int t9 = atomic_xor(&out[hook(0, 8)], t1);
  int t10 = atomic_xor(&test[hook(1, 4)], t2);
  out[hook(0, 9)] = test[hook(1, 4)];
}