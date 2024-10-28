//{"test":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_bytes(global uchar16* test) {
  uint4 vec = (uint4)(0x00010203, 0x04050607, 0x08090A0B, 0x0C0D0E0F);
  uchar* p = (uchar*)&vec;
  *test = (uchar16)(*p, *(p + 1), *(p + 2), *(p + 3), *(p + 4), *(p + 5), *(p + 6), *(p + 7), *(p + 8), *(p + 9), *(p + 10), *(p + 11), *(p + 12), *(p + 13), *(p + 14), *(p + 15));
}