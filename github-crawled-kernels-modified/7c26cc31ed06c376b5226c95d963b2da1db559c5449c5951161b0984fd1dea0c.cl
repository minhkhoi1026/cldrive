//{"coeff":1,"filter_len":3,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_half_improved(global short2* in, global short2* coeff, global short2* out, int filter_len) {
  unsigned int index = get_global_id(0);
  int i = 0, acc1 = 0, acc2 = 0;
  do {
    acc1 += in[hook(0, index + i)].x * coeff[hook(1, i)].x;
    acc1 += in[hook(0, index + i)].y * coeff[hook(1, i)].y;
    acc2 += in[hook(0, index + i)].y * coeff[hook(1, i)].x;
    acc2 += in[hook(0, index + i + 1)].x * coeff[hook(1, i)].y;
    i++;
  } while (i < filter_len / 2);
  short2 res;
  res.x = acc1, res.y = acc2;
  out[hook(2, index)] = res;
}