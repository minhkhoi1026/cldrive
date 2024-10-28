//{"lbuf":3,"output":0,"size":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void writeLocalMemory(global float* output, int size, int stride) {
  int gid = get_global_id(0);
  int j = 0;
  int tid = get_local_id(0), localSize = get_local_size(0), litems = 2048 / localSize;
  int s = tid;
  int baseIndex = (s >> 4) << 4;
  local float lbuf[2048];

  for (j = 0; j < 3000; ++j) {
    lbuf[hook(3, (stride * s + baseIndex + 0) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 1) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 2) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 3) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 4) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 5) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 6) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 7) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 8) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 9) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 10) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 11) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 12) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 13) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 14) & (2047))] = gid;
    lbuf[hook(3, (stride * s + baseIndex + 15) & (2047))] = gid;
    s = (s + 16) & (2047);
  }
  barrier(0x01);
  for (j = 0; j < litems; ++j)
    output[hook(0, gid)] = lbuf[hook(3, tid)];
}