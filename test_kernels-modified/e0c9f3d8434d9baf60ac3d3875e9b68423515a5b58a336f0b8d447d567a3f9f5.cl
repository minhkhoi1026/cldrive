//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_pointed_value(global int* pointer, const constant char* dummy);
int get_pointed_value(global int* pointer, const constant char* dummy) {
  return *pointer;
}

kernel void find_works_fine(global int* array) {
  int i = get_global_id(0);
  int pointed_value = get_pointed_value(array + i, (const constant char*)"dont;match;here")

      ;

  int* iptr = &i;

  const constant char* test = 0 + (const constant char*)"dont;match;here";
  iptr = &pointed_value;
  array[hook(0, i)] = *iptr;
}