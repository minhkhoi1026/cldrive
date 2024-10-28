//{"global_data":5,"global_out_data":3,"global_wavelet_data":0,"local_data":2,"out_data":6,"output_offsets":1,"ptr":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int NormalizeIndex(int idx, int range) {
  return abs(idx - (int)(idx >= range) * (idx - range + 2));
}

int GetAt(local int* ptr, unsigned int x, unsigned int y) {
  const unsigned int stride = 2 * get_local_size(1);
  return ptr[hook(4, y * stride + x)];
}

void PutAt(local int* ptr, unsigned int x, unsigned int y, int val) {
  const unsigned int stride = 2 * get_local_size(1);
  ptr[hook(4, y * stride + x)] = val;
}

void InverseWaveletEven(local int* src, local int* scratch, unsigned int x, unsigned int y, unsigned int len, unsigned int mid) {
  const unsigned int idx = 2 * x;
  const int prev = mid + NormalizeIndex((int)(idx)-1, (int)len) / 2;
  const int next = mid + NormalizeIndex((int)(idx) + 1, (int)len) / 2;

  const int src_prev = GetAt(src, (unsigned int)prev, y);
  const int src_next = GetAt(src, (unsigned int)next, y);

  PutAt(scratch, y, idx, GetAt(src, x, y) - (src_prev + src_next + 2) / 4);
}

void InverseWaveletOdd(local int* src, local int* scratch, unsigned int x, unsigned int y, unsigned int len, unsigned int mid) {
  const unsigned int idx = mid + x;
  const int prev = NormalizeIndex((int)(2 * x), len);
  const int next = NormalizeIndex((int)(2 * x) + 2, len);

  const int dst_prev = GetAt(scratch, y, prev);
  const int dst_next = GetAt(scratch, y, next);

  PutAt(scratch, y, 2 * x + 1, GetAt(src, idx, y) + (dst_prev + dst_next) / 2);
}

kernel void inv_wavelet(const global uchar* global_wavelet_data, const constant unsigned int* output_offsets, local int* local_data, global char* global_out_data) {
  const int local_x = get_local_id(0);
  const int local_y = get_local_id(1);
  const int local_dim = 2 * get_local_size(1);
  const int wavelet_block_size = local_dim * local_dim;
  const int total_num_vals = 4 * get_global_size(0) * get_global_size(1);
  const global uchar* wavelet_data = global_wavelet_data + output_offsets[hook(1, 4 * (get_global_id(2) / 6))] + (get_global_id(2) % 6) * total_num_vals;

  global char* out_data = global_out_data + get_global_id(2) * total_num_vals;
  {
    const unsigned int group_idx = get_group_id(1) * get_num_groups(0) + get_group_id(0);
    const global uchar* global_data = wavelet_data + group_idx * wavelet_block_size;

    const unsigned int lidx = 4 * (local_y * get_local_size(0) + local_x);
    for (int i = 0; i < 4; ++i) {
      local_data[hook(2, lidx + i)] = ((int)(global_data[hook(5, lidx + i)])) - 128;
    }

    barrier(0x01);
  }
  local int* src = local_data;
  local int* scratch = local_data + wavelet_block_size;

  const unsigned int log_dim = 31 - clz(local_dim);
  for (unsigned int i = 0; i < log_dim - 1; ++i) {
    const int len = 1 << (i + 1);
    const int mid = len >> 1;

    const bool use_thread = local_x < mid && local_y < len;

    if (use_thread) {
      InverseWaveletEven(src, scratch, local_x, local_y, len, mid);
    }

    barrier(0x01);

    if (use_thread) {
      InverseWaveletOdd(src, scratch, local_x, local_y, len, mid);
    }

    barrier(0x01);

    if (use_thread) {
      InverseWaveletEven(scratch, src, local_x, local_y, len, mid);
    }

    barrier(0x01);

    if (use_thread) {
      InverseWaveletOdd(scratch, src, local_x, local_y, len, mid);
    }

    barrier(0x01);
  }

  const int len = 1 << log_dim;
  const int mid = len >> 1;
  InverseWaveletEven(src, scratch, local_x, local_y, len, mid);
  InverseWaveletEven(src, scratch, local_x, local_y + get_local_size(1), len, mid);

  barrier(0x01);

  InverseWaveletOdd(src, scratch, local_x, local_y, len, mid);
  InverseWaveletOdd(src, scratch, local_x, local_y + get_local_size(1), len, mid);

  barrier(0x01);

  InverseWaveletEven(scratch, src, local_x, local_y, len, mid);
  InverseWaveletEven(scratch, src, local_x, local_y + get_local_size(1), len, mid);

  barrier(0x01);

  InverseWaveletOdd(scratch, src, local_x, local_y, len, mid);
  InverseWaveletOdd(scratch, src, local_x, local_y + get_local_size(1), len, mid);

  barrier(0x01);

  {
    const unsigned int local_stride = local_dim;
    const unsigned int global_stride = local_stride * get_num_groups(0);

    const unsigned int odd_column = local_x & 0x1;
    const unsigned int ly = 2 * local_y + odd_column;
    const unsigned int lx = 4 * (local_x >> 1);
    const unsigned int lidx = ly * local_stride + lx;

    const unsigned int gy = get_group_id(1) * local_dim + 2 * local_y + odd_column;
    const unsigned int gx = 4 * (get_global_id(0) >> 1);
    const unsigned int gidx = gy * global_stride + gx;

    for (int i = 0; i < 4; ++i) {
      out_data[hook(6, gidx + i)] = (char)(local_data[hook(2, lidx + i)]);
    }
  }
}