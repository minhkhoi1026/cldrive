//{}
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

kernel void basic_vector_data() {
  void* generic_p;

  constant void* constant_p;
  local void* local_p;
  global void* global_p;
 private
  void* private_p;
  size_t s;

  vload4(s, (const constant ulong*)constant_p);
  vload16(s, (const constant short*)constant_p);

  vload3(s, (const __generic ushort*)generic_p);
  vload16(s, (const __generic uchar*)generic_p);

  vload8(s, (const global long*)global_p);
  vload2(s, (const local unsigned int*)local_p);
  vload16(s, (const private float*)private_p);
}