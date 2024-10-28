//{"c1":4,"c2":6,"input1":0,"input2":1,"output":2,"r1":3,"r2":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_matrix_multiply(global unsigned char* input1, global unsigned char* input2, global unsigned char* output, const unsigned int r1, const unsigned int c1, const unsigned int r2, const unsigned int c2) {
  int id_x = get_global_id(0);
  int id_y = get_global_id(1);
  int id_z = get_global_id(2);
  if (id_x >= c2 || id_y >= r1 || id_z >= 1)
    return;
  unsigned int OpPixIdx = id_y * c2 + id_x;
  unsigned int pixIdx1, pixIdx2;
  output[hook(2, OpPixIdx)] = 0;
  for (int j = 0; j < c1; j++) {
    pixIdx1 = id_y * c1 + j;
    pixIdx2 = j * c2 + id_x;
    int value = input1[hook(0, pixIdx1)] * input2[hook(1, pixIdx2)];
    output[hook(2, OpPixIdx)] = ((output[hook(2, OpPixIdx)] + value) > 255 ? 255 : ((output[hook(2, OpPixIdx)] + value) < 0 ? 0 : (output[hook(2, OpPixIdx)] + value)));
  }
}