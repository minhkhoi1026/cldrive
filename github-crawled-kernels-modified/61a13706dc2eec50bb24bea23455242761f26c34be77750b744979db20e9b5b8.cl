//{"coeff51":2,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float coeff51[] = {0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f};

kernel void test2(global const uchar* src, global float* dst) {
  float16 output = (float16)0;
  float16 temp1 = convert_float16(vload16(0, src));
  output += temp1 * coeff51[hook(2, 0)];
  float16 prev = temp1;
  for (unsigned int i = 1, j = 1; i < 13; ++i) {
    float16 cur = convert_float16(vload16(i, src));
    output += (float16)(prev.s4567, prev.s89abcdef, cur.s0123) * coeff51[hook(2, j++)];
    output += (float16)(prev.s89abcdef, cur.s01234567) * coeff51[hook(2, j++)];
    output += (float16)(prev.scdef, cur.s01234567, cur.s89ab) * coeff51[hook(2, j++)];
    output += cur * coeff51[hook(2, j++)];
    prev = cur;
  }
  float16 temp14 = convert_float16(vload16(13, src));
  output += (float16)(prev.s4567, prev.s89abcdef, temp14.s0123) * coeff51[hook(2, 49)];
  output += (float16)(prev.s89abcdef, temp14.s01234567) * coeff51[hook(2, 50)];
  vstore16(output, 0, dst);
}