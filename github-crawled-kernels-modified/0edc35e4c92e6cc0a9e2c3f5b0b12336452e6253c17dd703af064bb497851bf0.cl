//{"a_vec":0,"b_vec":1,"l_vec":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot3_local(global float* a_vec, global float* b_vec, global float* output) {
  size_t gid = get_global_id(0);
  size_t lid = get_local_id(0);

  local float l_vec[12];

  l_vec[hook(3, lid)] = a_vec[hook(0, gid)] * b_vec[hook(1, gid)];

  barrier(0x01);
  if (lid == 0) {
    l_vec[hook(3, lid)] = l_vec[hook(3, lid)] + l_vec[hook(3, lid + 1)];
  }

  output[hook(2, gid)] = l_vec[hook(3, lid)];
}