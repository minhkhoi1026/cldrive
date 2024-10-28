//{"nms":1,"sobel":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0x10 | 0 | 2;
constant float TLOW = 0.01;
constant float THIGH = 0.3;
constant int2 OFF3X3[] = {
    (int2)(-1, -1), (int2)(0, -1), (int2)(1, -1), (int2)(-1, 0), (int2)(1, 0), (int2)(-1, 1), (int2)(0, 1), (int2)(1, 1),
};

constant int2 OFF5X5[] = {(int2)(-2, -2), (int2)(-1, -2), (int2)(0, -2), (int2)(1, -2), (int2)(2, -2), (int2)(-2, -1), (int2)(2, -1), (int2)(-2, 0), (int2)(2, 0), (int2)(-2, 1), (int2)(2, 1), (int2)(-2, 2), (int2)(-1, 2), (int2)(0, 2), (int2)(1, 2), (int2)(2, 2)};

kernel void krnNMS(read_only image2d_t sobel, write_only image2d_t nms) {
  float left, right;
  int2 uv, dir;
  float4 center, pix, out;

  uv = (int2){get_global_id(0), get_global_id(1)};
  pix = read_imagef(sobel, sampler, uv);

  if (pix.y < 0.125) {
    dir = (int2)(0, 1);
  } else if (pix.y < 0.375) {
    dir = (int2)(-1, 1);
  } else if (pix.y < 0.625) {
    dir = (int2)(1, 0);
  } else if (pix.y < 0.875) {
    dir = (int2)(1, 1);
  } else {
    dir = (int2)(0, 1);
  }

  center = read_imagef(sobel, sampler, uv);
  left = read_imagef(sobel, sampler, uv + dir).x;
  right = read_imagef(sobel, sampler, uv - dir).x;

  out = (float4)(0.0);
  if (center.x > left && center.x > right) {
    out = center;
  }

  write_imagef(nms, uv, out);
}