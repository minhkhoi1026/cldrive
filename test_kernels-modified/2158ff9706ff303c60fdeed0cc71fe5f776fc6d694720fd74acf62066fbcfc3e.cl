//{"buffer":0,"nBufferElements":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void WipeBufferFloatKernel(global float* buffer, const int nBufferElements) {
  const unsigned int i = get_global_id(0);

  if (i < nBufferElements) {
    buffer[hook(0, i)] = 0.0f;
  }
}