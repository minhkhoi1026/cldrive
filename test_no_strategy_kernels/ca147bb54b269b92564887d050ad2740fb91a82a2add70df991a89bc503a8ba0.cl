//{"a":3,"du1":5,"du2":6,"du3":7,"sig":4,"u1":0,"u2":1,"u3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_int(global float* restrict u1, global float* restrict u2, global float* restrict u3, global int* restrict a, float sig) {
  float du1[100 + 1], du2[100 + 1], du3[100 + 1];
  int l, ky, kx, nl1, nl2;

  for (l = 1; l <= 100; l++) {
    nl1 = 0;
    nl2 = 1;
    for (kx = 1; kx < 3; kx++) {
      for (ky = 1; ky < 100; ky++) {
        du1[hook(5, ky)] = u1[hook(0, nl1 * 100 * 3 + (ky + 1) * (3 + 1) + kx)] - u1[hook(0, nl1 * 100 * 3 + (ky - 1) * (3 + 1) + kx)];
        du2[hook(6, ky)] = u2[hook(1, nl1 * 100 * 3 + (ky + 1) * (3 + 1) + kx)] - u2[hook(1, nl1 * 100 * 3 + (ky - 1) * (3 + 1) + kx)];
        du3[hook(7, ky)] = u3[hook(2, nl1 * 100 * 3 + (ky + 1) * (3 + 1) + kx)] - u3[hook(2, nl1 * 100 * 3 + (ky - 1) * (3 + 1) + kx)];

        u1[hook(0, nl2 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] = u1[hook(0, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + a[hook(3, 0)] * du1[hook(5, ky)] + a[hook(3, 1)] * du2[hook(6, ky)] + a[hook(3, 2)] * du3[hook(7, ky)] + sig * (u1[hook(0, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx + 1))] - 2.0 * u1[hook(0, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + u1[hook(0, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx - 1))]);

        u2[hook(1, nl2 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] = u2[hook(1, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + a[hook(3, 3)] * du1[hook(5, ky)] + a[hook(3, 4)] * du2[hook(6, ky)] + a[hook(3, 5)] * du3[hook(7, ky)] + sig * (u2[hook(1, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx + 1))] - 2.0 * u2[hook(1, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + u2[hook(1, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx - 1))]);

        u3[hook(2, nl2 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] = u3[hook(2, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + a[hook(3, 6)] * du1[hook(5, ky)] + a[hook(3, 7)] * du2[hook(6, ky)] + a[hook(3, 8)] * du3[hook(7, ky)] + sig * (u3[hook(2, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx + 1))] - 2.0 * u3[hook(2, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + kx)] + u3[hook(2, nl1 * (100 + 1) * (3 + 1) + ky * (3 + 1) + (kx - 1))]);
      }
    }
  }
}