//{"mat1_data":0,"mat2_data":1,"out_data":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_add(global int* mat1_data, global int* mat2_data, global int* out_data) {
  int i = get_global_id(0);
  out_data[hook(2, i)] = mat1_data[hook(0, i)] + mat2_data[hook(1, i)];
}