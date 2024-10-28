//{"Y":4,"input":0,"output":1,"pixel_in":3,"pixel_out":10,"table":2,"table_id":7,"ui":5,"uo":8,"vi":6,"vo":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int get_sector_id(float u, float v) {
  u = fabs(u) > 0.00001f ? u : 0.00001f;
  float tg = v / u;
  unsigned int se = tg > 1 ? (tg > 2 ? 3 : 2) : (tg > 0.5 ? 1 : 0);
  unsigned int so = tg > -1 ? (tg > -0.5 ? 3 : 2) : (tg > -2 ? 1 : 0);
  return tg > 0 ? (u > 0 ? se : (se + 8)) : (u > 0 ? (so + 12) : (so + 4));
}
kernel void kernel_macc(read_only image2d_t input, write_only image2d_t output, global float* table) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in[8], pixel_out[8];
  float Y[8], ui[8], vi[8], uo[8], vo[8];
  unsigned int table_id[8];
  int i = 0, j = 0;

  for (j = 0; j < 2; j++) {
    for (i = 0; i < 4; i++) {
      pixel_in[hook(3, j * 4 + i)] = read_imagef(input, sampler, (int2)(4 * x + i, 2 * y + j));
      Y[hook(4, j * 4 + i)] = 0.3 * pixel_in[hook(3, j * 4 + i)].x + 0.59 * pixel_in[hook(3, j * 4 + i)].y + 0.11 * pixel_in[hook(3, j * 4 + i)].z;
      ui[hook(5, j * 4 + i)] = 0.493 * (pixel_in[hook(3, j * 4 + i)].z - Y[hook(4, j * 4 + i)]);
      vi[hook(6, j * 4 + i)] = 0.877 * (pixel_in[hook(3, j * 4 + i)].x - Y[hook(4, j * 4 + i)]);
      table_id[hook(7, j * 4 + i)] = get_sector_id(ui[hook(5, j * 4 + i)], vi[hook(6, j * 4 + i)]);
      uo[hook(8, j * 4 + i)] = ui[hook(5, j * 4 + i)] * table[hook(2, 4 * table_id[jhook(7, j * 4 + i))] + vi[hook(6, j * 4 + i)] * table[hook(2, 4 * table_id[jhook(7, j * 4 + i) + 1)];
      vo[hook(9, j * 4 + i)] = ui[hook(5, j * 4 + i)] * table[hook(2, 4 * table_id[jhook(7, j * 4 + i) + 2)] + vi[hook(6, j * 4 + i)] * table[hook(2, 4 * table_id[jhook(7, j * 4 + i) + 3)];
      pixel_out[hook(10, j * 4 + i)].x = Y[hook(4, j * 4 + i)] + 1.14 * vo[hook(9, j * 4 + i)];
      pixel_out[hook(10, j * 4 + i)].y = Y[hook(4, j * 4 + i)] - 0.39 * uo[hook(8, j * 4 + i)] - 0.58 * vo[hook(9, j * 4 + i)];
      pixel_out[hook(10, j * 4 + i)].z = Y[hook(4, j * 4 + i)] + 2.03 * uo[hook(8, j * 4 + i)];
      pixel_out[hook(10, j * 4 + i)].w = 0.0;
      write_imagef(output, (int2)(4 * x + i, 2 * y + j), pixel_out[hook(10, j * 4 + i)]);
    }
  }
}