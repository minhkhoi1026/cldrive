//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test() {
  volatile char c1 = mul_hi((char)10, (char)2);
  volatile char2 c2 = mul_hi((char2)10, (char2)2);
  volatile char3 c3 = mul_hi((char3)10, (char3)2);
  volatile char4 c4 = mul_hi((char4)10, (char4)2);

  volatile uchar uc1 = mul_hi((uchar)10, (uchar)2);
  volatile uchar2 uc2 = mul_hi((uchar2)10, (uchar2)2);
  volatile uchar3 uc3 = mul_hi((uchar3)10, (uchar3)2);
  volatile uchar4 uc4 = mul_hi((uchar4)10, (uchar4)2);

  volatile short s1 = mul_hi((short)10, (short)2);
  volatile short2 s2 = mul_hi((short2)10, (short2)2);
  volatile short3 s3 = mul_hi((short3)10, (short3)2);
  volatile short4 s4 = mul_hi((short4)10, (short4)2);

  volatile ushort us1 = mul_hi((ushort)10, (ushort)2);
  volatile ushort2 us2 = mul_hi((ushort2)10, (ushort2)2);
  volatile ushort3 us3 = mul_hi((ushort3)10, (ushort3)2);
  volatile ushort4 us4 = mul_hi((ushort4)10, (ushort4)2);

  volatile int i1 = mul_hi((int)10, (int)2);
  volatile int2 i2 = mul_hi((int2)10, (int2)2);
  volatile int3 i3 = mul_hi((int3)10, (int3)2);
  volatile int4 i4 = mul_hi((int4)10, (int4)2);

  volatile unsigned int ui1 = mul_hi((unsigned int)10, (unsigned int)2);
  volatile uint2 ui2 = mul_hi((uint2)10, (uint2)2);
  volatile uint3 ui3 = mul_hi((uint3)10, (uint3)2);
  volatile uint4 ui4 = mul_hi((uint4)10, (uint4)2);

  volatile long l1 = mul_hi((long)10, (long)2);
  volatile long2 l2 = mul_hi((long2)10, (long2)2);
  volatile long3 l3 = mul_hi((long3)10, (long3)2);
  volatile long4 l4 = mul_hi((long4)10, (long4)2);

  volatile ulong ul1 = mul_hi((ulong)10, (ulong)2);
  volatile ulong2 ul2 = mul_hi((ulong2)10, (ulong2)2);
  volatile ulong3 ul3 = mul_hi((ulong3)10, (ulong3)2);
  volatile ulong4 ul4 = mul_hi((ulong4)10, (ulong4)2);
}