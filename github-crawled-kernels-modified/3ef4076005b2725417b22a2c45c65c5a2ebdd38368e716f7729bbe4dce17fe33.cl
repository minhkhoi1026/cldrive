//{"consumers":2,"fitness":3,"int2":5,"pos":0,"pos1":4,"pos_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float distanceBetweenPositions(global float* pos1, global float* int2) {
  return sqrt(pow(pos1[hook(4, 0)] - int2[hook(5, 0)], 2) + pow(pos1[hook(4, 1)] - int2[hook(5, 1)], 2));
}

kernel void calc_fitness(global float* pos, unsigned int pos_size, global float* consumers, global float* fitness) {
  if (get_global_id(0) == 0) {
    *fitness = 0;
    for (unsigned int p = 0; p < pos_size; p += 2) {
      *fitness -= distanceBetweenPositions(pos + p, consumers + p * 2);
      *fitness -= distanceBetweenPositions(pos + p, consumers + (p + 1) * 2);
      if (p < pos_size - 2)
        *fitness -= distanceBetweenPositions(pos + p, pos + p + 2);
    }
  }
}