//{"A":0,"A_col_size":2,"alpha":7,"beta":8,"offA":1,"offr":10,"offv":6,"result":9,"row_offset":3,"src0_trail":12,"src1_trail":13,"trail_item":4,"v":5,"work":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec_mul1_float(global const float* A, int offA, unsigned int A_col_size, unsigned int row_offset, unsigned int trail_item, global const float* v, int offv, float alpha, float beta, global float* result, int offr, local float* work) {
  unsigned int row_gid = get_group_id(0);
  unsigned int lid = get_local_id(0);

  const global float* src0_read = A + (row_offset + row_gid) * A_col_size + offA;
  const global float* src1_read = v + +offv;
  result = result + offr;
  float4 dot0 = (float4)(0.f);

  unsigned int i = lid;
  while (i < A_col_size / 4) {
    const float4 a0 = vload4(i, src0_read);
    const float4 b0 = vload4(i, src1_read);

    dot0 += a0 * b0;
    i += get_local_size(0);
  }

  work[hook(11, lid)] = dot0.x + dot0.y + dot0.z + dot0.w;

  if (i == A_col_size / 4) {
    if (trail_item != 0) {
      const global float* src0_trail = src0_read + i * 4;
      const global float* src1_trail = src1_read + i * 4;
      for (unsigned int i = 0; i < trail_item; ++i) {
        const float at0 = src0_trail[hook(12, i)];
        const float bt = src1_trail[hook(13, i)];

        work[hook(11, lid)] += at0 * bt;
      }
    }
  }
  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride >>= 1) {
    barrier(0x01);
    if (lid < stride)
      work[hook(11, lid)] += work[hook(11, lid + stride)];
  }

  if (lid == 0) {
    if (beta == (float)0) {
      result[hook(9, row_gid + row_offset)] = alpha * work[hook(11, 0)];
    } else {
      result[hook(9, row_gid + row_offset)] *= beta;
      result[hook(9, row_gid + row_offset)] += alpha * work[hook(11, 0)];
    }
  }
}