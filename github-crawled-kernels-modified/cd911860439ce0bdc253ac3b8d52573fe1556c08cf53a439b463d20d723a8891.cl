//{"dst":32,"idim0":10,"idim1":11,"idim2":12,"idim3":13,"iptr":9,"nBBS0":30,"nBBS1":31,"odim0":1,"odim1":2,"odim2":3,"odim3":4,"optr":0,"ostride0":5,"ostride1":6,"ostride2":7,"ostride3":8,"poff0":14,"poff1":15,"poff2":16,"poff3":17,"pseq0":22,"pseq1":23,"pseq2":24,"pseq3":25,"pstrd0":18,"pstrd1":19,"pstrd2":20,"pstrd3":21,"ptr0":26,"ptr1":27,"ptr2":28,"ptr3":29,"src":33}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int trimIndex(int idx, const int len) {
  int ret_val = idx;
  int offset = abs(ret_val) % len;
  if (ret_val < 0) {
    ret_val = offset - 1;
  } else if (ret_val >= len) {
    ret_val = len - offset - 1;
  }
  return ret_val;
}

kernel void indexKernel(global float* optr, const int odim0, const int odim1, const int odim2, const int odim3, const int ostride0, const int ostride1, const int ostride2, const int ostride3, global const float* iptr, const int idim0, const int idim1, const int idim2, const int idim3, const int poff0, const int poff1, const int poff2, const int poff3, const int pstrd0, const int pstrd1, const int pstrd2, const int pstrd3, const char pseq0, const char pseq1, const char pseq2, const char pseq3, global const float* ptr0, global const float* ptr1, global const float* ptr2, global const float* ptr3, const int nBBS0, const int nBBS1) {
  const bool s0 = pseq0;
  const bool s1 = pseq1;
  const bool s2 = pseq2;
  const bool s3 = pseq3;

  const int gz = get_group_id(0) / nBBS0;
  const int gw = get_group_id(1) / nBBS1;
  const int gx = get_local_size(0) * (get_group_id(0) - gz * nBBS0) + get_local_id(0);
  const int gy = get_local_size(1) * (get_group_id(1) - gw * nBBS1) + get_local_id(1);

  if (gx < odim0 && gy < odim1 && gz < odim2 && gw < odim3) {
    int i = pstrd0 * trimIndex(s0 ? gx + poff0 : ptr0[hook(26, gx)], idim0);
    int j = pstrd1 * trimIndex(s1 ? gy + poff1 : ptr1[hook(27, gy)], idim1);
    int k = pstrd2 * trimIndex(s2 ? gz + poff2 : ptr2[hook(28, gz)], idim2);
    int l = pstrd3 * trimIndex(s3 ? gw + poff3 : ptr3[hook(29, gw)], idim3);

    global const float* src = iptr + (i + j + k + l);
    global float* dst = optr + (gx * ostride0 + gy * ostride1 + gz * ostride2 + gw * ostride3);

    dst[hook(32, 0)] = src[hook(33, 0)];
  }
}