//{"data":0,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ComputeBound(global float* data, unsigned int iter) {
  float frac;
  float sign = 1.0f;
  float odd = 1.0f;
  float sum = 0.0f;
  float res = 0.0f;

  while (iter--) {
    frac = sign / odd;
    sum += frac;
    res = 4.0f * sum;
    sign *= -1.0f;
    odd += 2.0f;
  }

  data[hook(0, get_global_id(0))] = res;
}