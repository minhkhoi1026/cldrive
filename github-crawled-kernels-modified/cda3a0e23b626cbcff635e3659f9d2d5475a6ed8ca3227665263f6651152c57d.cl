//{"a":0,"alpha":11,"b":1,"beta":12,"c":2,"col":4,"col2":6,"com":13,"d":3,"offsetac":10,"offsetar":9,"rcol":8,"row":5,"row2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void resize(global double* a, global double* b, global double* c, global double* d, unsigned long col, unsigned long row, unsigned long col2, unsigned long row2, unsigned long rcol, unsigned long offsetar, unsigned long offsetac, double alpha, double beta, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);

  unsigned long curr = i * col + j;
  unsigned long curr2 = (i + offsetar) * rcol + j + offsetac;

  if (i < row2 && j < col2) {
    a[hook(0, curr)] = c[hook(2, curr2)];
    if (com) {
      b[hook(1, curr)] = d[hook(3, curr2)];
    }
  } else {
    a[hook(0, curr)] = alpha;
    if (com) {
      b[hook(1, curr)] = beta;
    }
  }
}