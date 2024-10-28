//{"sampler1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampler_type_errors4(sampler_t sampler1) {
  sampler_t sampler2;
}