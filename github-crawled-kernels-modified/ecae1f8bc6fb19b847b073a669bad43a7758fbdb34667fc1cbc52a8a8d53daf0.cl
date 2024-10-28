//{"a":0,"a_dim_steps":2,"a_off":3,"b":1,"b_dim_steps":4,"b_off":5,"half_sum":6}
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
  return half_sum[hook(6, 0)] + half_sum[hook(6, 1)];
}

ulong index4(ulong4 dim_steps, ulong4 coords) {
  return dot_ulong4(dim_steps, coords);
}

kernel void array_copy_to_slice_f32(global float* a, global float* b, ulong4 a_dim_steps, ulong4 a_off, ulong4 b_dim_steps, ulong4 b_off) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  ulong k = get_global_id(2);

  a_off[hook(3, 1)] += i;
  a_off[hook(3, 2)] += j;
  a_off[hook(3, 3)] += k;

  b_off[hook(5, 1)] += i;
  b_off[hook(5, 2)] += j;
  b_off[hook(5, 3)] += k;

  ulong ai = index4(a_dim_steps, a_off);
  ulong bi = index4(b_dim_steps, b_off);

  b[hook(1, bi)] = a[hook(0, ai)];
}