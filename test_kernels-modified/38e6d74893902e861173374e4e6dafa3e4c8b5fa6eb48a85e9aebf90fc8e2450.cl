//{"A":0,"A_col_size":2,"alpha":6,"beta":7,"offA":1,"offr":9,"offv":5,"result":8,"src0_trail":11,"src1_trail":12,"trail_item":3,"v":4,"work":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec_mul4_float(global const float* A, int offA, unsigned int A_col_size, unsigned int trail_item, global const float* v, int offv, float alpha, float beta, global float4* result, int offr, local float4* work) {
  unsigned int row_gid = get_group_id(0);
  unsigned int lid = get_local_id(0);
  const global float* src0_read = A + row_gid * 4 * A_col_size + offA;
  const global float* src1_read = v + offv;
  result = (global float4*)((global float*)result + offr);
  float4 dot0 = (float4)(0.f);
  float4 dot1 = (float4)(0.f);
  float4 dot2 = (float4)(0.f);
  float4 dot3 = (float4)(0.f);

  unsigned int i = lid;
  while (i < A_col_size / 4) {
    const float4 a0 = vload4(i, src0_read);
    const float4 a1 = vload4(i, src0_read + A_col_size);
    const float4 a2 = vload4(i, src0_read + 2 * A_col_size);
    const float4 a3 = vload4(i, src0_read + 3 * A_col_size);

    const float4 b0 = vload4(i, src1_read);

    dot0 += a0 * b0;
    dot1 += a1 * b0;
    dot2 += a2 * b0;
    dot3 += a3 * b0;

    i += get_local_size(0);
  }

  work[hook(10, lid)].s0 = dot0.x + dot0.y + dot0.z + dot0.w;
  work[hook(10, lid)].s1 = dot1.x + dot1.y + dot1.z + dot1.w;
  work[hook(10, lid)].s2 = dot2.x + dot2.y + dot2.z + dot2.w;
  work[hook(10, lid)].s3 = dot3.x + dot3.y + dot3.z + dot3.w;

  if (i == A_col_size / 4) {
    if (trail_item != 0) {
      const global float* src0_trail = src0_read + i * 4;
      const global float* src1_trail = src1_read + i * 4;
      for (unsigned int i = 0; i < trail_item; ++i) {
        const float at0 = src0_trail[hook(11, i)];
        const float at1 = src0_trail[hook(11, i + A_col_size)];
        const float at2 = src0_trail[hook(11, i + 2 * A_col_size)];
        const float at3 = src0_trail[hook(11, i + 3 * A_col_size)];

        const float bt = src1_trail[hook(12, i)];

        work[hook(10, lid)].s0 += at0 * bt;
        work[hook(10, lid)].s1 += at1 * bt;
        work[hook(10, lid)].s2 += at2 * bt;
        work[hook(10, lid)].s3 += at3 * bt;
      }
    }
  }

  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride >>= 1) {
    barrier(0x01);
    if (lid < stride)
      work[hook(10, lid)] += work[hook(10, lid + stride)];
  }
  if (lid == 0) {
    if (beta == (float)0)
      result[hook(8, row_gid)] = alpha * work[hook(10, 0)];
    else
      result[hook(8, row_gid)] = alpha * work[hook(10, 0)] + beta * result[hook(8, row_gid)];
  }
}