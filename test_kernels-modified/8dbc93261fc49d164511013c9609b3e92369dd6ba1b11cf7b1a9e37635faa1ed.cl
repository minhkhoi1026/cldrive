//{"in":1,"num":0,"ret":2,"sdata":3,"temp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_amax(const int num, global const float* in, global int* ret, local unsigned int* sdata, local size_t* temp) {
  const int gid = get_global_id(0);
  const int tid = get_local_id(0);

  for (int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(3, tid)] = (in[hook(1, sdata[thook(3, tid))] > in[hook(1, tid + s)]) ? sdata[hook(3, tid)] : tid;
    }
    barrier(0x01);
  }
  if (tid == 0) {
    ret[hook(2, 0)] = sdata[hook(3, 0)];
  }
}