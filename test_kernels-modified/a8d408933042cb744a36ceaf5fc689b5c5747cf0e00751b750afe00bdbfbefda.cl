//{"input":1,"keys":0,"numKeys":2,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarySearch_mulkeys(global int* keys, global unsigned int* input, const unsigned int numKeys, global int* output) {
  int gid = get_global_id(0);
  int lBound = gid * 256;
  int uBound = lBound + 255;

  for (int i = 0; i < numKeys; i++) {
    if (keys[hook(0, i)] >= input[hook(1, lBound)] && keys[hook(0, i)] <= input[hook(1, uBound)])
      output[hook(3, i)] = lBound;
  }
}