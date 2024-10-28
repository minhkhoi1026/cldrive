//{"in":1,"num":0,"out":2,"sdata":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_asum(const int num, global const float* in, global float* out, local float* sdata) {
  const int tid = get_local_id(0);
  const int i = get_global_id(0);

  sdata[hook(3, tid)] = (i < num) ? in[hook(1, i)] : (__builtin_inff());

  if (i + get_local_size(0) < num) {
    sdata[hook(3, tid)] += in[hook(1, i + get_local_size(0))];
  }
  barrier(0x01);

  for (int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(3, tid)] = fabs(sdata[hook(3, tid + s)]);
    }
    barrier(0x01);
  }
  if (tid == 0) {
    out[hook(2, 0)] = sdata[hook(3, 0)];
  }
}