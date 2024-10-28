//{"mat1":0,"mat2":1,"pitch":3,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply(global const float* mat1, global const float* mat2, global float* result, unsigned int pitch) {
  const int pos_out = get_global_id(1) * get_global_size(0) + get_global_id(0);
  const int pos_in1 = get_global_id(0) * pitch;
  const int pos_in2 = get_global_id(1) * pitch;
  result[hook(2, pos_out)] = 0;
  for (unsigned int i = 0; i < pitch; ++i) {
    result[hook(2, pos_out)] += mat1[hook(0, pos_in1 + i)] * mat2[hook(1, pos_in2 + i)];
  }
}