//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_stream_read_short(global short* dst) {
  dst[hook(0, 0)] = (short)((1 << 8) + 1);
}