//{"Radius":5,"T":1,"cosValues":13,"eigenVectors":10,"eigenVectors[0]":9,"eigenVectors[1]":11,"eigenVectors[2]":12,"rMax":3,"rMin":2,"rStep":4,"sinValues":14,"spacing_x":6,"spacing_y":7,"spacing_z":8,"vectorField":0}
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

void eigen_decomposition(float M[3][3], float V[3][3], float e[3]);

constant float cosValues[32] = {1.0f, 0.540302f, -0.416147f, -0.989992f, -0.653644f, 0.283662f, 0.96017f, 0.753902f, -0.1455f, -0.91113f, -0.839072f, 0.0044257f, 0.843854f, 0.907447f, 0.136737f, -0.759688f, -0.957659f, -0.275163f, 0.660317f, 0.988705f, 0.408082f, -0.547729f, -0.999961f, -0.532833f, 0.424179f, 0.991203f, 0.646919f, -0.292139f, -0.962606f, -0.748058f, 0.154251f, 0.914742f};
constant float sinValues[32] = {0.0f, 0.841471f, 0.909297f, 0.14112f, -0.756802f, -0.958924f, -0.279415f, 0.656987f, 0.989358f, 0.412118f, -0.544021f, -0.99999f, -0.536573f, 0.420167f, 0.990607f, 0.650288f, -0.287903f, -0.961397f, -0.750987f, 0.149877f, 0.912945f, 0.836656f, -0.00885131f, -0.84622f, -0.905578f, -0.132352f, 0.762558f, 0.956376f, 0.270906f, -0.663634f, -0.988032f, -0.404038f};

kernel void circleFittingTDF(read_only image3d_t vectorField, global float* T, private float rMin, private float rMax, private float rStep, global float* Radius, private float spacing_x, private float spacing_y, private float spacing_z) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const float3 spacing = {spacing_x, spacing_y, spacing_z};

  float3 Fx, Fy, Fz;
  if (rMax < 4) {
    Fx = gradient(vectorField, pos, 0, 1, spacing);
    Fy = gradient(vectorField, pos, 1, 2, spacing);
    Fz = gradient(vectorField, pos, 2, 3, spacing);
  } else {
    Fx = gradientNormalized(vectorField, pos, 0, 1, spacing);
    Fy = gradientNormalized(vectorField, pos, 1, 2, spacing);
    Fz = gradientNormalized(vectorField, pos, 2, 3, spacing);
  }

  float Hessian[3][3] = {{Fx.x, Fy.x, Fz.x}, {Fy.x, Fy.y, Fz.y}, {Fz.x, Fz.y, Fz.z}};

  float eigenValues[3];
  float eigenVectors[3][3];
  eigen_decomposition(Hessian, eigenVectors, eigenValues);

  const float3 e2 = {eigenVectors[hook(10, 0)][hook(9, 1)], eigenVectors[hook(10, 1)][hook(11, 1)], eigenVectors[hook(10, 2)][hook(12, 1)]};
  const float3 e3 = {eigenVectors[hook(10, 0)][hook(9, 2)], eigenVectors[hook(10, 1)][hook(11, 2)], eigenVectors[hook(10, 2)][hook(12, 2)]};

  float maxSum = 0.0f;
  float maxRadius = 0.0f;
  const float4 floatPos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  for (float radius = rMin; radius <= rMax; radius += rStep) {
    float radiusSum = 0.0f;
    char samples = 32;
    char stride = 1;

    for (char j = 0; j < samples; ++j) {
      float3 V_alpha = cosValues[hook(13, j * stride)] * e3 + sinValues[hook(14, j * stride)] * e2;
      float4 position = floatPos + radius * V_alpha.xyzz;
      float3 V = -read_imagef(vectorField, interpolationSampler, position).xyz;
      radiusSum += dot(V, V_alpha);
    }
    radiusSum /= samples;
    if (radiusSum > maxSum) {
      maxSum = radiusSum;
      maxRadius = radius;
    } else {
      break;
    }
  }

  T[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = maxSum;
  Radius[hook(5, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = maxRadius;
}