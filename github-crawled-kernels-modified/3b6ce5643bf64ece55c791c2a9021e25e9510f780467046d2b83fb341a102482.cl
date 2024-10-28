//{"globalData":2,"index":0,"localData":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int globalData[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

kernel void test_global_data(const int index, global int* out) {
  const int localData[] = {11, 21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 131, 141, 151, 161, 171, 181, 191, 201};

  out[hook(1, 0)] = globalData[hook(2, index)];
  out[hook(1, 1)] = localData[hook(3, index)];
}