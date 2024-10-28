//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_pointed_value(global int* pointer);
void set_pointed_value(global int* pointer, int value);
int get_pointed_value(global int* pointer) {
  return *pointer;
}

void set_pointed_value(

    global int* pointer, int value) {
  *pointer = value;
}

kernel void access_pointer(

    global int* array) {
  const int i = get_global_id(0);

  const int pointed_value = get_pointed_value(array + i);

  set_pointed_value(array + i, -pointed_value);
}