//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float array[2] = {0.0f, 1.0f};

void foo(constant const int* p1, const int* p2, const int* p3);

kernel void k(void) {
  constant const int arr1[] = {1, 2, 3};

  const int arr2[] = {4, 5, 6};

  int arr3[] = {7, 8, 9};

  foo(arr1, arr2, arr3);
}