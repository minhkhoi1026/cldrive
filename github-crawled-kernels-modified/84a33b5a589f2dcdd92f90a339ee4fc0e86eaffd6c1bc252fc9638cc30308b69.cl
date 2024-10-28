//{"error":2,"outputs":0,"results":1,"samples":4,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate_error(constant float* outputs, constant float* results, global float* error, const unsigned int size, const unsigned int samples) {
  float err = 0;

  const unsigned int personId = get_global_id(0);
  const unsigned int sampleId = get_global_id(1);

  const unsigned int lastId = (personId * samples + sampleId + 1) * size;

  for (unsigned int id = lastId - size, resultId = sampleId * size; id < lastId; ++id, ++resultId) {
    float diff = outputs[hook(0, id)] - results[hook(1, resultId)];
    err += diff * diff;
  }

  error[hook(2, personId * samples + sampleId)] = err / size;
  return;
}