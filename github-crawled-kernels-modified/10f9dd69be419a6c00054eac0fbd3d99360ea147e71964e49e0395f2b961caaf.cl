//{"N":1,"result_pown":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_pown_withDD1(global float* result_pown, int N) {
  float t1 = 2.2;
  int t2 = 1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    t1 = pown(t1, t2);
    ;
  }
  *result_pown = t1;
}