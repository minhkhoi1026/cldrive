//{"dispMap1":0,"dispMap2":1,"res":2,"threshold":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cross_check(global uchar* dispMap1, global uchar* dispMap2, global uchar* res, unsigned int threshold) {
  const int i = get_global_id(0);

  if (abs((int)dispMap1[hook(0, i)] - dispMap2[hook(1, i - dispMap1[ihook(0, i))]) > threshold)
    res[hook(2, i)] = 0;
  else
    res[hook(2, i)] = dispMap1[hook(0, i)];
}