//{"dest":0,"elems":2,"result_tmp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_squarenorm_reduction(global float* dest, global float* result_tmp, const unsigned int elems) {
  unsigned int id = get_global_id(0);
  float tmp = 0;
  if (id == 0) {
    for (unsigned int i = 0; i < elems; i++) {
      tmp += result_tmp[hook(1, i)];
    }
    *dest = tmp;
  }
}