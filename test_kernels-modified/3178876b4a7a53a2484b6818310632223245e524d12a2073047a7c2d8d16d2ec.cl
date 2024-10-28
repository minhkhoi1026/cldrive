//{"buf":2,"in1":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void localMem(global float* const restrict out, global const float* const restrict in1) {
  local float buf[128];
  const size_t id = get_global_id(0);
  const size_t lid = get_local_id(0);

  buf[hook(2, lid)] = in1[hook(1, id)];
  out[hook(0, id)] = buf[hook(2, lid)] + buf[hook(2, (lid + 1) % 128)];
}