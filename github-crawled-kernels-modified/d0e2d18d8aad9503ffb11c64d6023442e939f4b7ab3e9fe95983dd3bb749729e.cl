//{"img_test_in":0,"img_test_out":1,"iterations":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void graying(global const uchar* restrict img_test_in, global uchar* restrict img_test_out, const unsigned int iterations) {
  unsigned int count = 0;
  uchar rows[3];
  while (count != iterations) {
    img_test_out[hook(1, count)] = img_test_in[hook(0, count)];
    count++;
  }
}