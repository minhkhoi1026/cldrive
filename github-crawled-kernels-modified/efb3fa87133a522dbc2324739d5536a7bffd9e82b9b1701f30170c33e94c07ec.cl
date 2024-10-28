//{"a":0,"a_cols":6,"a_off0":2,"a_off1":3,"b":1,"b_cols":7,"b_off0":4,"b_off1":5,"half_sum":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong index2(ulong cols, ulong row, ulong col) {
  return row * cols + col;
}

ulong dot_ulong4(ulong4 a, ulong4 b) {
  ulong4 prod = a * b;
  ulong2 half_sum = prod.xy + prod.zw;
  return half_sum[hook(8, 0)] + half_sum[hook(8, 1)];
}

ulong index4(ulong4 dim_steps, ulong4 coords) {
  return dot_ulong4(dim_steps, coords);
}

kernel void array_dtanh_slice_f32(global float* a, global float* b, ulong a_off0, ulong a_off1, ulong b_off0, ulong b_off1, ulong a_cols, ulong b_cols) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  ulong ai = index2(a_cols, i + a_off0, j + a_off1);
  ulong bi = index2(b_cols, i + b_off0, j + b_off1);

  b[hook(1, bi)] = tanh(a[hook(0, ai)]);
  b[hook(1, bi)] = 1.0 - b[hook(1, bi)] * b[hook(1, bi)];
}