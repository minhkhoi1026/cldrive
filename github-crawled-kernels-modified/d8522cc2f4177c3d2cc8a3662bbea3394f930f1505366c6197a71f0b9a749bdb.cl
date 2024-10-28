//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
char4 test_int(char c, char4 c4) {
  char m = max(c, c);
  char4 m4 = max(c4, c4);
  uchar4 abs1 = abs(c4);
  uchar4 abs2 = abs(abs1);
  return max(c4, c);
}

kernel void basic_vector_misc(float4 a) {
  float4 res;
  uint4 mask = (uint4)(1, 2, 3, 4);

  res = shuffle(a, mask);
}