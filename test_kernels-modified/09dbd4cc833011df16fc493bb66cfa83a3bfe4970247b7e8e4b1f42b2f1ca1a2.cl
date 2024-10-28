//{"out":0,"test":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomTest1(global int* out) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  local int test[6];
  if (lid < 6)
    test[hook(1, lid)] = 0;

  int a = 1;
  int t1 = atomic_add(&out[hook(0, 0)], a);
  int t2 = atomic_add(&test[hook(1, 0)], a);
  out[hook(0, 1)] = test[hook(1, 0)];

  int t3 = atomic_sub(&out[hook(0, 2)], a);
  int t4 = atomic_sub(&test[hook(1, 1)], a);
  out[hook(0, 3)] = test[hook(1, 1)];

  int t5 = atomic_xchg(&out[hook(0, 4)], t1);
  int t6 = atomic_xchg(&test[hook(1, 2)], t2);
  out[hook(0, 5)] = test[hook(1, 2)];

  int t7 = atomic_inc(&out[hook(0, 6)]);
  int t8 = atomic_inc(&test[hook(1, 3)]);
  out[hook(0, 7)] = test[hook(1, 3)];

  int t9 = atomic_dec(&out[hook(0, 8)]);
  int t10 = atomic_dec(&test[hook(1, 4)]);
  out[hook(0, 9)] = test[hook(1, 4)];

  int t11 = atomic_cmpxchg(&out[hook(0, 10)], gid, gid - 1);
  int t12 = atomic_cmpxchg(&test[hook(1, 5)], lid, lid - 1);
  out[hook(0, 11)] = test[hook(1, 5)];
}