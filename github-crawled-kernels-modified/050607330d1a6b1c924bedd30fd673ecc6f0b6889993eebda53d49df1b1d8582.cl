//{"a":3,"b":4,"c":5,"input":1,"lutPtr":6,"output":2,"tensorDimension":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_look_up_table(const unsigned int tensorDimension, global unsigned char* input, global unsigned char* output, const unsigned int a, const unsigned int b, const unsigned int c, global unsigned char* lutPtr) {
  int id_x = get_global_id(0);
  int id_y = get_global_id(1);
  int id_z = get_global_id(2);
  if (id_x >= a || id_y >= b || id_z >= c)
    return;

  int pixIdx = id_y * c * a + id_x * c + id_z;

  int index = input[hook(1, pixIdx)];
  unsigned char pixel = lutPtr[hook(6, index)];
  output[hook(2, pixIdx)] = pixel;
}