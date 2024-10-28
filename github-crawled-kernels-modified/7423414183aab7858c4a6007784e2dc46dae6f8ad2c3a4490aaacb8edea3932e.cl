//{"inWidth":1,"offset":2,"outDest":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void greaterthan_const_vec4(global int* outDest, int inWidth, int offset) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  int xcmp = x + offset;
  int4 x_cmp4 = (int4)(xcmp);

  int index = (y * inWidth) + x;

  const int fake_float_one = (int)0x3f800000u;
  const int fake_float_mone = (int)0xbf800000u;
  int4 one = (int4)(fake_float_one);
  int4 mone = (int4)(fake_float_mone);

  int4 compare_to = (y < 4) ? (int4)(-4, 3, -2, 1) : (int4)(0, -1, 2, -3);
  int4 value = ((x_cmp4 > compare_to) & one) | ((x_cmp4 <= compare_to) & mone);
  int2 components2 = (y & 2) ? value.zw : value.xy;
  int component = (y & 1) ? components2.y : components2.x;
  outDest[hook(0, index)] = component;
}