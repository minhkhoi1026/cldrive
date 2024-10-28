//{"dest":1,"dst_step":3,"height":5,"matrix":6,"source":0,"src_step":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
bool OutsideImage(int2 pos, int src_step, int dst_step, int width, int height, int mask_size) {
  if (pos.x < mask_size || pos.y < mask_size)
    return true;

  if (pos.x >= width - mask_size || pos.y >= height - mask_size)
    return true;

  return false;
}
float Combine(float color1, float color2) {
  return sqrt(color1 * color1 + color2 * color2);
}

float Convolution(global const uchar* source, int src_step, int dst_step, int width, int height, constant const float* matrix, private int matrix_width) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  const int2 pos = {gx, gy};
  src_step /= sizeof(uchar);

  const int mask_size = matrix_width / 2;

  if (OutsideImage(pos, src_step, dst_step, width, height, mask_size))
    return 0;

  float sum = 0;
  int Index = 0;

  switch (mask_size) {
    case 1: {
      for (int y = -1; y <= 1; y++)
        for (int x = -1; x <= 1; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 2: {
      for (int y = -2; y <= 2; y++)
        for (int x = -2; x <= 2; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 3: {
      for (int y = -3; y <= 3; y++)
        for (int x = -3; x <= 3; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 4: {
      for (int y = -4; y <= 4; y++)
        for (int x = -4; x <= 4; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 5: {
      for (int y = -5; y <= 5; y++)
        for (int x = -5; x <= 5; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 6: {
      for (int y = -6; y <= 6; y++)
        for (int x = -6; x <= 6; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 7: {
      for (int y = -7; y <= 7; y++)
        for (int x = -7; x <= 7; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 8: {
      for (int y = -8; y <= 8; y++)
        for (int x = -8; x <= 8; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 9: {
      for (int y = -9; y <= 9; y++)
        for (int x = -9; x <= 9; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 10: {
      for (int y = -10; y <= 10; y++)
        for (int x = -10; x <= 10; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 11: {
      for (int y = -11; y <= 11; y++)
        for (int x = -11; x <= 11; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 12: {
      for (int y = -12; y <= 12; y++)
        for (int x = -12; x <= 12; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 13: {
      for (int y = -13; y <= 13; y++)
        for (int x = -13; x <= 13; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 14: {
      for (int y = -14; y <= 14; y++)
        for (int x = -14; x <= 14; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 15: {
      for (int y = -15; y <= 15; y++)
        for (int x = -15; x <= 15; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 16: {
      for (int y = -16; y <= 16; y++)
        for (int x = -16; x <= 16; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 17: {
      for (int y = -17; y <= 17; y++)
        for (int x = -17; x <= 17; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 18: {
      for (int y = -18; y <= 18; y++)
        for (int x = -18; x <= 18; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 19: {
      for (int y = -19; y <= 19; y++)
        for (int x = -19; x <= 19; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 20: {
      for (int y = -20; y <= 20; y++)
        for (int x = -20; x <= 20; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 21: {
      for (int y = -21; y <= 21; y++)
        for (int x = -21; x <= 21; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 22: {
      for (int y = -22; y <= 22; y++)
        for (int x = -22; x <= 22; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 23: {
      for (int y = -23; y <= 23; y++)
        for (int x = -23; x <= 23; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 24: {
      for (int y = -24; y <= 24; y++)
        for (int x = -24; x <= 24; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 25: {
      for (int y = -25; y <= 25; y++)
        for (int x = -25; x <= 25; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 26: {
      for (int y = -26; y <= 26; y++)
        for (int x = -26; x <= 26; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 27: {
      for (int y = -27; y <= 27; y++)
        for (int x = -27; x <= 27; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 28: {
      for (int y = -28; y <= 28; y++)
        for (int x = -28; x <= 28; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 29: {
      for (int y = -29; y <= 29; y++)
        for (int x = -29; x <= 29; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 30: {
      for (int y = -30; y <= 30; y++)
        for (int x = -30; x <= 30; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
    case 31: {
      for (int y = -31; y <= 31; y++)
        for (int x = -31; x <= 31; x++)
          sum += matrix[hook(6, Index++)] * convert_float(source[hook(0, (pos + (int2){x, y}).y * src_step + (pos + (int2){x, y}).x)]);
    } break;
  }

  return sum;
}

void convolution(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, int height, constant const float* matrix, private int matrix_width) {
  float sum = Convolution(source, src_step, dst_step, width, height, matrix, matrix_width);

  dest[hook(1, get_global_id(1) * dst_step / sizeof(uchar) + get_global_id(0))] = convert_uchar_sat(sum);
}

kernel void sobelH3(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, int height) {
  constant const float matrix[9] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};

  convolution(source, dest, src_step, dst_step, width, height, matrix, 3);
}