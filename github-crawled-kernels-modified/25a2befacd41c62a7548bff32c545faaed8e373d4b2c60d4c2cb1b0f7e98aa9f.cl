//{"a":3,"b":4,"c":5,"input":1,"output":2,"tensorDimension":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_convert_bit_depth_u8s8(const unsigned int tensorDimension, global unsigned char* input, global char* output, const unsigned int a, const unsigned int b, const unsigned int c) {
  int id_x = get_global_id(0);
  int id_y = get_global_id(1);
  int id_z = get_global_id(2);

  if (id_x >= a || id_y >= b || id_z >= c)
    return;

  int pixIdx = id_y * c * a + id_x * c + id_z;

  output[hook(2, pixIdx)] = (char)(input[hook(1, pixIdx)] - 128);
}