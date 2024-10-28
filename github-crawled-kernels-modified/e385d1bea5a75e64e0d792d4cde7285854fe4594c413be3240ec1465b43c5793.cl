//{"Fmax":2,"spacing_x":4,"spacing_y":5,"spacing_z":6,"vectorField":1,"volume":0,"vsign":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t interpolationSampler = 0 | 2 | 0x20;
constant sampler_t hpSampler = 0 | 4 | 0x10;
float4 readImageToFloat(read_only image3d_t volume, int4 position) {
  int dataType = get_image_channel_data_type(volume);
  float4 value;
  if (dataType == 0x10DE) {
    value = read_imagef(volume, sampler, position).x;
  } else if (dataType == 0x10D8 || dataType == 0x10D7) {
    value = convert_float4(read_imagei(volume, sampler, position));
  } else {
    value = convert_float4(read_imageui(volume, sampler, position));
  }
  return value;
}

float3 gradient(read_only image3d_t volume, int4 pos, int volumeComponent, int dimensions, float3 spacing) {
  float f100, f_100, f010 = 0, f0_10 = 0, f001 = 0, f00_1 = 0;
  switch (volumeComponent) {
    case 0:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).x;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).x;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).x;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).x;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).x;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).x;
      }
      break;
    case 1:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).y;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).y;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).y;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).y;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).y;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).y;
      }
      break;
    case 2:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).z;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).z;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).z;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).z;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).z;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).z;
      }
      break;
  }

  float3 gradient = {(f100 - f_100) / (2.0f), (f010 - f0_10) / (2.0f), (f001 - f00_1) / (2.0f)};

  float gradientLength = length(gradient);
  gradient /= spacing;
  gradient = gradientLength * normalize(gradient);

  return gradient;
}

float3 gradientNormalized(read_only image3d_t volume, int4 pos, int volumeComponent, int dimensions, float3 spacing) {
  float f100, f_100, f010 = 0, f0_10 = 0, f001 = 0, f00_1 = 0;
  switch (volumeComponent) {
    case 0:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).x;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).x;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).x;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).x;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).x;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).x;
      }
      break;
    case 1:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).y;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).y;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).y;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).y;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).y;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).y;
      }
      break;
    case 2:
      f100 = read_imagef(volume, pos + (int4)(1, 0, 0, 0)).z;
      f_100 = read_imagef(volume, pos - (int4)(1, 0, 0, 0)).z;
      if (dimensions > 1) {
        f010 = read_imagef(volume, pos + (int4)(0, 1, 0, 0)).z;
        f0_10 = read_imagef(volume, pos - (int4)(0, 1, 0, 0)).z;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, pos + (int4)(0, 0, 1, 0)).z;
        f00_1 = read_imagef(volume, pos - (int4)(0, 0, 1, 0)).z;
      }
      break;
  }

  f100 /= length(read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).xyz);
  f_100 /= length(read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).xyz);
  f010 /= length(read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).xyz);
  f0_10 /= length(read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).xyz);
  f001 /= length(read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).xyz);
  f00_1 /= length(read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).xyz);

  float3 gradient = {(f100 - f_100) / (2.0f), (f010 - f0_10) / (2.0f), (f001 - f00_1) / (2.0f)};
  return gradient;
}

kernel void createVectorField(read_only image3d_t volume,

                              global float* vectorField,

                              private float Fmax, private float vsign, private float spacing_x, private float spacing_y, private float spacing_z) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  float4 F;
  F.xyz = vsign * gradient(volume, pos, 0, 3, (float3)(spacing_x, spacing_y, spacing_z));
  F.w = 0.0f;

  const float l = length(F);
  F = l < Fmax ? F / (Fmax) : F / (l);
  F.w = 1.0f;

  vstore3(F.xyz, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1), vectorField);
}