//{"input":0,"localStorage":2,"outMaxes":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global unsigned int* input, global unsigned int* outMaxes) {
  local unsigned int localStorage[256];
  unsigned int theValue = input[hook(0, get_global_id(0))];

  localStorage[hook(2, get_local_size(0) - get_local_id(0) - 1)] = theValue;

  barrier(0x01);

  unsigned int max = 0;
  if (get_local_id(0) == 0) {
    for (size_t i = 0; i < get_local_size(0); i++) {
      if (localStorage[hook(2, i)] > max)
        max = localStorage[hook(2, i)];
    }
    outMaxes[hook(1, get_group_id(0))] = max;
  }
}