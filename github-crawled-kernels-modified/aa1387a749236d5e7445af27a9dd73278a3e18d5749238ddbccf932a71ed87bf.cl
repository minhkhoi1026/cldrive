//{"N":4,"albedo_clean":3,"albedobsa":1,"albedoqa":2,"albedowsa":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clean_mcd43b3_qa(global const float* albedowsa, global const float* albedobsa, global const float* albedoqa, global float* albedo_clean, global const int* N) {
  int i = get_global_id(0);
  if (i < N)
    albedo_clean[hook(3, i)] = (albedowsa[hook(0, i)] * 0.25 + (1 - 0.25) * albedobsa[hook(1, i)]) * 0.1;
  if (albedoqa[hook(2, i)] > 1)
    albedo_clean[hook(3, i)] = -28768;
}