//{"mutationStrength":0,"mutationStrengthChangeSpeed":4,"mutationStrengthMax":5,"mutationStrengthMin":6,"mutationStrength_inc":2,"mutationStrength_size":3,"mutationStrength_start":1,"randNumbers":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mutateMutationStrength(global float* mutationStrength, unsigned int mutationStrength_start, unsigned int mutationStrength_inc, unsigned int mutationStrength_size, float mutationStrengthChangeSpeed, float mutationStrengthMax, float mutationStrengthMin, global float* randNumbers) {
  for (unsigned int i = get_global_id(0); i < mutationStrength_size; i += get_global_size(0)) {
    mutationStrength[hook(0, i * mutationStrength_inc + mutationStrength_start)] *= exp(mutationStrengthChangeSpeed * randNumbers[hook(7, i)]);
    mutationStrength[hook(0, i * mutationStrength_inc + mutationStrength_start)] = (mutationStrength[hook(0, i * mutationStrength_inc + mutationStrength_start)] < 0 ? -1 : 1) * min(mutationStrengthMax, max(mutationStrengthMin, fabs(mutationStrength[hook(0, i * mutationStrength_inc + mutationStrength_start)])));
  }
}