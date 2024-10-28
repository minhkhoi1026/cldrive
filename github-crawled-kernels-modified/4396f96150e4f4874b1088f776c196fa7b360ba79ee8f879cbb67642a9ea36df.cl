//{"biome_codes":4,"biomes":3,"heightmap":0,"precipitation":1,"temperature":2}
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

kernel void biomes(read_only image2d_t heightmap, read_only image2d_t precipitation, read_only image2d_t temperature, write_only image2d_t biomes, write_only image2d_t biome_codes) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);

  int2 s = get_image_dim(biomes);
  float4 outcol;
  outcol.x = 0;
  outcol.y = 0;
  outcol.z = 0;

  int4 outcol2;

  float h = read_imagef(heightmap, sampler, coord).x;
  float p = read_imagef(precipitation, sampler, coord).x;
  float t = read_imagef(temperature, sampler, coord).x;

  float preci = linear_interpolate(0, 300, p / 255.0);
  float temp = linear_interpolate(-20, 35, t / 255.0);

  if (h < 1) {
    outcol.x = 150;
    outcol.y = 150;
    outcol.z = 255;
    outcol2.x = 0;
  } else {
    if (preci <= 10) {
      if (temp <= -10) {
        outcol2.x = 1;
        outcol.x = 236;
        outcol.y = 242;
        outcol.z = 241;
      } else {
        outcol2.x = 4;
        outcol.x = 137;
        outcol.y = 114;
        outcol.z = 64;
      }
    } else if (preci <= 50) {
      if (temp <= -10) {
        outcol2.x = 1;
        outcol.x = 236;
        outcol.y = 242;
        outcol.z = 241;
      } else if (temp <= -5) {
        outcol2.x = 2;
        outcol.x = 198;
        outcol.y = 149;
        outcol.z = 91;
      } else if (temp <= 15) {
        outcol2.x = 3;
        outcol.x = 106;
        outcol.y = 86;
        outcol.z = 51;
      } else if (temp <= 20) {
        outcol2.x = 4;
        outcol.x = 137;
        outcol.y = 114;
        outcol.z = 64;
      } else {
        outcol2.x = 5;
        outcol.x = 118;
        outcol.y = 109;
        outcol.z = 50;
      }
    } else if (preci < 100) {
      if (temp <= 15) {
        outcol2.x = 6;
        outcol.x = 63;
        outcol.y = 70;
        outcol.z = 37;
      } else if (temp <= 12) {
        outcol2.x = 7;
        outcol.x = 87;
        outcol.y = 117;
        outcol.z = 45;
      } else if (temp <= 20) {
        outcol2.x = 4;
        outcol.x = 137;
        outcol.y = 114;
        outcol.z = 64;
      } else {
        outcol2.x = 5;
        outcol.x = 118;
        outcol.y = 109;
        outcol.z = 50;
      }
    } else if (preci <= 200) {
      if (temp <= -15) {
        outcol2.x = 1;
        outcol.x = 236;
        outcol.y = 242;
        outcol.z = 241;
      }
      if (temp <= 13) {
        outcol2.x = 6;
        outcol.x = 63;
        outcol.y = 70;
        outcol.z = 37;
      } else if (temp <= 20) {
        outcol2.x = 7;
        outcol.x = 87;
        outcol.y = 117;
        outcol.z = 45;
      } else {
        outcol2.x = 8;
        outcol.x = 95;
        outcol.y = 89;
        outcol.z = 41;
      }
    } else if (preci <= 400) {
      if (temp < -10) {
        outcol2.x = 1;
        outcol.x = 236;
        outcol.y = 242;
        outcol.z = 241;
      } else if (temp < 0) {
        outcol2.x = 2;
        outcol.x = 198;
        outcol.y = 149;
        outcol.z = 91;
      } else if (temp < 20) {
        outcol2.x = 9;
        outcol.x = 53;
        outcol.y = 54;
        outcol.z = 22;
      } else {
        outcol2.x = 10;
        outcol.x = 65;
        outcol.y = 73;
        outcol.z = 34;
      }
    }
  }

  if (h < 1) {
    outcol2.y = 0;
  } else if (h <= 86) {
    outcol2.y = 1;
  } else if (h > 86 && h <= 102) {
    outcol2.y = 2;
  } else {
    outcol2.y = 3;
    outcol.x = 150;
    outcol.y = 150;
    outcol.z = 150;
  }

  outcol.w = 255;

  write_imagef(biomes, coord, outcol);
  write_imagei(biome_codes, coord, outcol2);
}