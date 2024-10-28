//{"crc":1,"g_table":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void precompute(global unsigned char* g_table, const unsigned char crc) {
  unsigned int tid = get_global_id(0);
  unsigned char num = tid;
  unsigned char crcCalc = 0x0;

  for (unsigned int k = 0; k < 8; k++) {
    if ((num >> (7 - k)) % 2 == 1) {
      num ^= crc >> (k + 1);
      crcCalc ^= crc << (7 - k);
    }
  }

  g_table[hook(0, tid)] = crcCalc;
}