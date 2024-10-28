//{"biome_pal":3,"biomes":1,"heightmap":0,"sat":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float linear_interpolate(float x0, float x1, float alpha) {
  if (alpha > 1.0)
    alpha = 1.0;
  else if (alpha <= 0)
    alpha = 0.0;
  float interpolation = x0 * (1.0 - alpha) + alpha * x1;

  return interpolation;
}

float myabs(float i) {
  if (i < 0)
    return i * -1;
  return i;
}

kernel void satellite(read_only image2d_t heightmap, read_only image2d_t biomes, write_only image2d_t sat) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);

  int2 s = get_image_dim(biomes);
  float4 outcol;
  outcol.x = 255;
  outcol.y = 0;
  outcol.z = 0;
  outcol.w = 255;

  int3 biome_pal[] = {

      {30, 31, 33},    {31, 36, 45},    {32, 45, 40},

      {255, 255, 255}, {201, 228, 239}, {224, 226, 232}, {161, 180, 167},

      {88, 110, 62},   {135, 151, 90},

      {48, 73, 45},    {79, 101, 66},

      {102, 122, 77},  {69, 109, 64},

      {255, 249, 180}, {252, 227, 132}, {206, 131, 68},  {185, 132, 71},

      {207, 204, 107}, {233, 216, 107}, {227, 213, 111},

      {144, 182, 114}, {67, 102, 67},

      {115, 159, 80},  {72, 110, 67},

      {41, 61, 40},    {55, 77, 51},    {49, 76, 47},

      {45, 69, 42},    {48, 74, 45},    {60, 89, 56}};

  int3 height_pal[] = {{146, 166, 118}, {145, 162, 132}, {162, 179, 151}, {184, 200, 168}, {215, 226, 196}, {158, 169, 149}};

  float h = read_imagef(heightmap, sampler, coord).x;
  float b = read_imagef(biomes, sampler, coord).x;

  if (h < 1) {
    int offset = (coord.x + coord.y) % 2;
    outcol.x = linear_interpolate(biome_pal[hook(3, 0)].x, biome_pal[hook(3, 0 + offset)].x, myabs(sin(coord.x / 256.0)));
    outcol.y = linear_interpolate(biome_pal[hook(3, 0)].y, biome_pal[hook(3, 0 + offset)].y, myabs(sin(coord.x / 256.0)));
    outcol.z = linear_interpolate(biome_pal[hook(3, 0)].z, biome_pal[hook(3, 0 + offset)].z, myabs(sin(coord.x / 256.0)));
  }

  write_imagef(sat, coord, outcol);
}