//{"As":5,"d_Mat":0,"d_Vect":1,"numRows":4,"result_vec":2,"vecLen":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixvectorMult(global float* d_Mat, global float* d_Vect, global float* result_vec, global int* vecLen, global int* numRows, local float* As) {
  int y;
  int x;
  int a;
  for (y = get_group_id(0); y < (*vecLen); y += get_num_groups(0)) {
    float sum = 0.0f;
    for (x = get_local_id(0); x < (*vecLen); x += get_local_size(0))
      sum += d_Mat[hook(0, y * (*vecLen) + x)] * d_Vect[hook(1, x)];
    As[hook(5, get_local_id(0))] = sum;
    barrier(0x01);
    if (get_local_id(0) == 0) {
      float dotProduct = 0.0f;
      for (a = 0; a < get_local_size(0); ++a)
        dotProduct += As[hook(5, a)];
      result_vec[hook(2, y)] = dotProduct;
    }
    barrier(0x01);
  }
}