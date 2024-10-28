//{"a":4,"b":5,"c":6,"input1":1,"input2":2,"output":3,"tensorDimension":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_add(const unsigned int tensorDimension, global unsigned char* input1, global unsigned char* input2, global unsigned char* output, const unsigned int a, const unsigned int b, const unsigned int c) {
  int id_x = get_global_id(0);
  int id_y = get_global_id(1);
  int id_z = get_global_id(2);

  if (id_x >= a || id_y >= b || id_z >= c)
    return;

  int pixIdx = id_y * c * a + id_x * c + id_z;

  unsigned int value = input1[hook(1, pixIdx)] + input2[hook(2, pixIdx)];
  output[hook(3, pixIdx)] = ((value) > 255 ? 255 : ((value) < 0 ? 0 : (value)));
}