//{"A_offset":4,"B_offset":5,"a":6,"b":7,"c":8,"colsA":2,"colsB":3,"offColA":10,"offColB":11,"offset":9,"rowsA":0,"rowsB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mma_tranpose_AFn(int rowsA, int rowsB, int colsA, int colsB, int A_offset, int B_offset, global float* a, global float* b, global float* c, int offset) {
  int idx = get_global_id(0);

  global float* offColA = (a + A_offset) + (idx % colsA) * rowsA;
  global float* offColB = (b + B_offset) + (idx / colsA) * rowsB;

  float x = 0;
  for (int i = 0; i < rowsA; ++i)
    x += offColA[hook(10, i)] * offColB[hook(11, i)];

  c[hook(8, idx + offset)] += x;
}