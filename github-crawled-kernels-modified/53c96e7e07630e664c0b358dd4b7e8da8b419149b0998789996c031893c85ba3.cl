//{"b":4,"k":2,"nk":3,"nx":1,"x":0,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void DSPF_sp_fftSPxSP(int N, global float* x, global float* w, global float* y, unsigned char* brev, int n_min, int offset, int n_max);
void DSPF_sp_fftSPxSP_r2c(int N, global float* x, global float* w, global float* y, unsigned char* brev, int n_min, int offset, int n_max);
void DSPF_sp_ifftSPxSP(int N, global float* x, global float* w, global float* y, unsigned char* brev, int n_min, int offset, int n_max);
void DSPF_sp_biquad(global float* restrict x, global float* b, global float* a, global float* delay, global float* restrict y, const int nx);
void DSPF_sp_fircirc(global const float* x, global float* h, global float* restrict y, int index, int csize, int nh, int ny);
void DSPF_sp_fir_cplx(global const float* x, global const float* h, global float* restrict y, int nh, int nr);
void DSPF_sp_fir_gen(global const float* restrict x, global const float* restrict h, global float* restrict r, int nh, int nr);
void DSPF_sp_fir_r2(global const float* x, global const float* h, global float* restrict r, const int nh, const int nr);
void DSPF_sp_iir(global float* restrict y1, global const float* x, global float* restrict y2, global const float* hb, global const float* ha, int nr);
void DSPF_sp_iirlat(global const float* x, int nx, global const float* restrict k, int nk, global float* restrict b, global float* restrict y);
kernel void ocl_DSPF_sp_iirlat(global const float* x, int nx, global const float* restrict k, int nk, global float* restrict b, global float* restrict y) {
  DSPF_sp_iirlat(x, nx, k, nk, b, y);
}