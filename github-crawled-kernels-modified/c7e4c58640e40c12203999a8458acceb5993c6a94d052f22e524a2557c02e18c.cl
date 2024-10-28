//{"gpu1":2,"gpu16":1,"gradx":3,"grady":4,"radians":5,"total":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar16 myselectuc16(uchar16 afalse, uchar16 atrue, int16 condition) {
  uchar16 one = 1;
  uchar16 cond = convert_uchar16(condition * condition);
  uchar16 not_cond = one - cond;
  return atrue * cond + afalse * not_cond;
}
int16 myselecti16(int16 afalse, int16 atrue, int16 condition) {
  int16 cond = condition * condition;
  int16 not_cond = 1 - cond;
  return atrue * cond + afalse * not_cond;
}

kernel void cartToAngle(const int total, float gpu16, float gpu1, global const float* restrict gradx, global const float* restrict grady, global float* restrict radians) {
 private
  const size_t i = get_global_id(0);
 private
  const size_t gpu_used = get_global_size(0);
 private
  const int elements_count = (int)(total * gpu16);
 private
  const int offset = (int)(i * total * gpu1);
  const float16 pi2 = 2 * 3.14159265f;
  for (size_t k = 0; k < elements_count; ++k) {
   private
    float16 x = vload16(k, gradx + offset);
   private
    float16 y = vload16(k, grady + offset);
    float16 a = atan2(y, x);
    a = select(a, a + pi2, a < 0);
    vstore16(a, k, radians + offset);
  }
}