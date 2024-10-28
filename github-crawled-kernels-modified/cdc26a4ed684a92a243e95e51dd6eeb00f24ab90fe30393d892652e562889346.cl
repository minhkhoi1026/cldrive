//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void op_test(global int4* output) {
  int4 vec = (int4)(1, 2, 3, 4);
  vec += 4;
  if (vec.s2 == 7)
    vec &= (int4)(-1, -1, 0, -1);
  vec.s01 = vec.s23 < 7;
  while (vec.s3 > 7 && (vec.s0 < 16 || vec.s1 < 16))
    vec.s3 >>= 1;

  *output = vec;
}