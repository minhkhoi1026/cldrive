//{"buf":8,"d_Buf":0,"d_Data":1,"d_DataPrefix":0,"d_Dst":2,"d_Src":0,"d_validIDs":1,"l_Data":3,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int warpScanInclusive(unsigned int idata, volatile local unsigned int* l_Data, unsigned int size) {
  unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (size - 1));
  l_Data[hook(3, pos)] = 0;
  pos += size;
  l_Data[hook(3, pos)] = idata;

  if (size >= 2)
    l_Data[hook(3, pos)] += l_Data[hook(3, pos - 1)];
  if (size >= 4)
    l_Data[hook(3, pos)] += l_Data[hook(3, pos - 2)];
  if (size >= 8)
    l_Data[hook(3, pos)] += l_Data[hook(3, pos - 4)];
  if (size >= 16)
    l_Data[hook(3, pos)] += l_Data[hook(3, pos - 8)];
  if (size >= 32)
    l_Data[hook(3, pos)] += l_Data[hook(3, pos - 16)];

  return l_Data[hook(3, pos)];
}

inline unsigned int warpScanExclusive(unsigned int idata, local unsigned int* l_Data, unsigned int size) {
  return warpScanInclusive(idata, l_Data, size) - idata;
}

inline unsigned int scan1Inclusive(unsigned int idata, local unsigned int* l_Data, unsigned int size) {
  if (size > (1U << 5U)) {
    unsigned int warpResult = warpScanInclusive(idata, l_Data, (1U << 5U));

    barrier(0x01);
    if ((get_local_id(0) & ((1U << 5U) - 1)) == ((1U << 5U) - 1))
      l_Data[hook(3, get_local_id(0) >> 5U)] = warpResult;

    barrier(0x01);
    if (get_local_id(0) < (1024 / (1U << 5U))) {
      unsigned int val = l_Data[hook(3, get_local_id(0))];

      l_Data[hook(3, get_local_id(0))] = warpScanExclusive(val, l_Data, size >> 5U);
    }

    barrier(0x01);
    return warpResult + l_Data[hook(3, get_local_id(0) >> 5U)];
  } else {
    return warpScanInclusive(idata, l_Data, size);
  }
}

inline unsigned int scan1Exclusive(unsigned int idata, local unsigned int* l_Data, unsigned int size) {
  return scan1Inclusive(idata, l_Data, size) - idata;
}

inline uint8 scan8Inclusive(uint8 data8, local unsigned int* l_Data, unsigned int size) {
  data8.s1 += data8.s0;
  data8.s2 += data8.s1;
  data8.s3 += data8.s2;
  data8.s4 += data8.s3;
  data8.s5 += data8.s4;
  data8.s6 += data8.s5;
  data8.s7 += data8.s6;

  unsigned int val = scan1Inclusive(data8.s7, l_Data, size / 8) - data8.s7;

  return (data8 + (uint8)val);
}

inline uint8 scan8Exclusive(uint8 data8, local unsigned int* l_Data, unsigned int size) {
  return scan8Inclusive(data8, l_Data, size) - data8;
}

inline void scanExclusiveLocal1(uint8 idata8, global uint8* d_Dst, local unsigned int* l_Data, unsigned int size) {
  uint8 odata8 = scan8Exclusive(idata8, l_Data, size);

  d_Dst[hook(2, get_global_id(0))] = odata8;
}

inline void scanExclusiveLocal2(unsigned int indata, global unsigned int* d_Buf, global unsigned int* d_Dst, local unsigned int* l_Data, unsigned int size) {
  unsigned int data = 0;
  if (get_global_id(0) < size)
    data = d_Dst[hook(2, (8 * 1024 - 1) + (8 * 1024) * get_global_id(0))] + indata;

  unsigned int odata = scan1Exclusive(data, l_Data, size);

  if (get_global_id(0) < size)
    d_Buf[hook(0, get_global_id(0))] = odata;
}

kernel __attribute__((reqd_work_group_size(1024, 1, 1))) void scanExclusiveLocal1_kernel(global uint8* d_Src, global uint8* d_Dst, local unsigned int* l_Data, unsigned int size) {
  uint8 idata8 = d_Src[hook(0, get_global_id(0))];

  scanExclusiveLocal1(idata8, d_Dst, l_Data, size);
}

kernel __attribute__((reqd_work_group_size(1024, 1, 1))) void scanExclusiveLocal2_kernel(global unsigned int* d_Src, global unsigned int* d_Buf, global unsigned int* d_Dst, local unsigned int* l_Data, unsigned int size) {
  unsigned int indata = d_Src[hook(0, (8 * 1024 - 1) + (8 * 1024) * get_global_id(0))];
  scanExclusiveLocal2(indata, d_Buf, d_Dst, l_Data, size);
}

kernel __attribute__((reqd_work_group_size(1024, 1, 1))) void exclusiveScanFlag1_kernel(global uchar8* d_Src, global uint8* d_Dst, local unsigned int* l_Data, unsigned int size) {
  uint8 idata8;
  uchar8 srcs = d_Src[hook(0, get_global_id(0))];
  idata8.s0 = convert_uint(srcs.s0 > 0);
  idata8.s1 = convert_uint(srcs.s1 > 0);
  idata8.s2 = convert_uint(srcs.s2 > 0);
  idata8.s3 = convert_uint(srcs.s3 > 0);
  idata8.s4 = convert_uint(srcs.s4 > 0);
  idata8.s5 = convert_uint(srcs.s5 > 0);
  idata8.s6 = convert_uint(srcs.s6 > 0);
  idata8.s7 = convert_uint(srcs.s7 > 0);

  scanExclusiveLocal1(idata8, d_Dst, l_Data, size);
}

kernel __attribute__((reqd_work_group_size(1024, 1, 1))) void exclusiveScanFlag2_kernel(global uchar* d_Src, global unsigned int* d_Buf, global unsigned int* d_Dst, local unsigned int* l_Data, unsigned int size) {
  unsigned int indata = convert_uint(d_Src[hook(0, (8 * 1024 - 1) + (8 * 1024) * get_global_id(0))] > 0);

  scanExclusiveLocal2(indata, d_Buf, d_Dst, l_Data, size);
}

kernel __attribute__((reqd_work_group_size(1024, 1, 1))) void uniformUpdate_kernel(global unsigned int* d_Buf, global uint8* d_Data) {
  local unsigned int buf[1];

  uint8 data8 = d_Data[hook(1, get_global_id(0))];

  if (get_local_id(0) == 0)
    buf[hook(8, 0)] = d_Buf[hook(0, get_group_id(0))];

  barrier(0x01);
  data8 += (uint8)buf[hook(8, 0)];
  d_Data[hook(1, get_global_id(0))] = data8;
}

kernel void compactifyValidPrefixSum_kernel(global unsigned int* d_DataPrefix, global int* d_validIDs) {
  const unsigned int gidx = get_global_id(0);
  unsigned int prefixIdx = d_DataPrefix[hook(0, gidx)];
  if (prefixIdx > 0)
    prefixIdx--;
  d_validIDs[hook(1, prefixIdx)] = gidx;
}