//{"dstImage":0,"float3":4,"pos":1,"radius":2,"ringSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void drop2D(write_only image2d_t dstImage, const float2 pos, const float radius, const float ringSize, const float4 float3) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float2 pnt = (float2)((float)coords.x, (float)coords.y);
  float dist = distance(pnt, pos);
  if (fabs(dist - radius) < ringSize) {
    write_imagef(dstImage, coords, float3);
  }
}