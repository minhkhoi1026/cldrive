//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t glb_smp = 2 | 1 | 0x10;
void fnc1(image1d_t img) {
}

void fnc1arr(image1d_array_t img) {
}

void fnc1buff(image1d_buffer_t img) {
}

void fnc2(image2d_t img) {
}

void fnc2arr(image2d_array_t img) {
}

void fnc3(image3d_t img) {
}

void fnc4smp(sampler_t s) {
}

kernel void foo_wo_pipe(write_only pipe int p) {
}