//{"dst":4,"g_mat":0,"l_mat":1,"size":2,"src":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void on_diagonal_transpose(int row_size, local float4* l_mat, global float4* src) {
  l_mat[hook(1, 0)] = src[hook(3, 0)];
  l_mat[hook(1, 1)] = src[hook(3, row_size)];
  l_mat[hook(1, 2)] = src[hook(3, 2 * row_size)];
  l_mat[hook(1, 3)] = src[hook(3, 3 * row_size)];

  src[hook(3, 0)] = (float4)(l_mat[hook(1, 0)].x, l_mat[hook(1, 1)].x, l_mat[hook(1, 2)].x, l_mat[hook(1, 3)].x);
  src[hook(3, row_size)] = (float4)(l_mat[hook(1, 0)].y, l_mat[hook(1, 1)].y, l_mat[hook(1, 2)].y, l_mat[hook(1, 3)].y);
  src[hook(3, 2 * row_size)] = (float4)(l_mat[hook(1, 0)].z, l_mat[hook(1, 1)].z, l_mat[hook(1, 2)].z, l_mat[hook(1, 3)].z);
  src[hook(3, 3 * row_size)] = (float4)(l_mat[hook(1, 0)].w, l_mat[hook(1, 1)].w, l_mat[hook(1, 2)].w, l_mat[hook(1, 3)].w);
}

kernel void transpose(global float4* g_mat, local float4* l_mat, unsigned int size) {
  global float4 *src, *dst;

  int col = get_global_id(0);
  int row = 0;
  while (col >= size) {
    col -= size--;
    row++;
  }
  col += row;
  size += row;

  src = g_mat + row * size * 4 + col;
  l_mat += get_local_id(0) * 8;
  l_mat[hook(1, 0)] = src[hook(3, 0)];
  l_mat[hook(1, 1)] = src[hook(3, size)];
  l_mat[hook(1, 2)] = src[hook(3, 2 * size)];
  l_mat[hook(1, 3)] = src[hook(3, 3 * size)];

  if (row == col) {
    src[hook(3, 0)] = (float4)(l_mat[hook(1, 0)].x, l_mat[hook(1, 1)].x, l_mat[hook(1, 2)].x, l_mat[hook(1, 3)].x);
    src[hook(3, size)] = (float4)(l_mat[hook(1, 0)].y, l_mat[hook(1, 1)].y, l_mat[hook(1, 2)].y, l_mat[hook(1, 3)].y);
    src[hook(3, 2 * size)] = (float4)(l_mat[hook(1, 0)].z, l_mat[hook(1, 1)].z, l_mat[hook(1, 2)].z, l_mat[hook(1, 3)].z);
    src[hook(3, 3 * size)] = (float4)(l_mat[hook(1, 0)].w, l_mat[hook(1, 1)].w, l_mat[hook(1, 2)].w, l_mat[hook(1, 3)].w);
  } else {
    dst = g_mat + col * size * 4 + row;
    l_mat[hook(1, 4)] = dst[hook(4, 0)];
    l_mat[hook(1, 5)] = dst[hook(4, size)];
    l_mat[hook(1, 6)] = dst[hook(4, 2 * size)];
    l_mat[hook(1, 7)] = dst[hook(4, 3 * size)];

    dst[hook(4, 0)] = (float4)(l_mat[hook(1, 0)].x, l_mat[hook(1, 1)].x, l_mat[hook(1, 2)].x, l_mat[hook(1, 3)].x);
    dst[hook(4, size)] = (float4)(l_mat[hook(1, 0)].y, l_mat[hook(1, 1)].y, l_mat[hook(1, 2)].y, l_mat[hook(1, 3)].y);
    dst[hook(4, 2 * size)] = (float4)(l_mat[hook(1, 0)].z, l_mat[hook(1, 1)].z, l_mat[hook(1, 2)].z, l_mat[hook(1, 3)].z);
    dst[hook(4, 3 * size)] = (float4)(l_mat[hook(1, 0)].w, l_mat[hook(1, 1)].w, l_mat[hook(1, 2)].w, l_mat[hook(1, 3)].w);

    src[hook(3, 0)] = (float4)(l_mat[hook(1, 4)].x, l_mat[hook(1, 5)].x, l_mat[hook(1, 6)].x, l_mat[hook(1, 7)].x);
    src[hook(3, size)] = (float4)(l_mat[hook(1, 4)].y, l_mat[hook(1, 5)].y, l_mat[hook(1, 6)].y, l_mat[hook(1, 7)].y);
    src[hook(3, 2 * size)] = (float4)(l_mat[hook(1, 4)].z, l_mat[hook(1, 5)].z, l_mat[hook(1, 6)].z, l_mat[hook(1, 7)].z);
    src[hook(3, 3 * size)] = (float4)(l_mat[hook(1, 4)].w, l_mat[hook(1, 5)].w, l_mat[hook(1, 6)].w, l_mat[hook(1, 7)].w);
  }
}