//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void DSPF_sp_fftSPxSP(int N, float* x, global float* w, float* y, unsigned char* brev, int n_min, int offset, int n_max);
kernel void null(void) {
}