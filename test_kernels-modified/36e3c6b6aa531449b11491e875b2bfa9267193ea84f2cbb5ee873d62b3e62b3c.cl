//{"errorVector":0,"last_boolean_output":1,"output":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_error_vector(global float* errorVector, global const char* last_boolean_output, global const float* output, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    errorVector[hook(0, i)] = last_boolean_output[hook(1, i)] - output[hook(2, i)];
  }
}