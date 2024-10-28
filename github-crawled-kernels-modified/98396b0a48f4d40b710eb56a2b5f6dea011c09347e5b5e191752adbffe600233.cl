//{"errorAllowed":3,"m1":0,"m2":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compare(global const float* m1, global const float* m2, global int* result, float errorAllowed) {
  int id = get_global_id(0);
  float error = m1[hook(0, id)] - m2[hook(1, id)];
  if (error > errorAllowed || error < -errorAllowed)
    atomic_inc(result);
}