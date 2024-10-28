//{"constant_array":2,"global_array":0,"local_array":1,"private_array":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int no_parameters(void);
int value_parameters(int index);
int unused_parameters(global int* global_array, local int* local_array, constant int* constant_array, private int* private_array);
int used_parameters(global int* global_array, local int* local_array, constant int* constant_array, private int* private_array);
int no_parameters(void) {
  return 0;
}

int value_parameters(

    int index) {
  return index + 1;
}

int unused_parameters(

    global int* global_array, local int* local_array,

    constant int* constant_array, private int* private_array) {
  return 0;
}

int used_parameters(

    global int* global_array, local int* local_array,

    constant int* constant_array, private int* private_array) {
  const int index = value_parameters(no_parameters());
  return global_array[hook(0, index)] + local_array[hook(1, index)] + constant_array[hook(2, index)] + private_array[hook(3, index)];
}

kernel void insert_parameters(global int* global_array, local int* local_array, constant int* constant_array) {
  const int i = get_global_id(0);

  int private_array[2] = {0};

  global_array[hook(0, i + 0)] = unused_parameters(global_array, local_array, constant_array, private_array);
  global_array[hook(0, i + 1)] = used_parameters(global_array, local_array, constant_array, private_array);
}