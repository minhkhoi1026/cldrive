//{"in":0,"out":2,"scratch":1,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void two_stage_reduce(global float* in, local float* scratch, global float* out, const int size) {
  int gid = get_global_id(0);
  float accum = 0.0;

  while (gid < size) {
    float element = in[hook(0, gid)];
    accum += element;
    gid += get_global_size(0);
  }

  int lid = get_local_id(0);
  scratch[hook(1, lid)] = accum;
  barrier(0x01);
  for (int i = get_local_size(0) / 2; i > 0; i >>= 1) {
    if (lid < i) {
      scratch[hook(1, lid)] += scratch[hook(1, lid + i)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    out[hook(2, get_group_id(0))] = scratch[hook(1, 0)];
  }
}