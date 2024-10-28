//{"data":0,"output":1,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kraljice_brojac1(global float* data, global float* output) {
  int brPolja = 4;
  int n = 4;
  int k, ind;
  int x[4];

  int resenje;
  float sum = 0.0;

  x[hook(2, 1)] = 0;
  k = 1;
  while (k > 0) {
    x[hook(2, k)]++;
    if (x[hook(2, k)] <= n) {
      if (k == n) {
        resenje = 0;
        for (ind = 1; ind <= brPolja; ind++) {
          sum += (float)x[hook(2, ind)];
        }

      } else {
        k++;
        x[hook(2, k)] = 0;
      }
    } else {
      k--;
    }
  }

  *output = sum;
}