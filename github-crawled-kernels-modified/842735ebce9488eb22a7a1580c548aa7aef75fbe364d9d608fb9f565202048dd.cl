//{"buffer":3,"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DotProductDevice(global int* src1, global int* src2, global int* dst) {
  int gid = get_global_id(0);
  local int buffer[256];

  if (gid == 0)
    atomic_xchg(dst, 0);

  int lid = get_local_id(0);

  buffer[hook(3, lid)] = src1[hook(0, gid)] * src2[hook(1, gid)];

  barrier(0x01);

  if (lid == 0) {
    int sum = 0;
    for (int i = 0; i < 256; i++)
      sum += buffer[hook(3, i)];
    atomic_add(dst, sum);
  }
}