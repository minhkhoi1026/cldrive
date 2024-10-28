//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot(write_only image2d_t output) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  int depth = -1;
  const float2 c = (float2){coord.x / 1365.0f - 2.0f, coord.y / 1365.0f - 1.5f};
  float2 z = c;

  for (int i = 0; i < 20; i++) {
    z = (float2){(z).x * (z).x - (z).y * (z).y, (z).y * (z).x + (z).x * (z).y} + c;

    if (dot(z, z) > 4) {
      depth = i;
      break;
    }
  }

  if (depth < 0) {
    write_imagef(output, coord, (float4)(0.0f, 0.0f, 0.0f, 1.0f));
  } else {
    write_imagef(output, coord, (float4)(0.0f, 1.0f / (20 - depth) * 4, 1.0f / (20 - depth) * 8, 1.0f));
  }
}