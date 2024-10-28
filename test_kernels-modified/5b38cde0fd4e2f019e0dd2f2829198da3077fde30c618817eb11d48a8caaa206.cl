//{"size":1,"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void incTask(global int* vector, int size) {
  for (int i = 0; i < size; i++)
    vector[hook(0, i)] = vector[hook(0, i)] + 1;
}