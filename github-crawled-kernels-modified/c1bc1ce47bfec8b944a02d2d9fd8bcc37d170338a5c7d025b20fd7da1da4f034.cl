//{"B1":4,"B2":5,"N":0,"eps":7,"m":2,"rate":6,"t":8,"v":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adam_kernel(int N, global float* x, global float* m, global float* v, float B1, float B2, float rate, float eps, int t) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= N)
    return;
  float mhat = m[hook(2, index)] / (1.0 - pow(B1, t));
  float vhat = v[hook(3, index)] / (1.0 - pow(B2, t));
  x[hook(1, index)] = x[hook(1, index)] + rate * mhat / (sqrt(vhat) + eps);
}