//{"bytes":9,"colors":4,"prev_res_x":0,"prev_res_y":1,"res_x":2,"res_y":3,"rgb_in":5,"rgb_out":6,"v":7,"words":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int p1 = 0x9E3779B1;
constant unsigned int p2 = 0x85EBCA77;
constant unsigned int p3 = 0xC2B2AE3D;
constant unsigned int p4 = 0x27D4EB2F;
constant unsigned int p5 = 0x165667B1;
unsigned int uint_xxhash32(unsigned int* data, unsigned int len, unsigned int seed) {
  {
    int i = 0;
    int n = 0;
    const uchar* bytes = (const uchar*)(data);
    const unsigned int* words = (const unsigned int*)(data);

    unsigned int h32;
    if (len >= 16) {
      {
        unsigned int limit = len - 16;
        unsigned int v[4];
        v[hook(7, 0)] = seed + p1 + p2;
        v[hook(7, 1)] = seed + p2;
        v[hook(7, 2)] = seed;
        v[hook(7, 3)] = seed - p1;
        while (i <= limit) {
          {
            for (int j = 0; j < 3; j++) {
              {
                v[hook(7, j)] = v[hook(7, j)] + words[hook(8, n)] * p2;
                v[hook(7, j)] = rotate(v[hook(7, j)], (unsigned int)13);
                v[hook(7, j)] = v[hook(7, j)] * p1;
                i = i + 4;
                n = n + 1;
              }
            }
          }
        }
        h32 = rotate(v[hook(7, 0)], (unsigned int)1) + rotate(v[hook(7, 1)], (unsigned int)7) + rotate(v[hook(7, 2)], (unsigned int)12) + rotate(v[hook(7, 3)], (unsigned int)18);
      }
    } else {
      { h32 = seed + p5; }
    }
    h32 = h32 + len;

    int limit = len - 4;

    while (i < limit) {
      {
        h32 = (h32 + (words[hook(8, n)] * p3));
        h32 = rotate(h32, (unsigned int)17) * p4;
        i += 4;
        n++;
      }
    }

    while (i < len) {
      {
        h32 = h32 + bytes[hook(9, i << 2)] * p5;
        h32 = rotate(h32, (unsigned int)11) * p1;
        i++;
      }
    }

    h32 = h32 ^ (h32 >> 15);
    h32 = h32 * p2;
    h32 = h32 ^ (h32 >> 13);
    h32 = h32 * p3;

    return h32 ^ (h32 >> 16);
  }
}

float uniformToNormal(unsigned int rand_in) {
  {
    float u1 = rand_in * (1.0 / 4294967295);
    float rnd = sqrt(-2.0 * log(u1));
    if (rand_in & 1) {
      {
        return rnd;
      }
    }
    return -rnd;
  }
}

float normal(unsigned int rand_in, float mean, float variance) {
  {
    float u1 = rand_in * (1.0 / 4294967295);
    float rnd = sqrt(-2.0 * log(u1));
    if (rand_in & 1) {
      {
        return rnd * variance + mean;
      }
    }
    return -rnd * variance + mean;
  }
}
uchar guardGetColor(const unsigned int prev_res_x, const unsigned int prev_res_y, const unsigned int res_x, const unsigned int res_y, const unsigned int colors, int3 pos, const global uchar* rgb_in, uchar rgb_default) {
  {
    if (pos.x < 0 || pos.y < 0 || pos.x > prev_res_x || pos.y > prev_res_y) {
      {
        return rgb_default;
      }
    } else {
      { return (rgb_in[hook(5, pos.x * prev_res_y * colors + pos.y * colors + pos.z)]); }
    }
  }
}

uchar guardGetColorFloat(const unsigned int prev_res_x, const unsigned int prev_res_y, const unsigned int res_x, const unsigned int res_y, const unsigned int colors, float2 pos, int float3, const global uchar* rgb_in, uchar rgb_default) {
  {
    uchar color_top_left = guardGetColor(prev_res_x, prev_res_y, res_x, res_y, colors, (int3)((int)(pos.x), (int)(pos.y), float3), rgb_in, rgb_default);
    uchar color_top_right = guardGetColor(prev_res_x, prev_res_y, res_x, res_y, colors, (int3)((int)(pos.x + 1), (int)(pos.y), float3), rgb_in, rgb_default);
    uchar color_bottom_left = guardGetColor(prev_res_x, prev_res_y, res_x, res_y, colors, (int3)((int)(pos.x), (int)(pos.y + 1), float3), rgb_in, rgb_default);
    uchar color_bottom_right = guardGetColor(prev_res_x, prev_res_y, res_x, res_y, colors, (int3)((int)(pos.x + 1), (int)(pos.y + 1), float3), rgb_in, rgb_default);

    float right_percentage = pos.x - (int)(pos.x);
    float bottom_percentage = pos.y - (int)(pos.y);

    float avg_color = (((color_top_left + color_bottom_left) * (1 - right_percentage) + (color_top_right + color_bottom_right) * right_percentage) / 2 + ((color_top_left + color_top_right) * (1 - bottom_percentage) + (color_bottom_left + color_bottom_right) * bottom_percentage) / 2) / 2;

    return (uchar)(avg_color);
  }
}

uchar get_surround_square_avg(const unsigned int prev_res_x, const unsigned int prev_res_y, const unsigned int res_x, const unsigned int res_y, const unsigned int colors, float2 pos, int float3, unsigned int rad, const global uchar* rgb_in, uchar rgb_default) {
  {
    unsigned int surround = 0;
    unsigned int num = 0;

    for (int i = 0; i < 2 * rad + 1; ++i) {
      {
        float2 top = pos + (float2)(i - rad, -rad);
        float2 bot = pos + (float2)(i - rad, rad);

        surround += guardGetColorFloat(prev_res_x, prev_res_y, res_x, res_y, colors, top, float3, rgb_in, rgb_default);
        surround += guardGetColorFloat(prev_res_x, prev_res_y, res_x, res_y, colors, bot, float3, rgb_in, rgb_default);

        num += 2;
      }
    }
    for (int j = 1; j < 2 * rad; ++j) {
      {
        float2 left = pos + (float2)(-rad, j - rad);
        float2 rigt = pos + (float2)(rad, j - rad);

        surround += guardGetColorFloat(prev_res_x, prev_res_y, res_x, res_y, colors, left, float3, rgb_in, rgb_default);
        surround += guardGetColorFloat(prev_res_x, prev_res_y, res_x, res_y, colors, rigt, float3, rgb_in, rgb_default);

        num += 2;
      }
    }
    return surround / num;
  }
}
kernel void rgc(const unsigned int prev_res_x, const unsigned int prev_res_y, const unsigned int res_x, const unsigned int res_y, const unsigned int colors, const global uchar* rgb_in, global uchar* rgb_out)

{
  {
    int3 coord = (int3)(get_global_id(0), get_global_id(1), get_global_id(2));
    float2 pos = (float2)((float)(coord.x) * (float)(prev_res_x) / (float)(res_x), (float)(coord.y) * (float)(prev_res_y) / (float)(res_y));

    uchar c = guardGetColorFloat(prev_res_x, prev_res_y, res_x, res_y, colors, pos, coord.z, rgb_in, (uchar)(0));

    rgb_out[hook(6, coord.x * res_y * colors + coord.y * colors + coord.z)] = c;
  }
}