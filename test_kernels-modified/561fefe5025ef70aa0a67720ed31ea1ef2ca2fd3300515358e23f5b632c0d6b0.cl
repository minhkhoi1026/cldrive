//{"a":0,"b":1,"c":2,"iNumElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int get_random(unsigned int* m_z, unsigned int* m_w) {
  (*m_z) = 36969 * ((*m_z) & 65535) + ((*m_z) >> 16);
  (*m_w) = 18000 * ((*m_w) & 65535) + ((*m_w) >> 16);
  return ((*m_z) << 16) + (*m_w);
}

inline unsigned int circular_shift_right(unsigned int value, unsigned int offset, unsigned int total_bits) {
  return (value >> offset) | (value << (total_bits - offset));
}

kernel void VectorAdd(global const float* a, global const float* b, global float* c, int iNumElements) {
  int iGID = get_global_id(0);

  if (iGID >= iNumElements) {
    return;
  }

  c[hook(2, iGID)] = a[hook(0, iGID)] + b[hook(1, iGID)];

  barrier(0x01);

  unsigned int z = circular_shift_right((unsigned int)iGID, 4, 32), w = (unsigned int)iGID;
  c[hook(2, iGID)] = get_random(&z, &w) % 0xFF;
}