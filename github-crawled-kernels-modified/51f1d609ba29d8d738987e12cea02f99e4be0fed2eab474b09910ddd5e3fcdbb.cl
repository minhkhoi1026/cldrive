//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_stream_write_uchar(global uchar* src, global uchar* dst) {
  int tid = get_global_id(0);
  dst[hook(1, tid)] = src[hook(0, tid)];
}