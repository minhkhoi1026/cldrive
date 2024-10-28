//{"curArray":3,"dataArray":0,"interval":2,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Double4_subtraction_0_10(global double4* dataArray, long iter, int interval) {
  global double4* curArray = dataArray + get_global_id(0) * interval;
  double4 a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
  double4 addend;
  a0 = curArray[hook(3, 0)];
  a1 = curArray[hook(3, 1)];
  a2 = curArray[hook(3, 2)];
  a3 = curArray[hook(3, 3)];
  a4 = curArray[hook(3, 4)];
  a5 = curArray[hook(3, 5)];
  a6 = curArray[hook(3, 6)];
  a7 = curArray[hook(3, 7)];
  a8 = curArray[hook(3, 8)];
  a9 = curArray[hook(3, 9)];
  addend = a5;
  while (iter-- > 0) {
    a0 = a0 - addend;
    a1 = a1 - addend;
    a2 = a2 - addend;
    a3 = a3 - addend;
    a4 = a4 - addend;
    a5 = a5 - addend;
    a6 = a6 - addend;
    a7 = a7 - addend;
    a8 = a8 - addend;
    a9 = a9 - addend;
    addend = 0.0 - addend;
    a0 = a0 - addend;
    a1 = a1 - addend;
    a2 = a2 - addend;
    a3 = a3 - addend;
    a4 = a4 - addend;
    a5 = a5 - addend;
    a6 = a6 - addend;
    a7 = a7 - addend;
    a8 = a8 - addend;
    a9 = a9 - addend;
    addend = 0.0 - addend;
    a0 = a0 - addend;
    a1 = a1 - addend;
    a2 = a2 - addend;
    a3 = a3 - addend;
    a4 = a4 - addend;
    a5 = a5 - addend;
    a6 = a6 - addend;
    a7 = a7 - addend;
    a8 = a8 - addend;
    a9 = a9 - addend;
    addend = 0.0 - addend;
    a0 = a0 - addend;
    a1 = a1 - addend;
    a2 = a2 - addend;
    a3 = a3 - addend;
    a4 = a4 - addend;
    a5 = a5 - addend;
    a6 = a6 - addend;
    a7 = a7 - addend;
    a8 = a8 - addend;
    a9 = a9 - addend;
    addend = 0.0 - addend;
    a0 = a0 - addend;
    a1 = a1 - addend;
    a2 = a2 - addend;
    a3 = a3 - addend;
    a4 = a4 - addend;
    a5 = a5 - addend;
    a6 = a6 - addend;
    a7 = a7 - addend;
    a8 = a8 - addend;
    a9 = a9 - addend;
    addend = 0.0 - addend;
  }
  curArray[hook(3, 0)] = a0;
  curArray[hook(3, 1)] = a1;
  curArray[hook(3, 2)] = a2;
  curArray[hook(3, 3)] = a3;
  curArray[hook(3, 4)] = a4;
  curArray[hook(3, 5)] = a5;
  curArray[hook(3, 6)] = a6;
  curArray[hook(3, 7)] = a7;
  curArray[hook(3, 8)] = a8;
  curArray[hook(3, 9)] = a9;
}