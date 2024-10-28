//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test() {
  volatile char c1 = mad_hi((char)10, (char)2, (char)7);
  volatile char2 c2 = mad_hi((char2)10, (char2)2, (char)7);
  volatile char3 c3 = mad_hi((char3)10, (char3)2, (char)7);
  volatile char4 c4 = mad_hi((char4)10, (char4)2, (char)7);

  volatile uchar uc1 = mad_hi((uchar)10, (uchar)2, (uchar)7);
  volatile uchar2 uc2 = mad_hi((uchar2)10, (uchar2)2, (uchar)7);
  volatile uchar3 uc3 = mad_hi((uchar3)10, (uchar3)2, (uchar)7);
  volatile uchar4 uc4 = mad_hi((uchar4)10, (uchar4)2, (uchar)7);

  volatile short s1 = mad_hi((short)10, (short)2, (short)7);
  volatile short2 s2 = mad_hi((short2)10, (short2)2, (short)7);
  volatile short3 s3 = mad_hi((short3)10, (short3)2, (short)7);
  volatile short4 s4 = mad_hi((short4)10, (short4)2, (short)7);

  volatile ushort us1 = mad_hi((ushort)10, (ushort)2, (ushort)7);
  volatile ushort2 us2 = mad_hi((ushort2)10, (ushort2)2, (ushort)7);
  volatile ushort3 us3 = mad_hi((ushort3)10, (ushort3)2, (ushort)7);
  volatile ushort4 us4 = mad_hi((ushort4)10, (ushort4)2, (ushort)7);

  volatile int i1 = mad_hi((int)10, (int)2, (int)7);
  volatile int2 i2 = mad_hi((int2)10, (int2)2, (int)7);
  volatile int3 i3 = mad_hi((int3)10, (int3)2, (int)7);
  volatile int4 i4 = mad_hi((int4)10, (int4)2, (int)7);

  volatile unsigned int ui1 = mad_hi((unsigned int)10, (unsigned int)2, (unsigned int)7);
  volatile uint2 ui2 = mad_hi((uint2)10, (uint2)2, (unsigned int)7);
  volatile uint3 ui3 = mad_hi((uint3)10, (uint3)2, (unsigned int)7);
  volatile uint4 ui4 = mad_hi((uint4)10, (uint4)2, (unsigned int)7);

  volatile long l1 = mad_hi((long)10, (long)2, (long)7);
  volatile long2 l2 = mad_hi((long2)10, (long2)2, (long)7);
  volatile long3 l3 = mad_hi((long3)10, (long3)2, (long)7);
  volatile long4 l4 = mad_hi((long4)10, (long4)2, (long)7);

  volatile ulong ul1 = mad_hi((ulong)10, (ulong)2, (ulong)7);
  volatile ulong2 ul2 = mad_hi((ulong2)10, (ulong2)2, (ulong)7);
  volatile ulong3 ul3 = mad_hi((ulong3)10, (ulong3)2, (ulong)7);
  volatile ulong4 ul4 = mad_hi((ulong4)10, (ulong4)2, (ulong)7);
}