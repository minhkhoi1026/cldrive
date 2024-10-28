//{"closest_dist":6,"descriptors1":2,"descriptors2":3,"kptmap1":1,"kpts2":0,"tracks":4,"window":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
typedef int4 int4;
int brief_dist(int4 b1, int4 b2) {
  int4 v = b1 ^ b2;

  v = v - ((v >> 1) & 0x55555555);
  v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
  int4 c = ((v + (v >> 4) & 0xF0F0F0F) * 0x1010101) >> 24;

  return c.x + c.y + c.z + c.w;
}

kernel void track(global int2* kpts2, read_only image2d_t kptmap1, global int4* descriptors1, global int4* descriptors2, global int* tracks, unsigned window, unsigned closest_dist) {
  int index = get_global_id(0);
  int4 descr = descriptors2[hook(3, index)];

  int2 pixel = kpts2[hook(0, index)] / 2;

  int2 loc;
  int closest_index = -1;
  for (loc.x = pixel.x - window; loc.x <= pixel.x + window; loc.x++) {
    for (loc.y = pixel.y - window; loc.y <= pixel.y + window; loc.y++) {
      int val = read_imagei(kptmap1, imageSampler, loc).x;
      if (val > -1) {
        int dist = brief_dist(descriptors1[hook(2, val)], descr);
        if (dist <= closest_dist) {
          closest_dist = dist;
          closest_index = val;
        }
      }
    }
  }

  tracks[hook(4, index)] = closest_index;
}