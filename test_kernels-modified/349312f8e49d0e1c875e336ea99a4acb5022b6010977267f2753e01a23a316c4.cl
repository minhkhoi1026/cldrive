//{"randNumArray":0,"sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(global float* randNumArray, global int* sum) {
  int gid = get_global_id(0);
  int baseIndex = gid * 2;
  float x = (randNumArray[hook(0, baseIndex)] * 2.0f) - 1.0f;
  float y = (randNumArray[hook(0, (baseIndex + 1))] * 2.0f) - 1.0f;
  sum[hook(1, gid)] = (((x * x) + (y * y)) < 1.0f) ? 1 : 0;
  return;
}