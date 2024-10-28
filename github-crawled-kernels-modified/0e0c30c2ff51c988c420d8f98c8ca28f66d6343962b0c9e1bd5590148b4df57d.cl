//{"a":5,"b":7,"c":6,"d":8,"edge_nb_max_ptr":2,"edge_nb_ptr":3,"from_ptr":0,"size":4,"to_ptr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float concat1Jaccard(global unsigned int* a, global unsigned int* b, global unsigned int* c, global unsigned int* d) {
  float jacc = 0.0;

  int A_union_C = 0;
  int B_union_D = 0;
  int A_and_not_C = 0;
  int D_and_not_B = 0;
  int C_and_not_A = 0;
  int B_and_not_D = 0;

  int A_intersect_C = 0;
  int B_intersect_D = 0;

  for (int i = 0; i < 8; i++) {
    A_union_C += popcount(a[hook(5, i)] | c[hook(6, i)]);

    B_union_D += popcount(b[hook(7, i)] | d[hook(8, i)]);

    A_and_not_C += popcount(a[hook(5, i)] & (~c[hook(6, i)]));

    D_and_not_B += popcount(d[hook(8, i)] & (~b[hook(7, i)]));

    C_and_not_A += popcount(c[hook(6, i)] & (~a[hook(5, i)]));
    B_and_not_D += popcount(b[hook(7, i)] & (~d[hook(8, i)]));

    A_intersect_C += popcount(a[hook(5, i)] & c[hook(6, i)]);
    B_intersect_D += popcount(b[hook(7, i)] & d[hook(8, i)]);
  }

  int unionBits = (A_union_C * B_union_D) - (A_and_not_C * D_and_not_B) - (C_and_not_A * B_and_not_D);
  int intersectBits = A_intersect_C * B_intersect_D;
  jacc = (float)intersectBits / (float)unionBits;

  return jacc;
}

kernel void detect_1edges(global unsigned int* from_ptr, global unsigned int* to_ptr, global unsigned int* edge_nb_max_ptr, global unsigned int* edge_nb_ptr, int size) {
  int gid_u = get_global_id(0);
  int gid_v = get_global_id(1);

  if (gid_u >= size || gid_v >= size || gid_u >= gid_v) {
    return;
  }

  (void)atomic_inc(&edge_nb_max_ptr[hook(2, 0)]);

  global unsigned int* a_ptr = from_ptr + (gid_u * 8);
  global unsigned int* b_ptr = to_ptr + (gid_u * 8);
  global unsigned int* c_ptr = from_ptr + (gid_v * 8);
  global unsigned int* d_ptr = to_ptr + (gid_v * 8);

  float jacc_direct = concat1Jaccard(a_ptr, b_ptr, c_ptr, d_ptr);
  float jacc_inverse = concat1Jaccard(a_ptr, b_ptr, d_ptr, c_ptr);

  if (jacc_direct > 0.75 || jacc_inverse > 0.75) {
    (void)atomic_inc(&edge_nb_ptr[hook(3, 0)]);
  }
}