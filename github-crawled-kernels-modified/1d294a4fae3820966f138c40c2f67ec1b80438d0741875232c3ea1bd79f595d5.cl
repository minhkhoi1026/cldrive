//{"smp_par":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t glb_smp = 2 | 1 | 0x20;
void fnc4smp(sampler_t s) {
}

kernel void foo(sampler_t smp_par) {
  sampler_t smp = 2 | 1 | 0x10;

  fnc4smp(smp);

  fnc4smp(smp);

  fnc4smp(glb_smp);

  fnc4smp(smp_par);
}