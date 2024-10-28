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
  char ca = 2;
  char cb = 1;
  uchar uca = 2;
  uchar ucb = 1;
  char4 c4a = (char4)(2, 4, 8, 16);
  char4 c4b = (char4)(1, 2, 8, 4);
  uchar4 uc4a = (uchar4)(2, 4, 8, 16);
  uchar4 uc4b = (uchar4)(1, 2, 8, 4);

  short sa = 2;
  short sb = 1;
  ushort usa = 2;
  ushort usb = 1;
  short4 s4a = (short4)(2, 4, 8, 16);
  short4 s4b = (short4)(1, 2, 8, 4);
  ushort4 us4a = (ushort4)(2, 4, 8, 16);
  ushort4 us4b = (ushort4)(1, 2, 8, 4);

  int ia = 2;
  int ib = 1;
  unsigned int uia = 2;
  unsigned int uib = 1;
  int4 i4a = (int4)(2, 4, 8, 16);
  int4 i4b = (int4)(1, 2, 8, 4);
  uint4 ui4a = (uint4)(2, 4, 8, 16);
  uint4 ui4b = (uint4)(1, 2, 8, 4);

  long la = 2;
  long lb = 1;
  ulong ula = 2;
  ulong ulb = 1;
  long4 l4a = (long4)(2, 4, 8, 16);
  long4 l4b = (long4)(1, 2, 8, 4);
  ulong4 ul4a = (ulong4)(2, 4, 8, 16);
  ulong4 ul4b = (ulong4)(1, 2, 8, 4);
  float fa = 2;
  float fb = 1;
  float4 f4a = (float4)(2, 4, 8, 16);
  float4 f4b = (float4)(1, 2, 8, 4);

  double da = 2;
  double db = 1;
  double4 d4a = (double4)(2, 4, 8, 16);
  double4 d4b = (double4)(1, 2, 8, 4);

  uint4 ui4 = (uint4)(2, 4, 8, 16);
  int2 i2 = (int2)(1, 2);
  long2 l2 = (long2)(1, 2);

  float2 f2 = (float2)(1, 2);

  double2 d2 = (double2)(1, 2);

  data[hook(0, get_global_id(0))] = 1;
}