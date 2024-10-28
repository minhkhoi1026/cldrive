//{"len":0,"x":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void helloworld(global int* len, global int* x, global int* z) {
  int local_len = *len;
  x[hook(1, 1)] = z[hook(2, 1)] = 2;

  int a = 1;
  int b = 3;
  int d, j, c, run;

  while (1) {
    d = 0;
    for (j = local_len - 1; j > 0; j--) {
      c = z[hook(2, j)] * a + d;
      z[hook(2, j)] = c % 10;
      d = c / 10;
    }
    d = 0;
    for (j = 0; j < local_len; j++) {
      c = z[hook(2, j)] + d * 10;
      z[hook(2, j)] = c / b;
      d = c % b;
    }
    run = 0;
    for (j = local_len - 1; j > 0; j--) {
      c = x[hook(1, j)] + z[hook(2, j)];
      x[hook(1, j)] = c % 10;
      x[hook(1, j - 1)] += c / 10;
      run |= z[hook(2, j)];
    }
    if (!run)
      break;
    a += 1;
    b += 2;
  }

  return;
}