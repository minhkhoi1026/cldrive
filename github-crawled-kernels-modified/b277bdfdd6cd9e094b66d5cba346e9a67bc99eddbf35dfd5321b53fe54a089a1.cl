//{"dA":2,"dA_offset":3,"dB":5,"dB_offset":6,"ldda":4,"lddb":7,"m":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clacpy_device_lower(int m, int n, const global float2* dA, unsigned long dA_offset, int ldda, global float2* dB, unsigned long dB_offset, int lddb) {
  dA += dA_offset;
  dB += dB_offset;

  int ind = get_group_id(0) * 8 + get_local_id(0);
  int iby = get_group_id(1) * 8;

  bool full = (iby + 8 <= n && (ind >= iby + 8));

  if (ind < m && ind + 8 > iby) {
    dA += ind + iby * ldda;
    dB += ind + iby * lddb;
    if (full) {
      for (int j = 0; j < 8; ++j) {
        dB[hook(5, j * lddb)] = dA[hook(2, j * ldda)];
      }
    } else {
      for (int j = 0; j < 8 && iby + j < n && ind >= iby + j; ++j) {
        dB[hook(5, j * lddb)] = dA[hook(2, j * ldda)];
      }
    }
  }
}