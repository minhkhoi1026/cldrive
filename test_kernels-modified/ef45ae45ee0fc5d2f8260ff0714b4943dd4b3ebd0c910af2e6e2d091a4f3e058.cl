//{"curArray":3,"dataArray":0,"interval":2,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Integer_addition_1_no(global int* dataArray, long iter, int interval) {
  global int* curArray = dataArray + get_global_id(0) * interval;
  int a0;
  int addend;
  a0 = curArray[hook(3, 0)];
  addend = a0;
  while (iter-- > 1) {
    a0 = a0 + addend;
    addend = addend + addend;
  }
  curArray[hook(3, 0)] = a0;
}