//{"c":1,"f":9,"i":3,"l":4,"result":0,"s":2,"uc":5,"ui":7,"ul":8,"us":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scalars(global unsigned int* result, char c, short s, int i, long l, uchar uc, ushort us, unsigned int ui, ulong ul, float f) {
  ulong cval = convert_ulong((uchar)c);
  ulong sval = convert_ulong((ushort)s);
  ulong ival = convert_ulong((unsigned int)i);
  ulong lval = convert_ulong((unsigned int)l);
  ulong ucval = convert_ulong(uc);
  ulong usval = convert_ulong(us);
  ulong uival = convert_ulong(ui);
  ulong ulval = convert_ulong(ul);
  ulong fval = convert_ulong(__builtin_astype((f), unsigned int));

  result[hook(0, 0)] = 0xffffffff;

  if (cval == 0x00000000000000ff && sval == 0x000000000000ffff && ival == 0x00000000ffffffff && lval == 0x00000000ffffffff && ucval == 0x00000000000000ff && usval == 0x000000000000ffff && uival == 0x00000000ffffffff && ulval == 0x00000000ffffffff && fval == 0x000000003f800000) {
    result[hook(0, 0)] = 0xdeadbeef;
  }
}