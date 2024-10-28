//{"array":0,"triple":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_indexed_value(global int* array, int index);
void set_indexed_value(global int* array, int index, int value);
int get_indexed_value(global int* array, int index) {
  const int triple[3] = {0, 1, 2};

  const int sum1 = array[hook(0, index)] + array[hook(0, 0)] + triple[hook(1, index)];

  const int sum2 = triple[hook(1, 0)] + triple[hook(1, 1)] + triple[hook(1, 2)];

  const int sum3 = hook(0, index)] + hook(0, 0)] + hook(1, index)];

  const int sum4 = hook(1, 0)] + hook(1, 1)] + hook(1, 2)];

  return sum1 + sum2

         + sum3 + sum4

      ;
}

void set_indexed_value(

    global int* array, int index, int value) {
  array[hook(0, index)] += value;

  hook(0, index)] += value;
}

kernel void access_array(

    global int* array) {
  const int i = get_global_id(0);

  const int indexed_value = get_indexed_value(array, i);

  set_indexed_value(array, i, -indexed_value);
}