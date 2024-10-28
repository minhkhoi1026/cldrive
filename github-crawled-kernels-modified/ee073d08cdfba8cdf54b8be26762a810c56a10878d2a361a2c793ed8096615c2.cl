//{"array":0,"num_elements":1,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_array_to_constant(global int* array, int num_elements, int val) {
  if (get_global_id(0) < num_elements)
    array[hook(0, get_global_id(0))] = val;
}