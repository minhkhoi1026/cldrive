//{"air_temperature":4,"gpu_percent":9,"height":3,"input":0,"output":1,"plate_points":8,"point_temperature":7,"point_x":5,"point_y":6,"temperature_color":10,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
constant float gaussian_kernel = 1 / 9.0F;
struct vertex_args {
  float x, y;
  float r, g, b;
};

constant struct vertex_args temperature_color[11] = {
    {0.0F, 200.0F, 0.05F, 0.05F, 0.05F}, {200.0F, 426.0F, 0.08F, 0.05F, 0.05F}, {426.0F, 593.0F, 0.14F, 0.05F, 0.05F}, {593.0F, 704.0F, 0.24F, 0.05F, 0.06F}, {704.0F, 814.0F, 0.34F, 0.07F, 0.06F}, {815.0F, 870.0F, 0.54F, 0.08F, 0.07F}, {871.0F, 981.0F, 0.74F, 0.2F, 0.07F}, {981.0F, 1092.0F, 0.84F, 0.5F, 0.08F}, {1093.0F, 1258.0F, 1.0F, 1.0F, 0.1F}, {1259.0F, 1314.0F, 1.0F, 1.0F, 0.8F}, {1315.0F, -1.0F, 1.0F, 1.0F, 1.0F},
};

kernel void simulate(read_only image2d_t input, write_only image2d_t output, unsigned int width, unsigned int height, float air_temperature, unsigned int point_x, unsigned int point_y, float point_temperature, global struct vertex_args* plate_points, float gpu_percent) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  int global_index = coords.y * width + coords.x;
  float4 float3 = (float4)(0.0F, 0.0F, 0.0F, 0.0F);
  float4 ext_color = (float4)(air_temperature, air_temperature, air_temperature, air_temperature);
  int i, j;

  if (global_index > width * height * gpu_percent / 100.0F) {
    return;
  }

  if (point_x == coords.x && point_y == coords.y) {
    float3 = (float4)(point_temperature, point_temperature, point_temperature, point_temperature);
  } else {
    for (i = -1; i <= 1; i++) {
      for (j = -1; j <= 1; j++) {
        if (coords.x + i < 0 || coords.x + i >= width || coords.y + j < 0 || coords.y + j >= height)
          float3 += ext_color * gaussian_kernel;
        else
          float3 += read_imagef(input, sampler, (int2)(coords.x + i, coords.y + j)) * gaussian_kernel;
      }
    }
  }
  if (float3.x < temperature_color[hook(10, 11 - 1)].x) {
    for (int i = 0; i < 11 - 1; i++) {
      if (float3.x < temperature_color[hook(10, i)].y) {
        float diff = float3.x - temperature_color[hook(10, i)].x;
        float diff_total = temperature_color[hook(10, i)].y - temperature_color[hook(10, i)].x;
        float proc = diff / diff_total;

        plate_points[hook(8, global_index)].r = temperature_color[hook(10, i)].r + (temperature_color[hook(10, i + 1)].r - temperature_color[hook(10, i)].r) * proc;
        plate_points[hook(8, global_index)].g = temperature_color[hook(10, i)].g + (temperature_color[hook(10, i + 1)].g - temperature_color[hook(10, i)].g) * proc;
        plate_points[hook(8, global_index)].b = temperature_color[hook(10, i)].b + (temperature_color[hook(10, i + 1)].b - temperature_color[hook(10, i)].b) * proc;
        break;
      }
    }
  } else {
    plate_points[hook(8, global_index)].r = temperature_color[hook(10, 11 - 1)].r;
    plate_points[hook(8, global_index)].g = temperature_color[hook(10, 11 - 1)].g;
    plate_points[hook(8, global_index)].b = temperature_color[hook(10, 11 - 1)].b;
  }

  write_imagef(output, coords, float3);
}