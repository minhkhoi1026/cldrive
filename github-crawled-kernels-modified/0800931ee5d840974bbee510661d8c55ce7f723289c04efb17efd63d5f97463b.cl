//{"inputImg":0,"outputImg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void img_trans(global uchar4* inputImg, global uchar4* outputImg) {
  int gid = get_global_id(0) + get_global_id(1) * get_global_size(0);

  uchar4 vectorIn = inputImg[hook(0, gid)];
  unsigned int gray = vectorIn.x * 0.07 + vectorIn.y * 0.72 + vectorIn.z * 0.21;
  outputImg[hook(1, gid)] = (uchar4)(gray, gray, gray, (uchar)255);
}