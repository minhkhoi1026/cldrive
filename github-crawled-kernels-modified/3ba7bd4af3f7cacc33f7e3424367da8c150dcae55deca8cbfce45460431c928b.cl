//{"curArray":3,"dataArray":0,"interval":2,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Integer2_multiplication_10_10(global int2* dataArray, long iter, int interval) {
  global int2* curArray = dataArray + get_global_id(0) * interval;
  int2 a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
  int2 addend;
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
  addend = a0;
  while (iter-- > 1) {
    a1 = a1 * addend;
    a2 = a2 * a1;
    a3 = a3 * a2;
    a4 = a4 * a3;
    a5 = a5 * a4;
    a6 = a6 * a5;
    a7 = a7 * a6;
    a8 = a8 * a7;
    a9 = a9 * a8;
    a0 = a0 * a9;
    addend = addend * a0;
    a1 = a1 * addend;
    a2 = a2 * a1;
    a3 = a3 * a2;
    a4 = a4 * a3;
    a5 = a5 * a4;
    a6 = a6 * a5;
    a7 = a7 * a6;
    a8 = a8 * a7;
    a9 = a9 * a8;
    a0 = a0 * a9;
    addend = addend * a0;
    a1 = a1 * addend;
    a2 = a2 * a1;
    a3 = a3 * a2;
    a4 = a4 * a3;
    a5 = a5 * a4;
    a6 = a6 * a5;
    a7 = a7 * a6;
    a8 = a8 * a7;
    a9 = a9 * a8;
    a0 = a0 * a9;
    addend = addend * a0;
    a1 = a1 * addend;
    a2 = a2 * a1;
    a3 = a3 * a2;
    a4 = a4 * a3;
    a5 = a5 * a4;
    a6 = a6 * a5;
    a7 = a7 * a6;
    a8 = a8 * a7;
    a9 = a9 * a8;
    a0 = a0 * a9;
    addend = addend * a0;
    a1 = a1 * addend;
    a2 = a2 * a1;
    a3 = a3 * a2;
    a4 = a4 * a3;
    a5 = a5 * a4;
    a6 = a6 * a5;
    a7 = a7 * a6;
    a8 = a8 * a7;
    a9 = a9 * a8;
    a0 = a0 * a9;
    addend = addend * a0;
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