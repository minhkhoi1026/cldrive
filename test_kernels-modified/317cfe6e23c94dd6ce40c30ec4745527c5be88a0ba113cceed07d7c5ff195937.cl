//{"mA":0,"mC":1,"mCtmp":3,"mWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mataccKernel7(global float8* mA, global float* mC, const unsigned int mWidth) {
  const int nthreads = 16;
  unsigned int nunits = get_num_groups(0);
  unsigned int mSize = mWidth * mWidth / 8 / nthreads / nunits;
  unsigned int g_id = get_group_id(0);
  unsigned int l_id = get_local_id(0);
  local float mCtmp[16];
  float8 elt = (float8)(0.0);
  for (unsigned int idx = mSize * l_id; idx < mSize * (l_id + 1); idx++) {
    float8 mAtmp = mA[hook(0, idx + g_id * mSize)];
    elt.s0 += mAtmp.s0;
    elt.s1 += mAtmp.s1;
    elt.s2 += mAtmp.s2;
    elt.s3 += mAtmp.s3;
    elt.s4 += mAtmp.s4;
    elt.s5 += mAtmp.s5;
    elt.s6 += mAtmp.s6;
    elt.s7 += mAtmp.s7;
  }
  mCtmp[hook(3, l_id)] = elt.s0 + elt.s1 + elt.s2 + elt.s3 + elt.s4 + elt.s5 + elt.s6 + elt.s7;
  barrier(0x01);
  mC[hook(1, g_id)] = mCtmp[hook(3, 0)] + mCtmp[hook(3, 1)] + mCtmp[hook(3, 2)] + mCtmp[hook(3, 3)] + mCtmp[hook(3, 4)] + mCtmp[hook(3, 5)] + mCtmp[hook(3, 6)] + mCtmp[hook(3, 7)] + mCtmp[hook(3, 8)] + mCtmp[hook(3, 9)] + mCtmp[hook(3, 10)] + mCtmp[hook(3, 11)] + mCtmp[hook(3, 12)] + mCtmp[hook(3, 13)] + mCtmp[hook(3, 14)] + mCtmp[hook(3, 15)];
}