//{"numElems":0,"srcDst":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cck_dummy(const int numElems, global float* srcDst) {
  unsigned int gid = get_global_id(0);

  if (gid < numElems)
    for (int i = 0; i < 65536; ++i) {
      srcDst[hook(1, gid)] *= 1.0f;
      srcDst[hook(1, gid)] += 1.0f;
      srcDst[hook(1, gid)] /= 1.0f;
    }
}