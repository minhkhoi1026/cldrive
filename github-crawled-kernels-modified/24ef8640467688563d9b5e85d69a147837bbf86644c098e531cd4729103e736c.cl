//{"curArray":3,"dataArray":0,"interval":2,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Integer_addition_8_full(global int* dataArray, long iter, int interval) {
  global int* curArray = dataArray + get_global_id(0) * interval;
  int a0, a1, a2, a3, a4, a5, a6, a7;
  int addend;
  a0 = curArray[hook(3, 0)];
  a1 = curArray[hook(3, 1)];
  a2 = curArray[hook(3, 2)];
  a3 = curArray[hook(3, 3)];
  a4 = curArray[hook(3, 4)];
  a5 = curArray[hook(3, 5)];
  a6 = curArray[hook(3, 6)];
  a7 = curArray[hook(3, 7)];
  addend = a0;
  while (iter-- > 1) {
    a1 = a0 + addend;
    a2 = a1 + addend;
    a3 = a2 + addend;
    a4 = a3 + addend;
    a5 = a4 + addend;
    a6 = a5 + addend;
    a7 = a6 + addend;
    a0 = a7 + addend;
    addend = addend + addend;
  }
  curArray[hook(3, 0)] = a0;
  curArray[hook(3, 1)] = a1;
  curArray[hook(3, 2)] = a2;
  curArray[hook(3, 3)] = a3;
  curArray[hook(3, 4)] = a4;
  curArray[hook(3, 5)] = a5;
  curArray[hook(3, 6)] = a6;
  curArray[hook(3, 7)] = a7;
}