//{"ee":6,"iz":3,"nx":0,"ny":1,"nz":2,"offset":4,"slice":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void slice_kern(int nx, int ny, int nz, int iz, int offset, global float4* slice, global float4* ee) {
  const float4 third4 = (float4)(0.3f, 0.3f, 0.3f, 0.3f);
  int gtx = get_global_id(0);
  int gty = get_global_id(1);

  int gci3 = 3 * (gtx * ny * nz + gty * nz) + 3;

  float4 tmpx = ee[hook(6, gci3 + 0 * nz)];
  float4 tmpy = ee[hook(6, gci3 + 1 * nz)];
  float4 tmpz = ee[hook(6, gci3 + 2 * nz)];

  tmpx *= tmpx;
  tmpy *= tmpy;
  tmpz *= tmpz;
  float4 power = third4 * fabs(tmpx + tmpy + tmpz);

  slice[hook(5, offset + gtx * ny + gty)] = power;

  return;
}