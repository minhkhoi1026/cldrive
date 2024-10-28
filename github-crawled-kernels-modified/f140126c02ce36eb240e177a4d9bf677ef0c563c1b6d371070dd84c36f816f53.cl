//{"array":0,"triple":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_incorrectly_indexed_value(const int triple[6], int index);
void set_incorrectly_indexed_value(global int* array, int index, int value);
int get_incorrectly_indexed_value(const int triple[6], int index) {
  const int sum1 = triple[hook(1, 0)] + triple[hook(1, 1)] + triple[hook(1, 2)];
  const int sum2 = triple[hook(1, 3)] + triple[hook(1, 4)] + triple[hook(1, 5)];

  const int sum3 = triple[hook(1, -1)] + triple[hook(1, -2)] + triple[hook(1, -3)];

  const int sum4 = triple[hook(1, 6)] + triple[hook(1, 7)] + triple[hook(1, 8)];
  return sum1 + sum2

         + sum3

         + sum4;
}

void set_incorrectly_indexed_value(global int* array, int index, int value) {
  int triple[3] = {0, 1, 2};

  triple[hook(1, 0)] = triple[hook(1, -1)] + triple[hook(1, -2)] + triple[hook(1, -3)];

  triple[hook(1, 1)] = triple[hook(1, 4294967296L)] + triple[hook(1, 9223372036854775808LL)];

  triple[hook(1, 2)] = triple[hook(1, 3)] + triple[hook(1, 4)] + triple[hook(1, 5)];

  array[hook(0, index)] = value + triple[hook(1, 0)] + triple[hook(1, 1)] + triple[hook(1, 2)];
}

kernel void access_invalid_array(global int* array) {
  const int i = get_global_id(0);

  const int triple[3] = {0, 1, 2};
  const int value = get_incorrectly_indexed_value(triple, i);
  set_incorrectly_indexed_value(array, i, value);
}