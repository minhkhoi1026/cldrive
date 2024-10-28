//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply_byte_improved(global char4* in1, global char* in2, global char* out) {
  int row = get_global_id(1);
  int column = get_global_id(0);
  int len = get_global_size(0);
  int i = 0, k = 0, res = 0;
  do {
    res += in1[hook(0, row * len / 4 + k)].x * in2[hook(1, column + i * len)];
    i++;
    res += in1[hook(0, row * len / 4 + k)].y * in2[hook(1, column + i * len)];
    i++;
    res += in1[hook(0, row * len / 4 + k)].z * in2[hook(1, column + i * len)];
    i++;
    res += in1[hook(0, row * len / 4 + k)].w * in2[hook(1, column + i * len)];
    i++;
    k++;
  } while (i != len);
  out[hook(2, row * len + column)] = res;
}