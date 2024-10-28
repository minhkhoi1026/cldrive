//{"blurx":0,"blury":1,"depth":4,"sh":3,"sw":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_blur_y(global const float8* blurx, global float8* blury, int sw, int sh, int depth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  for (int d = 0; d < depth; d++) {
    const int yp = max(y - 1, 0);
    const int yn = min(y + 1, sh - 1);

    float8 v = blurx[hook(0, x + sw * (yp + d * sh))] + 4.0f * blurx[hook(0, x + sw * (y + d * sh))] + blurx[hook(0, x + sw * (yn + d * sh))];

    blury[hook(1, x + sw * (y + d * sh))] = v;
  }
}