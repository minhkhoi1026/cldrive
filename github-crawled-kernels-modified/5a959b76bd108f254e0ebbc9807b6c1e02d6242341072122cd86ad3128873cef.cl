//{"alpha":3,"deltaXbatch":0,"deltaYbatch":1,"inputBatch":2,"nTotActivations":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ELUBackward(global float* deltaXbatch, global float* deltaYbatch, global float* inputBatch, const float alpha, const int nTotActivations) {
  int i = get_global_id(0);

  if (i < nTotActivations) {
    if (inputBatch[hook(2, i)] < 0.0F) {
      float derivative = alpha * exp(inputBatch[hook(2, i)]);
      deltaXbatch[hook(0, i)] = derivative * deltaYbatch[hook(1, i)];
    } else
      deltaXbatch[hook(0, i)] = deltaYbatch[hook(1, i)];
  }
}