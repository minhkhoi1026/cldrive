//{"B":4,"NX":0,"NY":2,"OUT_":5,"X":1,"Y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void deinter_kernel(int NX, global float* X, int NY, global float* Y, int B, global float* OUT_) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < (NX + NY) * B) {
    int b = i / (NX + NY);
    int j = i % (NX + NY);
    if (j < NX) {
      if (X)
        X[hook(1, b * NX + j)] += OUT_[hook(5, i)];
    } else {
      if (Y)
        Y[hook(3, b * NY + j - NX)] += OUT_[hook(5, i)];
    }
  }
}