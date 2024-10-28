//{"curFrame":2,"out":3,"videoHeight":1,"videoWidth":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void helloPixel(float videoWidth, float videoHeight, float curFrame, global uchar4* out) {
  unsigned int gid = get_global_id(0);
  float row = gid / videoWidth;
  float col = fmod(gid, videoWidth);

  out[hook(3, gid)].x = 255;
  out[hook(3, gid)].y = 255 * (sinpi(((col + fmod(curFrame * 8, videoWidth)) / videoWidth) * 2.0) / 2.0 + 0.5);
  out[hook(3, gid)].z = 255 * (sinpi(((row + fmod(curFrame, videoHeight)) / videoHeight) * 2.0) / 2.0 + 0.5);
  out[hook(3, gid)].w = 0;
}