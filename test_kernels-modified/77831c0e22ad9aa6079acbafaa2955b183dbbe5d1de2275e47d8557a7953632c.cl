//{"l":1,"q":2,"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorAdd(global float* s, constant const float* l, local float* q) {
  const int gid = get_global_id(0);
  const int lid = get_local_id(0);
  q[hook(2, lid)] = l[hook(1, lid)];

  s[hook(0, gid)] = s[hook(0, gid)] + q[hook(2, lid)] * 2.0f + 1.0f;
}