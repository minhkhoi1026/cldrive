//{"in":1,"offsets":2,"out":0,"uloc":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_local_parameter(global uint8* out, const global uint8* in, const global unsigned int* offsets, local uint16 uloc[2]) {
  vstore16((uint16)0, 0, (local unsigned int*)uloc);
  vstore16((uint16)0, 1, (local unsigned int*)uloc);

  vstore8(in[hook(1, 0)], 0, (local unsigned int*)uloc);

  vstore8(in[hook(1, 1)], 1, (local unsigned int*)uloc);

  vstore8(in[hook(1, 2)], offsets[hook(2, 2)], (local unsigned int*)uloc);

  vstore8(in[hook(1, 3)], 0, ((local unsigned int*)uloc) + 20);

  vstore8(in[hook(1, 3)], 0, ((local unsigned int*)uloc) + offsets[hook(2, 4)]);

  out[hook(0, 0)] = vload8(0, (local unsigned int*)uloc);

  out[hook(0, 1)] = vload8(1, (local unsigned int*)uloc);

  out[hook(0, 2)] = vload8(offsets[hook(2, 2)], (local unsigned int*)uloc);

  out[hook(0, 3)] = vload8(0, ((local unsigned int*)uloc) + 10);

  out[hook(0, 4)] = vload8(0, ((local unsigned int*)uloc) + offsets[hook(2, 4)]);
}