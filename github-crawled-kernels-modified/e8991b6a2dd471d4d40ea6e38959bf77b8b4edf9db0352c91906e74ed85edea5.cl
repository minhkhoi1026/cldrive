//{"im_height":3,"im_width":2,"in":1,"out":0,"uvShrd":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar4 convertYVUtoRGBA(int y, int u, int v) {
  uchar4 ret;
  y -= 16;
  u -= 128;
  v -= 128;
  int b = y + (int)(1.772f * u);
  int g = y - (int)(0.344f * u + 0.714f * v);
  int r = y + (int)(1.402f * v);
  ret.x = r > 255 ? 255 : r < 0 ? 0 : r;
  ret.y = g > 255 ? 255 : g < 0 ? 0 : g;
  ret.z = b > 255 ? 255 : b < 0 ? 0 : b;
  ret.w = 255;
  return ret;
}

kernel void nv21torgba(global uchar4* out, global uchar* in, int im_width, int im_height) {
  local uchar uvShrd[(2 * (16 / 2) * (16 / 2))];
  int gx = get_global_id(0);
  int gy = get_global_id(1);
  int lx = get_local_id(0);
  int ly = get_local_id(1);
  int off = im_width * im_height;

  int inIdx = gy * im_width + gx;
  int uvIdx = off + (gy / 2) * im_width + (gx & ~1);
  int shlx = lx / 2;
  int shly = ly / 2;
  int shIdx = 2 * (shlx + shly * (16 / 2));
  if (gx % 2 == 0 && gy % 2 == 0) {
    uvShrd[hook(4, shIdx + 0)] = in[hook(1, uvIdx + 0)];
    uvShrd[hook(4, shIdx + 1)] = in[hook(1, uvIdx + 1)];
  }

  int y = (0xFF & ((int)in[hook(1, inIdx)]));
  if (y < 16)
    y = 16;
  barrier(0x01);

  if (gx >= im_width || gy >= im_height)
    return;

  int v = (0xFF & ((int)uvShrd[hook(4, shIdx + 0)]));
  int u = (0xFF & ((int)uvShrd[hook(4, shIdx + 1)]));

  out[hook(0, inIdx)] = convertYVUtoRGBA(y, u, v);
}