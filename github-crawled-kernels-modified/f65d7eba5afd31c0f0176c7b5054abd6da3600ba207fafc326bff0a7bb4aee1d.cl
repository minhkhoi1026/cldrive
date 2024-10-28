//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_barrier_fence(global const int4* in, global int4* out) {
  int offset = 0;
  int4 val = 0;
  val += in[hook(0, offset)];
  val += in[hook(0, offset + 1)];
  val += in[hook(0, offset + 2)];
  val += in[hook(0, offset + 3)];

  read_mem_fence(0x01);
  val += in[hook(0, offset + 4)];
  val += in[hook(0, offset + 5)];
  val += in[hook(0, offset + 6)];
  out[hook(1, 0)] = val;
  out[hook(1, 1)] = val;
  out[hook(1, 2)] = val;
  write_mem_fence(0x01);
  out[hook(1, 3)] = val;
  out[hook(1, 4)] = val;
  out[hook(1, 5)] = val;
  mem_fence(0x02);
  out[hook(1, 6)] = val;
  out[hook(1, 7)] = val;
  barrier(0x02);
  out[hook(1, 8)] = val;
  out[hook(1, 9)] = val;
}