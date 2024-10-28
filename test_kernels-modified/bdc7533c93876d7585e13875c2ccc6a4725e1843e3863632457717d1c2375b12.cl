//{"coeff":1,"filter_len":3,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_byte_improved(global char4* in, global char4* coeff, global char4* out, int filter_len) {
  int index = get_global_id(0);
  int i = 0, acc1 = 0, acc2 = 0, acc3 = 0, acc4 = 0;
  do {
    acc1 += in[hook(0, index + i)].x * coeff[hook(1, i)].x;
    acc1 += in[hook(0, index + i)].y * coeff[hook(1, i)].y;
    acc1 += in[hook(0, index + i)].z * coeff[hook(1, i)].z;
    acc1 += in[hook(0, index + i)].w * coeff[hook(1, i)].w;
    acc2 += in[hook(0, index + i)].y * coeff[hook(1, i)].x;
    acc2 += in[hook(0, index + i)].z * coeff[hook(1, i)].y;
    acc2 += in[hook(0, index + i)].w * coeff[hook(1, i)].z;
    acc2 += in[hook(0, index + i + 1)].x * coeff[hook(1, i)].w;
    acc3 += in[hook(0, index + i)].z * coeff[hook(1, i)].x;
    acc3 += in[hook(0, index + i)].w * coeff[hook(1, i)].y;
    acc3 += in[hook(0, index + i + 1)].x * coeff[hook(1, i)].z;
    acc3 += in[hook(0, index + i + 1)].y * coeff[hook(1, i)].w;
    acc4 += in[hook(0, index + i)].w * coeff[hook(1, i)].x;
    acc4 += in[hook(0, index + i + 1)].x * coeff[hook(1, i)].y;
    acc4 += in[hook(0, index + i + 1)].y * coeff[hook(1, i)].z;
    acc4 += in[hook(0, index + i + 1)].z * coeff[hook(1, i)].w;
    i++;
  } while (i != filter_len / 4);
  out[hook(2, index)].x = acc1;
  out[hook(2, index)].y = acc2;
  out[hook(2, index)].z = acc3;
  out[hook(2, index)].w = acc4;
}