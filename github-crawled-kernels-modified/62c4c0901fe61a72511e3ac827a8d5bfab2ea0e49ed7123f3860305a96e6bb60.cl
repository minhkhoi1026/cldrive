//{"pIb":4,"pIg":3,"pImg":0,"pIr":2,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Split_8U(global const uchar* pImg, const int width, global uchar* pIr, global uchar* pIg, global uchar* pIb) {
  const int x = get_global_id(0) * 12;
  const int y = get_global_id(1);

  const int offset = (y * width) + x;

  pIr[hook(2, offset)] = pImg[hook(0, offset)];
  pIg[hook(3, offset)] = pImg[hook(0, offset + 1)];
  pIb[hook(4, offset)] = pImg[hook(0, offset + 2)];

  pIr[hook(2, offset + 1)] = pImg[hook(0, offset + 3)];
  pIg[hook(3, offset + 1)] = pImg[hook(0, offset + 4)];
  pIb[hook(4, offset + 1)] = pImg[hook(0, offset + 5)];

  pIr[hook(2, offset + 2)] = pImg[hook(0, offset + 6)];
  pIg[hook(3, offset + 2)] = pImg[hook(0, offset + 7)];
  pIb[hook(4, offset + 2)] = pImg[hook(0, offset + 8)];

  pIr[hook(2, offset + 3)] = pImg[hook(0, offset + 9)];
  pIg[hook(3, offset + 3)] = pImg[hook(0, offset + 10)];
  pIb[hook(4, offset + 3)] = pImg[hook(0, offset + 11)];
}