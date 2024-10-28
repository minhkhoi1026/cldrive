//{"col":2,"n_vals":0,"res":5,"row":1,"val":3,"vect":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sparse_mat_vec_mult(int n_vals, global int* row, global int* col, global float* val, global float* vect, global float* res) {
  int id = get_global_id(0);

  int2 indices = (int2)(-1, -1);

  for (int i = 0; i < n_vals; ++i) {
    if (row[hook(1, i)] == id && indices.x == -1) {
      indices.x = i;
    }
    if (row[hook(1, i)] == id + 1 && indices.y == -1) {
      indices.y = i - 1;
      break;
    }
    if (i == n_vals - 1 && indices.y == -1) {
      indices.y = i;
    }
  }

  float sum = 0.f;
  for (int i = indices.x; i <= indices.y; ++i) {
    sum += val[hook(3, i)] * vect[hook(4, col[ihook(2, i))];
  }
  res[hook(5, id)] = sum;
}