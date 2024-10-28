//{"elems":2,"num_fields":3,"out":0,"result_tmp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sax_vectorized_and_squarenorm_reduction(global float* out, global float* result_tmp, const unsigned int elems, const unsigned int num_fields) {
  const unsigned int id = get_global_id(0);
  for (unsigned int i = 0; i < num_fields; i++)
    out[hook(0, i)] = 0.0;

  if (id == 0) {
    for (unsigned int s = 0; s < elems; s++) {
      out[hook(0, s - (s / num_fields) * num_fields)] += result_tmp[hook(1, s)];
    }
  }
}