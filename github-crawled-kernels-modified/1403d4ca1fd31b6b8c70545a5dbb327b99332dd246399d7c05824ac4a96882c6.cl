//{"array":0,"pair":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_array_index(global int* array) {
  const int i = get_global_id(0);

  int pair[2] = {0, 0};

  pair[hook(1, i + 0)] = 0;

  hook(1, (i + 1))] = 1;

  array[hook(0, i)] = pair[hook(1, i + 0)]

             + hook(1, (i + 1))]

      ;
}