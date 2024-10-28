//{"errors":0,"finalErrors":1,"samples":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate_final_error(constant float* errors, global float* finalErrors, const unsigned int samples) {
  const unsigned int personId = get_global_id(0);
  const unsigned int lastId = (personId + 1) * samples;

  float err = 0;

  for (unsigned int id = lastId - samples; id < lastId; ++id) {
    err += errors[hook(0, id)];
  }

  finalErrors[hook(1, personId)] = err / samples;
  return;
}