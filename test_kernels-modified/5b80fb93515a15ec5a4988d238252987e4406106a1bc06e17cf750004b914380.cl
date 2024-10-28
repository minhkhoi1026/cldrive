//{"accel":0,"len":1,"sdata":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float4* accel, const unsigned int len, local float4* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int gid = get_global_id(0);

  sdata[hook(2, tid)] = (gid < len) ? accel[hook(0, gid)] : 0;

  barrier(0x01);

  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(2, tid)] += sdata[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    accel[hook(0, get_group_id(0))] = sdata[hook(2, 0)];
  }
}