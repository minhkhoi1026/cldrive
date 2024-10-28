//{"mA":0,"mC":1,"mWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mataccKernel5(global float8* mA, global float* mC, const unsigned int mWidth) {
  unsigned int g_id = get_group_id(0);
  unsigned int nunits = get_num_groups(0);
  float8 elt = (float8)(0.0);
  for (unsigned int idx = 0; idx < mWidth * mWidth / 8 / nunits; idx++) {
    float8 mAtmp = mA[hook(0, idx)];
    elt.s0 += mAtmp.s0;
    elt.s1 += mAtmp.s1;
    elt.s2 += mAtmp.s2;
    elt.s3 += mAtmp.s3;
    elt.s4 += mAtmp.s4;
    elt.s5 += mAtmp.s5;
    elt.s6 += mAtmp.s6;
    elt.s7 += mAtmp.s7;
  }
  mC[hook(1, g_id)] = elt.s0 + elt.s1 + elt.s2 + elt.s3 + elt.s4 + elt.s5 + elt.s6 + elt.s7;
}