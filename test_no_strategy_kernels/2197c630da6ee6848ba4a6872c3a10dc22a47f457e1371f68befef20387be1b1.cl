//{"fg4A":0,"fg4B":1,"fg4Hypot":2,"iInnerLoopCount":4,"uiNumElements":5,"uiOffset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorHypot(global float4* fg4A, global float4* fg4B, global float4* fg4Hypot, unsigned int uiOffset, int iInnerLoopCount, unsigned int uiNumElements) {
  size_t szGlobalOffset = get_global_id(0) + uiOffset;

  if (szGlobalOffset >= uiNumElements) {
    return;
  }

  float4 f4A = fg4A[hook(0, szGlobalOffset)];
  float4 f4B = fg4B[hook(1, szGlobalOffset)];
  float4 f4H = (float4)0.0f;

  for (int i = 0; i < iInnerLoopCount; i++) {
    f4H.x = hypot(f4A.x, f4B.x);
    f4H.y = hypot(f4A.y, f4B.y);
    f4H.z = hypot(f4A.z, f4B.z);
    f4H.w = hypot(f4A.w, f4B.w);
  }

  fg4Hypot[hook(2, szGlobalOffset)] = f4H;
}