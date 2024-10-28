//{"N":1,"result_pown":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_pown_withoutDD1(global float* result_pown, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;
  float t8;
  float t9;
  float t10;

  float i = 0.0;
  int j = 1;
  float n = 7 * (float)(N);

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = pown(i, j);
    t2 = pown(i, j);
    t3 = pown(i, j);
    t4 = pown(i, j);
    t5 = pown(i, j);
    t6 = pown(i, j);
    t7 = pown(i, j);
    t8 = pown(i, j);
    t9 = pown(i, j);
    t10 = pown(i, j);
  }
  *result_pown = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}