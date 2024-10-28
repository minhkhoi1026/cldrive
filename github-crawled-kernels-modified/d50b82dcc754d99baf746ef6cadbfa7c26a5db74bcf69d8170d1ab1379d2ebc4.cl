//{"img_test_in":0,"img_test_out":1,"iterations":2,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void graying(global const uchar* restrict img_test_in, global uchar* restrict img_test_out, const unsigned int iterations) {
  unsigned int count = 0;
  uchar rows[3];
  while (count != iterations) {
    for (int i = 0; i < 3; i++) {
      for (int ii = 2; ii > 0; --ii) {
        rows[hook(3, ii)] = rows[hook(3, ii - 1)];
      }
      rows[hook(3, 0)] = img_test_in[hook(0, count + i)];
    }
    for (int i = 0; i < 3; i++) {
      for (int ii = 2; ii > 0; --ii) {
        img_test_out[hook(1, count + ii)] = img_test_out[hook(1, count + ii - 1)];
      }
      img_test_out[hook(1, count)] = (rows[hook(3, 0)] * 76 + rows[hook(3, 1)] * 150 + rows[hook(3, 2)] * 30) >> 8;
    }
    count += 3;
  }
}