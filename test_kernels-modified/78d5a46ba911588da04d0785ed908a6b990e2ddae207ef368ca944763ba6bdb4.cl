//{"batchsize":0,"dim":1,"grad":4,"p":2,"t":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_softmaxentropy(const unsigned int batchsize, const unsigned int dim, global const float* p, global const int* t, global float* grad) {
  const unsigned int gidx = get_global_id(0);
  if (gidx >= batchsize)
    return;

  int truth_idx = t[hook(3, gidx)];
  if (truth_idx <= 0)
    return;
  grad[hook(4, gidx * dim + truth_idx)] -= 1.0;
}