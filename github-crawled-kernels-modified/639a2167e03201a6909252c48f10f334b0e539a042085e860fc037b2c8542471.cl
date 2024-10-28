//{"dists":2,"idx":0,"rendered":4,"selDist":3,"zImg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void checkDepth(global const int4* idx, global const ushort* zImg, global const float4* dists, global float* selDist, global ushort* rendered) {
  const unsigned int i = get_global_id(0);

  const int4 index = idx[hook(0, i)];
  const ushort zI = zImg[hook(1, i)];
  const ushort thres = 0.01 * zI;
  const ushort zIThres = zI + thres;
  const float4 dist2 = dists[hook(2, i)];

  ushort zRen;
  zRen = rendered[hook(4, index.s0)];
  if (index.s0 >= 0 && ((abs_diff(zRen, zI) < thres && selDist[hook(3, index.s0)] > dist2.s0) || zRen > zIThres)) {
    selDist[hook(3, index.s0)] = dist2.s0;
    rendered[hook(4, index.s0)] = zI;
  }
  zRen = rendered[hook(4, index.s1)];
  if (index.s1 >= 0 && ((abs_diff(zRen, zI) < thres && selDist[hook(3, index.s1)] > dist2.s1) || zRen > zIThres)) {
    selDist[hook(3, index.s1)] = dist2.s1;
    rendered[hook(4, index.s1)] = zI;
  }
  zRen = rendered[hook(4, index.s2)];
  if (index.s2 >= 0 && ((abs_diff(zRen, zI) < thres && selDist[hook(3, index.s2)] > dist2.s2) || zRen > zIThres)) {
    selDist[hook(3, index.s2)] = dist2.s2;
    rendered[hook(4, index.s2)] = zI;
  }
  zRen = rendered[hook(4, index.s3)];
  if (index.s3 >= 0 && ((abs_diff(zRen, zI) < thres && selDist[hook(3, index.s3)] > dist2.s3) || zRen > zIThres)) {
    selDist[hook(3, index.s3)] = dist2.s3;
    rendered[hook(4, index.s3)] = zI;
  }
}