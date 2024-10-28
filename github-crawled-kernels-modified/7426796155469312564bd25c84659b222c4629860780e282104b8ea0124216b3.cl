//{"s1":0,"s2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap(global float* s1, global float* s2) {
  float tmp = *s2;
  *s2 = *s1;
  *s1 = tmp;
}