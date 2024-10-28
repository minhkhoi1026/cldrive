//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void so(global int* out) {
  int i = 0;

  out[hook(0, i++)] = sizeof(char);
  out[hook(0, i++)] = sizeof(uchar);
  out[hook(0, i++)] = sizeof(short);
  out[hook(0, i++)] = sizeof(ushort);
  out[hook(0, i++)] = sizeof(int);
  out[hook(0, i++)] = sizeof(unsigned int);
  out[hook(0, i++)] = sizeof(long);
  out[hook(0, i++)] = sizeof(ulong);
  out[hook(0, i++)] = sizeof(float);

  out[hook(0, i++)] = sizeof(char2);
  out[hook(0, i++)] = sizeof(uchar2);
  out[hook(0, i++)] = sizeof(short2);
  out[hook(0, i++)] = sizeof(ushort2);
  out[hook(0, i++)] = sizeof(int2);
  out[hook(0, i++)] = sizeof(uint2);
  out[hook(0, i++)] = sizeof(long2);
  out[hook(0, i++)] = sizeof(ulong2);
  out[hook(0, i++)] = sizeof(float2);

  out[hook(0, i++)] = sizeof(char3);
  out[hook(0, i++)] = sizeof(uchar3);
  out[hook(0, i++)] = sizeof(short3);
  out[hook(0, i++)] = sizeof(ushort3);
  out[hook(0, i++)] = sizeof(int3);
  out[hook(0, i++)] = sizeof(uint3);
  out[hook(0, i++)] = sizeof(long3);
  out[hook(0, i++)] = sizeof(ulong3);
  out[hook(0, i++)] = sizeof(float3);
  out[hook(0, i++)] = sizeof(char4);
  out[hook(0, i++)] = sizeof(uchar4);
  out[hook(0, i++)] = sizeof(short4);
  out[hook(0, i++)] = sizeof(ushort4);
  out[hook(0, i++)] = sizeof(int4);
  out[hook(0, i++)] = sizeof(uint4);
  out[hook(0, i++)] = sizeof(long4);
  out[hook(0, i++)] = sizeof(ulong4);
  out[hook(0, i++)] = sizeof(float4);

  out[hook(0, i++)] = sizeof(char8);
  out[hook(0, i++)] = sizeof(uchar8);
  out[hook(0, i++)] = sizeof(short8);
  out[hook(0, i++)] = sizeof(ushort8);
  out[hook(0, i++)] = sizeof(int8);
  out[hook(0, i++)] = sizeof(uint8);
  out[hook(0, i++)] = sizeof(long8);
  out[hook(0, i++)] = sizeof(ulong8);
  out[hook(0, i++)] = sizeof(float8);

  out[hook(0, i++)] = sizeof(char16);
  out[hook(0, i++)] = sizeof(uchar16);
  out[hook(0, i++)] = sizeof(short16);
  out[hook(0, i++)] = sizeof(ushort16);
  out[hook(0, i++)] = sizeof(int16);
  out[hook(0, i++)] = sizeof(uint16);
  out[hook(0, i++)] = sizeof(long16);
  out[hook(0, i++)] = sizeof(ulong16);
  out[hook(0, i++)] = sizeof(float16);

  out[hook(0, i++)] = sizeof(float);

  out[hook(0, i++)] = sizeof(double);
  out[hook(0, i++)] = sizeof(double2);
  out[hook(0, i++)] = sizeof(double3);
  out[hook(0, i++)] = sizeof(double4);
  out[hook(0, i++)] = sizeof(double8);
  out[hook(0, i++)] = sizeof(double16);
}