//{"input":0,"n":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findMax(global float* input, constant size_t* n, global float* output) {
 private
  size_t elementsPerWorkItem = *n / get_global_size(0);
 private
  size_t threadIndex = get_global_id(0);
 private
  size_t inputIndex = elementsPerWorkItem * threadIndex;
 private
  size_t offset = elementsPerWorkItem;

 private
  float maxValue = -0x1.fffffep127f;

  for (size_t i = 0; i < elementsPerWorkItem; i++)
    maxValue = max(maxValue, input[hook(0, inputIndex + i)]);

  input[hook(0, inputIndex)] = maxValue;

  barrier(0x02);

  for (size_t i = 2; i < elementsPerWorkItem + 1; i <<= 1) {
    if (threadIndex % i == 0) {
      if (maxValue < input[hook(0, inputIndex + offset)]) {
        maxValue = input[hook(0, inputIndex + offset)];
        input[hook(0, inputIndex)] = maxValue;
      }

      offset <<= 1;
    }

    barrier(0x02);
  }

  if (get_local_id(0) == 0)
    output[hook(2, get_group_id(0))] = maxValue;
}