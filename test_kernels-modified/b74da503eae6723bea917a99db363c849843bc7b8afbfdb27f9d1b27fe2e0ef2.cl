//{"deltaXbatch":0,"deltaYbatch":1,"inputBatch":2,"nTotActivations":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ReLUBackward(global float* deltaXbatch, global float* deltaYbatch, global float* inputBatch, const int nTotActivations) {
  int i = get_global_id(0);

  if (i < nTotActivations) {
    if (inputBatch[hook(2, i)] < 0)
      deltaXbatch[hook(0, i)] = 0.0;
    else
      deltaXbatch[hook(0, i)] = deltaYbatch[hook(1, i)];
  }
}