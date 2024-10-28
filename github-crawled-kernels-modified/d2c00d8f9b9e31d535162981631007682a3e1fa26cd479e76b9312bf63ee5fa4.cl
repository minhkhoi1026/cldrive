//{"in_verts":0,"out_rect":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 4 | 0x20;
kernel void bounding_box(constant int2* in_verts, global int4* out_rect) {
  int id = get_global_id(0);

  int in_id = id * 3;

  int2 v1 = in_verts[hook(0, in_id)];
  int2 v2 = in_verts[hook(0, in_id + 1)];
  int2 v3 = in_verts[hook(0, in_id + 2)];

  int4 bounds;

  int temp = min(v1.x, v2.x);
  bounds.s0 = min(temp, v3.x);

  temp = min(v1.y, v2.y);
  bounds.s1 = min(temp, v3.y);

  temp = max(v1.x, v2.x);
  bounds.s2 = max(temp, v3.x);

  temp = max(v1.y, v2.y);
  bounds.s3 = max(temp, v3.y);

  out_rect[hook(1, id)] = bounds;
}