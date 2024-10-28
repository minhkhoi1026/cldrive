//{"bgc":4,"flags":2,"ih":6,"iw":5,"label":0,"maxpass":3,"pix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void labelxPreprocess_int_int(global int* label, global int* pix, global int* flags, int maxpass, int bgc, int iw, int ih) {
  const int x = get_global_id(0), y = get_global_id(1);
  const int p0 = y * iw + x;

  if (y == 0 && x < maxpass + 1) {
    flags[hook(2, x)] = x == 0 ? 1 : 0;
  }

  if (x >= iw || y >= ih)
    return;

  if (pix[hook(1, p0)] == bgc) {
    label[hook(0, p0)] = -1;
    return;
  }
  if (y > 0 && pix[hook(1, p0)] == pix[hook(1, p0 - iw)]) {
    label[hook(0, p0)] = p0 - iw;
    return;
  }
  if (x > 0 && pix[hook(1, p0)] == pix[hook(1, p0 - 1)]) {
    label[hook(0, p0)] = p0 - 1;
    return;
  }
  label[hook(0, p0)] = p0;
}