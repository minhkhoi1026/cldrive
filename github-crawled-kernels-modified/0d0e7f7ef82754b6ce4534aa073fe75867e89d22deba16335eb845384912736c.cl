//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_math_constants() {
  float f;
  f = 0x1.fffffep127f;
  f = (__builtin_huge_valf());
  f = (__builtin_huge_val());
  f = (__builtin_inff());
  f = __builtin_astype((2147483647), float);
  f = 2.71828182845904523536028747135266250f;
  f = 1.44269504088896340735992468100189214f;
  f = 0.434294481903251827651128918916605082f;
  f = 0.693147180559945309417232121458176568f;
  f = 2.30258509299404568401799145468436421f;
  f = 3.14159265358979323846264338327950288f;
  f = 1.57079632679489661923132169163975144f;
  f = 0.785398163397448309615660845819875721f;
  f = 0.318309886183790671537767526745028724f;
  f = 0.636619772367581343075535053490057448f;
  f = 1.12837916709551257389615890312154517f;
  f = 1.41421356237309504880168872420969808f;
  f = 0.707106781186547524400844362104849039f;
}