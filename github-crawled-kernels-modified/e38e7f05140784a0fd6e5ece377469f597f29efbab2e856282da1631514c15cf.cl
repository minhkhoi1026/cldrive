//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void basic_conversion() {
  double d;
  float f;
  char2 c2;
  long2 l2;
  float4 f4;
  int4 i4;

  f = convert_float(d);
  d = convert_double_rtp(f);
  l2 = convert_long2_rtz(c2);
  i4 = convert_int4_sat(f4);
}