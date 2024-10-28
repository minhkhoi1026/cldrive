//{"behind":7,"coeff":2,"dimx":3,"dimy":4,"dimz":5,"infront":8,"input":1,"output":0,"padding":6,"tile":10,"tile[ltidy + worky + 8]":11,"tile[ltidy]":9,"tile[ty + i]":14,"tile[ty - i]":13,"tile[ty]":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FiniteDifferences(global float* const output, global const float* const input, constant float* const coeff, const int dimx, const int dimy, const int dimz, const int padding) {
  bool valid = true;
  const int gtidx = get_global_id(0);
  const int gtidy = get_global_id(1);
  const int ltidx = get_local_id(0);
  const int ltidy = get_local_id(1);
  const int workx = get_local_size(0);
  const int worky = get_local_size(1);
  local float tile[8 + 2 * 8][8 + 2 * 8];

  const int stride_y = dimx + 2 * 8;
  const int stride_z = stride_y * (dimy + 2 * 8);

  int inputIndex = 0;
  int outputIndex = 0;

  inputIndex += 8 * stride_y + 8 + padding;

  inputIndex += gtidy * stride_y + gtidx;

  float infront[8];
  float behind[8];
  float current;

  const int tx = ltidx + 8;
  const int ty = ltidy + 8;

  if (gtidx >= dimx)
    valid = false;
  if (gtidy >= dimy)
    valid = false;

  for (int i = 8 - 2; i >= 0; i--) {
    behind[hook(7, i)] = input[hook(1, inputIndex)];
    inputIndex += stride_z;
  }

  current = input[hook(1, inputIndex)];
  outputIndex = inputIndex;
  inputIndex += stride_z;

  for (int i = 0; i < 8; i++) {
    infront[hook(8, i)] = input[hook(1, inputIndex)];
    inputIndex += stride_z;
  }

  for (int iz = 0; iz < dimz; iz++) {
    for (int i = 8 - 1; i > 0; i--)
      behind[hook(7, i)] = behind[hook(7, i - 1)];
    behind[hook(7, 0)] = current;
    current = infront[hook(8, 0)];
    for (int i = 0; i < 8 - 1; i++)
      infront[hook(8, i)] = infront[hook(8, i + 1)];
    infront[hook(8, 8 - 1)] = input[hook(1, inputIndex)];

    inputIndex += stride_z;
    outputIndex += stride_z;
    barrier(0x01);
    if (ltidy < 8) {
      tile[hook(10, ltidy)][hook(9, tx)] = input[hook(1, outputIndex - 8 * stride_y)];
      tile[hook(10, ltidy + worky + 8)][hook(11, tx)] = input[hook(1, outputIndex + worky * stride_y)];
    }

    if (ltidx < 8) {
      tile[hook(10, ty)][hook(12, ltidx)] = input[hook(1, outputIndex - 8)];
      tile[hook(10, ty)][hook(12, ltidx + workx + 8)] = input[hook(1, outputIndex + workx)];
    }
    tile[hook(10, ty)][hook(12, tx)] = current;
    barrier(0x01);

    float value = coeff[hook(2, 0)] * current;
    for (int i = 1; i <= 8; i++) {
      value += coeff[hook(2, i)] * (infront[hook(8, i - 1)] + behind[hook(7, i - 1)] + tile[hook(10, ty - i)][hook(13, tx)] + tile[hook(10, ty + i)][hook(14, tx)] + tile[hook(10, ty)][hook(12, tx - i)] + tile[hook(10, ty)][hook(12, tx + i)]);
    }

    if (valid)
      output[hook(0, outputIndex)] = value;
  }
}