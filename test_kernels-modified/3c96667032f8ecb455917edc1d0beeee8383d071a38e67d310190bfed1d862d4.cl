//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int opencl_version = 2;
constant int have_cl_khr_fp64 = 0;
constant int have_cl_khr_fp16 = 0;
kernel void testkernel(global int* data) {
  char c = 123;
  uchar uc = 123;
  short s = 123;
  ushort us = 123;
  int i = 123;
  unsigned int ui = 123;
  long l = 123;
  ulong ul = 123;

  float f = 123.0;

  double d = 123.0;

  data[hook(0, get_global_id(0))] = 1;
}