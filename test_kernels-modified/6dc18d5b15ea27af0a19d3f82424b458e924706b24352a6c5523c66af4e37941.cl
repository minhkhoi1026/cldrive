//{"input":0,"n":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort(global volatile float* input, constant size_t* n, global volatile float* output) {
 private
  size_t groupId = get_group_id(0);

  output[hook(2, 0)] = get_group_id(0);
  output[hook(2, 1)] = get_num_groups(0);

  if (groupId & 1)
    return;

 private
  size_t elementsPerGroup = *n / get_num_groups(0);
 private
  size_t elementsPerWorkItem = elementsPerGroup / get_local_size(0);
 private
  size_t inputThreadIndex = get_global_id(0) * elementsPerWorkItem;
 private
  size_t nextIndexGroup = (groupId + 2) * elementsPerGroup + (groupId * elementsPerGroup);
 private
  size_t maxInputThreadIndex = inputThreadIndex + elementsPerWorkItem;

 private
  float temp;
 private
  size_t first;
 private
  size_t last;

  for (size_t first = inputThreadIndex; first < maxInputThreadIndex; ++first) {
    last = nextIndexGroup - first - 1;

    if (input[hook(0, first)] > input[hook(0, last)]) {
      temp = input[hook(0, first)];
      input[hook(0, first)] = input[hook(0, last)];
      input[hook(0, last)] = temp;
    }
  }
}