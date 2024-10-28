//{"in_colour":1,"in_verts":0,"target":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 4 | 0x20;
kernel void half_space_box(constant int2* in_verts, constant float4* in_colour, write_only image2d_t target) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int tri_id = get_global_id(2);

  int index = tri_id * 3;

  int2 v1 = in_verts[hook(0, index)];
  int2 v2 = in_verts[hook(0, index + 1)];
  int2 v3 = in_verts[hook(0, index + 2)];

  int temp = min(v1.x, v2.x);
  int minm = min(temp, v3.x);
  temp = max(v1.x, v2.x);
  int maxm = max(temp, v3.x);

  if (x > minm && x < maxm) {
    temp = min(v1.y, v2.y);
    minm = min(temp, v3.y);
    temp = max(v1.y, v2.y);
    maxm = max(temp, v3.y);

    if (y > minm && y < maxm) {
      int f1 = (v1.x - v2.x) * (y - v1.y) - (v1.y - v2.y) * (x - v1.x);
      int f2 = (v2.x - v3.x) * (y - v2.y) - (v2.y - v3.y) * (x - v2.x);
      int f3 = (v3.x - v1.x) * (y - v3.y) - (v3.y - v1.y) * (x - v3.x);

      if (f1 > 0 && f2 > 0 && f3 > 0) {
        write_imagef(target, (int2)(x, y), in_colour[hook(1, tri_id)]);
      }
    }
  }
}