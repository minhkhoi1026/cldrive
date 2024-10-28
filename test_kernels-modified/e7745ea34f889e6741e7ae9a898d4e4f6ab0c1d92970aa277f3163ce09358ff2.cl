//{"A":0,"buf":2,"last_n":5,"m":3,"n":4,"stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_qr_column(global float* A, unsigned int stride, global float* buf, int m, int n, int last_n) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  for (int i = glb_id; i < last_n; i += glb_sz) {
    float a_ik = A[hook(0, m * stride + i)], a_ik_1, a_ik_2;

    a_ik_1 = A[hook(0, (m + 1) * stride + i)];

    for (int k = m; k < n; k++) {
      bool notlast = (k != n - 1);

      float p = buf[hook(2, 5 * k)] * a_ik + buf[hook(2, 5 * k + 1)] * a_ik_1;

      if (notlast) {
        a_ik_2 = A[hook(0, (k + 2) * stride + i)];
        p = p + buf[hook(2, 5 * k + 2)] * a_ik_2;
        a_ik_2 = a_ik_2 - p * buf[hook(2, 5 * k + 4)];
      }

      A[hook(0, k * stride + i)] = a_ik - p;
      a_ik_1 = a_ik_1 - p * buf[hook(2, 5 * k + 3)];

      a_ik = a_ik_1;
      a_ik_1 = a_ik_2;
    }

    A[hook(0, n * stride + i)] = a_ik;
  }
}