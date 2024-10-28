//{"layerSize":0,"n":6,"out":5,"outputs":3,"patTypes":1,"shared":4,"targets":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_weightedSSeFn(int layerSize, global char* patTypes, global float* targets, global float* outputs, local float* shared, global float* out, int n) {
  int index = get_local_id(0);
  shared[hook(4, get_local_id(0))] = 0;
  barrier(0x01);
  while (index < n) {
    int patIdx = index / layerSize;
    if (patTypes[hook(1, patIdx)] != 0) {
      float target = targets[hook(2, index * 2)];
      float output = outputs[hook(3, index)];
      float weight = targets[hook(2, index * 2 + 1)];

      float diff = (output - target) * weight;
      shared[hook(4, get_local_id(0))] += (diff * diff);
    }
    index += get_local_size(0);
  }
  index = get_local_id(0);

  barrier(0x01);
  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (index < s) {
      shared[hook(4, index)] += shared[hook(4, index + s)];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0) {
    out[hook(5, 0)] = shared[hook(4, 0)];
  }
}