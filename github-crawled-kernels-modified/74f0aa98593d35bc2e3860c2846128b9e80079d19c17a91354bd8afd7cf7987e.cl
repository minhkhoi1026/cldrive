//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_unstructured_branch2(global int* src, global int* dst) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = src[hook(0, id)];
  if (dst[hook(1, id)] < 0)
    goto label1;
  dst[hook(1, id)] = 1;
  if (dst[hook(1, id)] > src[hook(0, id)])
    goto label3;
  dst[hook(1, id)]++;
  if (src[hook(0, id)] <= 2)
    goto label2;
label1:
  dst[hook(1, id)] -= 2;
label2:
  dst[hook(1, id)] += 2;
label3:
  dst[hook(1, id)] *= 3;
}