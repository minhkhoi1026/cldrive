//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_vector_inc(global char* dst, global char* src) {
  size_t i = get_global_id(0);
  char2 dst2 = vload2(i, dst);
  if (src[hook(1, i)] == 0)
    dst2++;
  else if (src[hook(1, i)] == 1)
    ++dst2;
  else if (src[hook(1, i)] == 2)
    dst2--;
  else
    --dst2;
  vstore2(dst2, i, dst);
}