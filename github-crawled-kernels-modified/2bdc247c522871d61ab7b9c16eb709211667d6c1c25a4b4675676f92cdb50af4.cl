//{"a":0,"a_dim_steps":3,"a_off":4,"b":1,"b_dim_steps":5,"b_off":6,"c":2,"c_dim_steps":7,"c_off":8,"half_sum":9}
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
  return half_sum[hook(9, 0)] + half_sum[hook(9, 1)];
}

ulong index4(ulong4 dim_steps, ulong4 coords) {
  return dot_ulong4(dim_steps, coords);
}

kernel void array_multiply_slice_i32(global int* a, global int* b, global int* c, ulong4 a_dim_steps, ulong4 a_off, ulong4 b_dim_steps, ulong4 b_off, ulong4 c_dim_steps, ulong4 c_off) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  ulong k = get_global_id(2);

  a_off[hook(4, 1)] += i;
  a_off[hook(4, 2)] += j;
  a_off[hook(4, 3)] += k;

  b_off[hook(6, 1)] += i;
  b_off[hook(6, 2)] += j;
  b_off[hook(6, 3)] += k;

  c_off[hook(8, 1)] += i;
  c_off[hook(8, 2)] += j;
  c_off[hook(8, 3)] += k;

  ulong ai = index4(a_dim_steps, a_off);
  ulong bi = index4(b_dim_steps, b_off);
  ulong ci = index4(c_dim_steps, c_off);

  c[hook(2, ci)] = a[hook(0, ai)] * b[hook(1, bi)];
}