//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_stream_read_float(global float* dst) {
  dst[hook(0, 0)] = (float)3.40282346638528860e+38;
}