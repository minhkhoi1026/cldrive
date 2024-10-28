//{"in":1,"offsets":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_private_register(global uint8* out, const global uint4* in, const global unsigned int* offsets) {
 private
  unsigned int uloc[16] = {0};

  vstore4(in[hook(1, 0)], 0, (private unsigned int*)uloc);

  vstore4(in[hook(1, 1)], 1, (private unsigned int*)uloc);

  vstore4(in[hook(1, 2)], offsets[hook(2, 2)], (private unsigned int*)uloc);

  vstore4(in[hook(1, 3)], 0, ((private unsigned int*)uloc) + 11);

  vstore4(in[hook(1, 3)], 0, ((private unsigned int*)uloc) + offsets[hook(2, 2)]);

  out[hook(0, 0)] = vload8(0, (private unsigned int*)uloc);

  out[hook(0, 1)] = vload8(1, (private unsigned int*)uloc);

  out[hook(0, 2)] = vload8(offsets[hook(2, 1)], (private unsigned int*)uloc);

  out[hook(0, 3)] = vload8(0, ((private unsigned int*)uloc) + 5);

  out[hook(0, 4)] = vload8(0, ((private unsigned int*)uloc) + offsets[hook(2, 3)]);
}