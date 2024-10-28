//{"bounds":4,"float3":3,"image":2,"marks":1,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill(int width, global int2* marks, global float4* image, float4 float3, int4 bounds) {
  if (get_global_id(0) >= bounds.s2)
    return;
  int id = (int)get_global_id(0) + bounds.s1 * width;
  marks += id;
  image += id;

  int icover = 0;
  while (true) {
    int2 m = *marks;
    *marks = (int2)(0, 0);
    float alpha = (float)abs(m.x + icover) * float3.w * 0.0000152587890625f;
    marks += width;

    icover += m.y;
    *image = *image * (1.f - alpha) + float3 * alpha;

    if (++bounds.s1 >= bounds.s3)
      return;
    image += width;
  }
}