//{"result":2,"size":3,"vander":0,"vector":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vandermonde_prod(global float* vander, global float* vector, global float* result, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    float mul = vander[hook(0, i)];
    float pwr = 1;
    float val = 0;

    for (unsigned int j = 0; j < size; j++) {
      val = val + pwr * vector[hook(1, j)];
      pwr *= mul;
    }

    result[hook(2, i)] = val;
  }
}