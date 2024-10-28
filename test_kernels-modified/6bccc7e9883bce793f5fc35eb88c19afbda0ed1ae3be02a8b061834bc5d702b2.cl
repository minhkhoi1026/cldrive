//{"buf":0,"gid_max":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_memset(global uint4* buf, const unsigned int value, const unsigned int gid_max) {
  const unsigned int gid = get_global_id(0);

  if (gid >= gid_max)
    return;

  buf[hook(0, gid)] = (uint4)(value);
}