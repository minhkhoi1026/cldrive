//{"c":1,"f":6,"i":3,"l":4,"result":0,"s":2,"ul":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectors(global unsigned int* result, char2 c, short3 s, int4 i, long8 l, ulong16 ul, float16 f) {
  ulong cval = convert_ulong((uchar)c.s1);
  ulong sval = convert_ulong((ushort)s.s2);
  ulong ival = convert_ulong((unsigned int)i.s3);
  ulong lval = convert_ulong((unsigned int)l.s7);
  ulong ulval = convert_ulong(ul.sF);
  ulong fval = convert_ulong(__builtin_astype((f.sF), unsigned int));

  result[hook(0, 0)] = 0xffffffff;

  if (cval == 0x00000000000000ff && sval == 0x000000000000ffff && ival == 0x00000000ffffffff && lval == 0x00000000ffffffff && ulval == 0x00000000ffffffff && fval == 0x000000003f800000) {
    result[hook(0, 0)] = 0xdeadbeef;
  }
}