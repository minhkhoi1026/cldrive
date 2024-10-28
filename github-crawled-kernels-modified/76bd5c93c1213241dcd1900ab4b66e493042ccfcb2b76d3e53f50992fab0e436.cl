//{"bin":0,"sm_mapping":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateBin(const unsigned int bin, global uchar4* sm_mapping) {
  unsigned char offset = bin % 4;
  unsigned char indexlo = (bin >> 2) % 256;
  unsigned char indexhi = (bin >> 10) % 2;
  unsigned char block = bin / 8;

  offset *= 8;

  uchar4 sm;
  sm.x = block;
  sm.y = indexhi;
  sm.z = indexlo;
  sm.w = offset;

  *sm_mapping = sm;
}