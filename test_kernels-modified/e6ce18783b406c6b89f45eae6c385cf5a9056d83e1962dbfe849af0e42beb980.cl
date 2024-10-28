//{"dst_0":4,"factor":1,"numElems":0,"src_0":2,"src_1":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy_naive(const int numElems, const float factor, global const float* src_0, global const float* src_1, global float* dst_0) {
  unsigned int gid = get_global_id(0);

  if (gid < numElems)
    dst_0[hook(4, gid)] = factor * src_0[hook(2, gid)] * src_1[hook(3, gid)];
}