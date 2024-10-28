//{"in":1,"offsets":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_private_vpm_partial_row(global uint8* out, const global uint8* in, const global unsigned int* offsets) {
 private
  uint4 uloc[8] = {0};

  vstore8(in[hook(1, 0)], 0, (private unsigned int*)uloc);

  vstore8(in[hook(1, 1)], 1, (private unsigned int*)uloc);

  vstore8(in[hook(1, 2)], offsets[hook(2, 2)], (private unsigned int*)uloc);

  vstore8(in[hook(1, 3)], 0, ((private unsigned int*)uloc) + 20);

  vstore8(in[hook(1, 3)], 0, ((private unsigned int*)uloc) + offsets[hook(2, 4)]);

  out[hook(0, 0)] = vload8(0, (private unsigned int*)uloc);

  out[hook(0, 1)] = vload8(1, (private unsigned int*)uloc);

  out[hook(0, 2)] = vload8(offsets[hook(2, 2)], (private unsigned int*)uloc);

  out[hook(0, 3)] = vload8(0, ((private unsigned int*)uloc) + 10);

  out[hook(0, 4)] = vload8(0, ((private unsigned int*)uloc) + offsets[hook(2, 4)]);
}