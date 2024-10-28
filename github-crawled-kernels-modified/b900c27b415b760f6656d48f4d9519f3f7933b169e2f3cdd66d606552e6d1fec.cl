//{"a":1,"global_cols":4,"global_rows":3,"reduce":6,"tmp":5,"v":2,"y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mxmulv_blocked2(global float* y, global const float* a, global const float* v, const unsigned int global_rows, const unsigned int global_cols) {
  local float tmp[2048], reduce[256];

  const unsigned int nrows = (global_rows + get_global_size(0) - 1) / get_global_size(0);

  if (global_cols <= 2048) {
    const unsigned int lidx = get_local_id(0);

    const unsigned int ibegin = get_group_id(0) * get_local_size(0) * nrows;

    const unsigned int iend = min(global_rows, ibegin + (unsigned int)get_local_size(0) * nrows);

    for (unsigned int j = lidx; j < global_cols; j += get_local_size(0))
      tmp[hook(5, j)] = v[hook(2, j)];

    barrier(0x01);

    for (unsigned int i = ibegin; i < iend; ++i) {
      float f = 0.f;
      for (unsigned int j = lidx; j < global_cols; j += get_local_size(0))
        f += a[hook(1, i * global_cols + j)] * tmp[hook(5, j)];

      reduce[hook(6, lidx)] = f;

      barrier(0x01);
      for (unsigned int j = get_local_size(0) >> 1; j > 1; j = j >> 1) {
        if (lidx < j)
          reduce[hook(6, lidx)] += reduce[hook(6, lidx + j)];
        barrier(0x01);
      }
      if (!lidx)
        y[hook(0, i)] = reduce[hook(6, 0)] + reduce[hook(6, 1)];
    }

  } else {
    const unsigned int iend = min(global_rows, ((int)get_global_id(0) + 1) * nrows);

    for (unsigned int i = get_global_id(0) * nrows; i < iend; ++i) {
      y[hook(0, i)] = *v - *v;
    }

    for (unsigned int j2 = 0; j2 < global_cols; j2 += 2048) {
      const unsigned int j2end = min(j2 + 2048, global_cols);

      for (unsigned int j = j2 + get_local_id(0); j < j2end; j += get_local_size(0))
        tmp[hook(5, j - j2)] = v[hook(2, j)];

      barrier(0x01);

      for (unsigned int i = get_global_id(0) * nrows; i < iend; ++i) {
        float f = y[hook(0, i)];
        for (unsigned int j = j2; j < j2end; ++j)
          f += a[hook(1, i * global_cols + j)] * tmp[hook(5, j - j2)];
        y[hook(0, i)] = f;
      }

      barrier(0x01);
    }
  }
}