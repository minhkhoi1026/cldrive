//{"edgewidth":8,"height":3,"in":0,"numberPoints":6,"out":1,"positions":4,"sumOfWeights":7,"weights":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dynamicStencil1(global float* in, global float* out, int width, int height, global int* positions, global float* weights, int numberPoints, float sumOfWeights, int edgewidth) {
  int pos = get_global_id(0) + edgewidth + (get_global_id(1) + edgewidth) * width;

  float sum = 0;
  int lookAt = 0;

  for (int i = 0; i < numberPoints * 2; i = i + 2) {
    lookAt = pos + positions[hook(4, i)] + positions[hook(4, i + 1)] * width;
    sum += in[hook(0, lookAt)] * weights[hook(5, i / 2)];
  }
  out[hook(1, pos)] = sum / sumOfWeights;
}