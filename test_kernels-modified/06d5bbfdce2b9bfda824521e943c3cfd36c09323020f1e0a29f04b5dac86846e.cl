//{"indexes":1,"length":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initIndexes(constant size_t* length, global size_t* indexes) {
  if (get_global_id(0) + 1 > *length)
    return;

 private
  size_t elementsPerWorkItem = max((int)(*length / get_global_size(0)), 1);
 private
  size_t inputThreadIndex = get_global_id(0) * elementsPerWorkItem;

  for (size_t i = 0; i < elementsPerWorkItem; i++)
    indexes[hook(1, inputThreadIndex + i)] = inputThreadIndex + i;
}