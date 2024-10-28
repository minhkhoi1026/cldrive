//{"in":0,"out1":1,"out2":2,"out3":3,"out4":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
short16 vc4cl_bitcast_short(int16) __attribute__((overloadable));
char16 vc4cl_bitcast_char(int16) __attribute__((overloadable));
kernel void test_vpm_write(global const int16* in, global int16* out1, global short16* out2, global char16* out3, global int16* out4) {
  int16 val = *in;
  for (int i = 0; i < 10; ++i)
    out1[hook(1, i)] = val;
  for (int i = 0; i < 10; ++i)
    out2[hook(2, i)] = vc4cl_bitcast_short(val);
  for (int i = 0; i < 10; ++i)
    out3[hook(3, i)] = vc4cl_bitcast_char(val);

  int easyStride = 3;
  for (int i = 0; i < 10; ++i)
    out4[hook(4, easyStride * i)] = val;
}