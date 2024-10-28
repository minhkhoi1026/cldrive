//{"buffer":5,"kern":1,"median_index":4,"out":2,"pad":0,"pad_num_col":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(const global float* pad, global float* kern, global float* out, const int pad_num_col, const float median_index) {
  const int NUM_ITERATIONS = 8;

  const int out_num_col = get_global_size(0);
  const int out_col = get_global_id(0);
  const int out_row = get_global_id(1);

  float buffer[25];

  int pad_row_head;
  int index = 0;
  int i = 0;

  pad_row_head = out_row * pad_num_col + out_col;
  buffer[hook(5, 0)] = pad[hook(0, pad_row_head)];
  buffer[hook(5, 1)] = pad[hook(0, pad_row_head + 1)];
  buffer[hook(5, 2)] = pad[hook(0, pad_row_head + 2)];
  buffer[hook(5, 3)] = pad[hook(0, pad_row_head + 3)];
  buffer[hook(5, 4)] = pad[hook(0, pad_row_head + 4)];

  pad_row_head += pad_num_col;
  buffer[hook(5, 5)] = pad[hook(0, pad_row_head)];
  buffer[hook(5, 6)] = pad[hook(0, pad_row_head + 1)];
  buffer[hook(5, 7)] = pad[hook(0, pad_row_head + 2)];
  buffer[hook(5, 8)] = pad[hook(0, pad_row_head + 3)];
  buffer[hook(5, 9)] = pad[hook(0, pad_row_head + 4)];

  pad_row_head += pad_num_col;
  buffer[hook(5, 10)] = pad[hook(0, pad_row_head)];
  buffer[hook(5, 11)] = pad[hook(0, pad_row_head + 1)];
  buffer[hook(5, 12)] = pad[hook(0, pad_row_head + 2)];
  buffer[hook(5, 13)] = pad[hook(0, pad_row_head + 3)];
  buffer[hook(5, 14)] = pad[hook(0, pad_row_head + 4)];

  pad_row_head += pad_num_col;
  buffer[hook(5, 15)] = pad[hook(0, pad_row_head)];
  buffer[hook(5, 16)] = pad[hook(0, pad_row_head + 1)];
  buffer[hook(5, 17)] = pad[hook(0, pad_row_head + 2)];
  buffer[hook(5, 18)] = pad[hook(0, pad_row_head + 3)];
  buffer[hook(5, 19)] = pad[hook(0, pad_row_head + 4)];

  pad_row_head += pad_num_col;
  buffer[hook(5, 20)] = pad[hook(0, pad_row_head)];
  buffer[hook(5, 21)] = pad[hook(0, pad_row_head + 1)];
  buffer[hook(5, 22)] = pad[hook(0, pad_row_head + 2)];
  buffer[hook(5, 23)] = pad[hook(0, pad_row_head + 3)];
  buffer[hook(5, 24)] = pad[hook(0, pad_row_head + 4)];

  float estimate = 128.0f;
  float lower = 0.0f;
  float upper = 255.0f;
  float higher;

  for (int _ = 0; _ < NUM_ITERATIONS; _++) {
    higher = 0;
    higher += ((float)(estimate < buffer[hook(5, 0)])) * kern[hook(1, 0)];
    higher += ((float)(estimate < buffer[hook(5, 1)])) * kern[hook(1, 1)];
    higher += ((float)(estimate < buffer[hook(5, 2)])) * kern[hook(1, 2)];
    higher += ((float)(estimate < buffer[hook(5, 3)])) * kern[hook(1, 3)];
    higher += ((float)(estimate < buffer[hook(5, 4)])) * kern[hook(1, 4)];
    higher += ((float)(estimate < buffer[hook(5, 5)])) * kern[hook(1, 5)];
    higher += ((float)(estimate < buffer[hook(5, 6)])) * kern[hook(1, 6)];
    higher += ((float)(estimate < buffer[hook(5, 7)])) * kern[hook(1, 7)];
    higher += ((float)(estimate < buffer[hook(5, 8)])) * kern[hook(1, 8)];
    higher += ((float)(estimate < buffer[hook(5, 9)])) * kern[hook(1, 9)];
    higher += ((float)(estimate < buffer[hook(5, 10)])) * kern[hook(1, 10)];
    higher += ((float)(estimate < buffer[hook(5, 11)])) * kern[hook(1, 11)];
    higher += ((float)(estimate < buffer[hook(5, 12)])) * kern[hook(1, 12)];
    higher += ((float)(estimate < buffer[hook(5, 13)])) * kern[hook(1, 13)];
    higher += ((float)(estimate < buffer[hook(5, 14)])) * kern[hook(1, 14)];
    higher += ((float)(estimate < buffer[hook(5, 15)])) * kern[hook(1, 15)];
    higher += ((float)(estimate < buffer[hook(5, 16)])) * kern[hook(1, 16)];
    higher += ((float)(estimate < buffer[hook(5, 17)])) * kern[hook(1, 17)];
    higher += ((float)(estimate < buffer[hook(5, 18)])) * kern[hook(1, 18)];
    higher += ((float)(estimate < buffer[hook(5, 19)])) * kern[hook(1, 19)];
    higher += ((float)(estimate < buffer[hook(5, 20)])) * kern[hook(1, 20)];
    higher += ((float)(estimate < buffer[hook(5, 21)])) * kern[hook(1, 21)];
    higher += ((float)(estimate < buffer[hook(5, 22)])) * kern[hook(1, 22)];
    higher += ((float)(estimate < buffer[hook(5, 23)])) * kern[hook(1, 23)];
    higher += ((float)(estimate < buffer[hook(5, 24)])) * kern[hook(1, 24)];
    if (higher > median_index) {
      lower = estimate;
    } else {
      upper = estimate;
    }
    estimate = 0.5 * (upper + lower);
  }

  out[hook(2, out_row * out_num_col + out_col)] = estimate;
}