//{"curArray":3,"dataArray":0,"interval":2,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Integer_addition_4_no(global int* dataArray, long iter, int interval) {
  global int* curArray = dataArray + get_global_id(0) * interval;
  int a0, a1, a2, a3;
  int addend;
  a0 = curArray[hook(3, 0)];
  a1 = curArray[hook(3, 1)];
  a2 = curArray[hook(3, 2)];
  a3 = curArray[hook(3, 3)];
  addend = a0;
  while (iter-- > 1) {
    a0 = a0 + addend;
    a1 = a1 + addend;
    a2 = a2 + addend;
    a3 = a3 + addend;
    addend = addend + addend;
  }
  curArray[hook(3, 0)] = a0;
  curArray[hook(3, 1)] = a1;
  curArray[hook(3, 2)] = a2;
  curArray[hook(3, 3)] = a3;
}