//{"LARGE_H":5,"LARGE_W":4,"SMALL_H":7,"SMALL_W":6,"image_in":0,"image_out":1,"scale_h":3,"scale_w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
kernel void shrink(const global float* image_in, global float* image_out, const int scale_w, const int scale_h, const int LARGE_W, const int LARGE_H, const int SMALL_W, const int SMALL_H) {
  int gid0 = get_global_id(0), gid1 = get_global_id(1);
  int j, i = gid0 + SMALL_W * gid1;

  if ((gid0 < SMALL_W) && (gid1 < SMALL_H)) {
    j = gid0 * scale_w + gid1 * scale_h * LARGE_W;
    image_out[hook(1, i)] = image_in[hook(0, j)];
  };
}