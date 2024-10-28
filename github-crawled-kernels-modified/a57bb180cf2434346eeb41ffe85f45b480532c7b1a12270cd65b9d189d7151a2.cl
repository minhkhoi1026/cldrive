//{"depth":2,"height":1,"input_volume":7,"output_volume":11,"warp_depth":5,"warp_height":4,"warp_scale":6,"warp_width":3,"warpfield_x":8,"warpfield_y":9,"warpfield_z":10,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
global const short* LookupShortVolume(global const short* volume, int sizex, int sizey, int x, int y, int z) {
  return volume + (x + y * sizex + z * sizex * sizey);
}

float LinearInterpShortVolume(global const short* volume, int sizex, int sizey, float x, float y, float z) {
  const int x_int = (int)(x);
  const int y_int = (int)(y);
  const int z_int = (int)(z);
  const float x_frac = x - x_int;
  const float y_frac = y - y_int;
  const float z_frac = z - z_int;

  const float result = *LookupShortVolume(volume, sizex, sizey, x_int, y_int, z_int) * (1.0f - x_frac) * (1.0f - y_frac) * (1.0f - z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int + 1, y_int, z_int) * (x_frac) * (1.0f - y_frac) * (1.0f - z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int, y_int + 1, z_int) * (1.0f - x_frac) * (y_frac) * (1.0f - z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int + 1, y_int + 1, z_int) * (x_frac) * (y_frac) * (1.0f - z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int, y_int, z_int + 1) * (1.0f - x_frac) * (1.0f - y_frac) * (z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int + 1, y_int, z_int + 1) * (x_frac) * (1.0f - y_frac) * (z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int, y_int + 1, z_int + 1) * (1.0f - x_frac) * (y_frac) * (z_frac) + *LookupShortVolume(volume, sizex, sizey, x_int + 1, y_int + 1, z_int + 1) * (x_frac) * (y_frac) * (z_frac);
  return result;
}

global const float* LookupFloatVolume(global const float* volume, int sizex, int sizey, int x, int y, int z) {
  return volume + (x + y * sizex + z * sizex * sizey);
}

float LinearInterpFloatVolume(global const float* volume, int sizex, int sizey, float x, float y, float z) {
  const int x_int = (int)(x);
  const int y_int = (int)(y);
  const int z_int = (int)(z);
  const float x_frac = x - x_int;
  const float y_frac = y - y_int;
  const float z_frac = z - z_int;

  const float result = *LookupFloatVolume(volume, sizex, sizey, x_int, y_int, z_int) * (1.0f - x_frac) * (1.0f - y_frac) * (1.0f - z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int + 1, y_int, z_int) * (x_frac) * (1.0f - y_frac) * (1.0f - z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int, y_int + 1, z_int) * (1.0f - x_frac) * (y_frac) * (1.0f - z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int + 1, y_int + 1, z_int) * (x_frac) * (y_frac) * (1.0f - z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int, y_int, z_int + 1) * (1.0f - x_frac) * (1.0f - y_frac) * (z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int + 1, y_int, z_int + 1) * (x_frac) * (1.0f - y_frac) * (z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int, y_int + 1, z_int + 1) * (1.0f - x_frac) * (y_frac) * (z_frac) + *LookupFloatVolume(volume, sizex, sizey, x_int + 1, y_int + 1, z_int + 1) * (x_frac) * (y_frac) * (z_frac);
  return result;
}

kernel void warp(int width, int height, int depth, int warp_width, int warp_height, int warp_depth, float warp_scale, global const short* input_volume, global const float* warpfield_x, global const float* warpfield_y, global const float* warpfield_z, global short* output_volume) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  global short* const output_pixel = output_volume + (x + y * width + z * width * height);
  short output_value = -32768;

  const float warp_x = x / warp_scale;
  const float warp_y = y / warp_scale;
  const float warp_z = z / warp_scale;

  if (warp_x >= 0.0f && warp_x < (warp_width - 1) && warp_y >= 0.0f && warp_y < (warp_height - 1) && warp_z >= 0.0f && warp_z < (warp_depth - 1)) {
    const float dx = LinearInterpFloatVolume(warpfield_x, warp_width, warp_height, warp_x, warp_y, warp_z);
    const float dy = LinearInterpFloatVolume(warpfield_y, warp_width, warp_height, warp_x, warp_y, warp_z);
    const float dz = LinearInterpFloatVolume(warpfield_z, warp_width, warp_height, warp_x, warp_y, warp_z);

    const float source_x = x + dx;
    const float source_y = y + dy;
    const float source_z = z + dz;

    if (source_x >= 0.0f && source_x < (width - 1) && source_y >= 0.0f && source_y < (height - 1) && source_z >= 0.0f && source_z < (depth - 1)) {
      output_value = (short)(LinearInterpShortVolume(input_volume, width, height, source_x, source_y, source_z) + 0.5f);
    }
  }

  *output_pixel = output_value;
}