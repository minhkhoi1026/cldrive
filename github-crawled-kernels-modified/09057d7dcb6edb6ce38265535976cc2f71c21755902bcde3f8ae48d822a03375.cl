//{"gloc":3,"in":1,"offsets":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_global(global uint8* out, const global uint8* in, const global unsigned int* offsets, global uint16 gloc[2]) {
  vstore8(in[hook(1, 0)], 0, (global unsigned int*)gloc);

  vstore8(in[hook(1, 1)], 1, (global unsigned int*)gloc);

  vstore8(in[hook(1, 2)], offsets[hook(2, 2)], (global unsigned int*)gloc);

  vstore8(in[hook(1, 3)], 0, ((global unsigned int*)gloc) + 20);

  vstore8(in[hook(1, 3)], 0, ((global unsigned int*)gloc) + offsets[hook(2, 4)]);

  out[hook(0, 0)] = vload8(0, (global unsigned int*)gloc);

  out[hook(0, 1)] = vload8(1, (global unsigned int*)gloc);

  out[hook(0, 2)] = vload8(offsets[hook(2, 2)], (global unsigned int*)gloc);

  out[hook(0, 3)] = vload8(0, ((global unsigned int*)gloc) + 10);

  out[hook(0, 4)] = vload8(0, ((global unsigned int*)gloc) + offsets[hook(2, 4)]);
}