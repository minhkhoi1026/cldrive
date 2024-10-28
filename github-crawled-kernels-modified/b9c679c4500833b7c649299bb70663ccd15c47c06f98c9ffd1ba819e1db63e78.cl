//{"fill":8,"image":0,"image_height":5,"image_width":4,"matrix":2,"mode":9,"offset":3,"output":1,"output_height":7,"output_width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_RGB(global unsigned char* image, global unsigned char* output, global float4* matrix, global float2* offset, int image_width, int image_height, int output_width, int output_height, float fill, int mode) {
  int float3 = get_global_id(0);
  int gid0 = get_global_id(1);
  int gid1 = get_global_id(2);
  float4 mat = *matrix;
  float2 off = *offset;

  if (!(gid0 < output_width && gid1 < output_height && float3 < 3))
    return;

  int x = gid0, y = gid1;

  float tx = dot(mat.s23, (float2)(y, x)), ty = dot(mat.s01, (float2)(y, x));

  tx += off.s1;
  ty += off.s0;

  int tx_next = ((int)tx) + 1, tx_prev = (int)tx, ty_next = ((int)ty) + 1, ty_prev = (int)ty;

  float interp = fill;

  if (0.0f <= tx && tx < image_width && 0.0f <= ty && ty < image_height) {
    if (mode == 1) {
      float image_p = image[hook(0, 3 * (ty_prev * image_width + tx_prev) + float3)], image_x = image[hook(0, 3 * (ty_prev * image_width + tx_next) + float3)], image_y = image[hook(0, 3 * (ty_next * image_width + tx_prev) + float3)], image_n = image[hook(0, 3 * (ty_next * image_width + tx_next) + float3)];

      if (tx_next >= image_width) {
        image_x = fill;
        image_n = fill;
      }
      if (ty_next >= image_height) {
        image_y = fill;
        image_n = fill;
      }

      float interp1 = ((float)(tx_next - tx)) * image_p + ((float)(tx - tx_prev)) * image_x,

            interp2 = ((float)(tx_next - tx)) * image_y + ((float)(tx - tx_prev)) * image_n;

      interp = ((float)(ty_next - ty)) * interp1 + ((float)(ty - ty_prev)) * interp2;

    }

    else {
      interp = image[hook(0, 3 * (((int)ty) * image_width + ((int)tx)) + float3)];
    }
  }

  float u = -0.5;
  float v = -0.5;
  if (tx >= image_width + u) {
    interp = fill;
  }
  if (ty >= image_height + v) {
    interp = fill;
  }

  output[hook(1, 3 * (gid1 * output_width + gid0) + float3)] = interp;
}