//{"arg":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void false_warning_vector_argument(int16 arg, global int8* res) {
  int8 v = (int8)(1, 2, 3, 4, 5, 6, 7, 8);

  int16 add = arg + v.s0011223344556677;

  *res = add.lo;
}