//{"layerSize":0,"outputError":4,"outputs":3,"patTypes":1,"targets":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_OutputErrorFn(int layerSize, global char* patTypes, global float* targets, global float* outputs, global float* outputError) {
  int index = get_global_id(0);
  float target = targets[hook(2, index * 2)];
  float output = outputs[hook(3, index)];
  float weight = targets[hook(2, index * 2 + 1)];

  int patIdx = index / layerSize;

  if (patTypes[hook(1, patIdx)] == 0)
    outputError[hook(4, index)] = 0;
  else
    outputError[hook(4, index)] = (output - target) * weight;
}