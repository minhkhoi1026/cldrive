//{"R":7,"T":1,"arms":5,"eigenVectors":12,"eigenVectors[0]":11,"eigenVectors[1]":13,"eigenVectors[2]":14,"maxRadius":15,"minAverageMag":6,"rMax":3,"rMin":2,"rStep":4,"spacing_x":8,"spacing_y":9,"spacing_z":10,"vectorField":0}
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

kernel void nonCircularTDF(read_only image3d_t vectorField, global float* T, private float rMin, private float rMax, private float rStep, private const int arms, private const float minAverageMag, global float* R, private float spacing_x, private float spacing_y, private float spacing_z) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const float3 spacing = {spacing_x, spacing_y, spacing_z};
  char invalid = 0;

  const float3 Fx = gradientNormalized(vectorField, pos, 0, 1, spacing);
  const float3 Fy = gradientNormalized(vectorField, pos, 1, 2, spacing);
  const float3 Fz = gradientNormalized(vectorField, pos, 2, 3, spacing);

  float Hessian[3][3] = {{Fx.x, Fy.x, Fz.x}, {Fy.x, Fy.y, Fz.y}, {Fz.x, Fz.y, Fz.z}};

  float eigenValues[3];
  float eigenVectors[3][3];
  eigen_decomposition(Hessian, eigenVectors, eigenValues);
  const float3 e1 = {eigenVectors[hook(12, 0)][hook(11, 0)], eigenVectors[hook(12, 1)][hook(13, 0)], eigenVectors[hook(12, 2)][hook(14, 0)]};
  const float3 e2 = {eigenVectors[hook(12, 0)][hook(11, 1)], eigenVectors[hook(12, 1)][hook(13, 1)], eigenVectors[hook(12, 2)][hook(14, 1)]};
  const float3 e3 = {eigenVectors[hook(12, 0)][hook(11, 2)], eigenVectors[hook(12, 1)][hook(13, 2)], eigenVectors[hook(12, 2)][hook(14, 2)]};

  float currentVoxelMagnitude = length(read_imagef(vectorField, sampler, pos).xyz);

  float maxRadius[12];
  float sum = 0.0f;

  float largestRadius = 0;
  for (char j = 0; j < arms; ++j) {
    maxRadius[hook(15, j)] = 999;
    float alpha = 2 * 3.14159265358979323846264338327950288f * j / arms;
    float4 V_alpha = cos(alpha) * e3.xyzz + sin(alpha) * e2.xyzz;
    float prevMagnitude2 = currentVoxelMagnitude;
    float4 position = convert_float4(pos) + rMin * V_alpha;
    float prevMagnitude = length(read_imagef(vectorField, interpolationSampler, position).xyz);
    char up = prevMagnitude2 > prevMagnitude ? 0 : 1;

    for (float radius = rMin + rStep; radius <= rMax; radius += rStep) {
      position = convert_float4(pos) + radius * V_alpha;
      float4 vec = read_imagef(vectorField, interpolationSampler, position);
      vec.w = 0.0f;
      float magnitude = length(vec.xyz);

      if (up == 1 && magnitude < prevMagnitude && (prevMagnitude + magnitude) / 2.0f - currentVoxelMagnitude > minAverageMag) {
        maxRadius[hook(15, j)] = radius;
        if (radius > largestRadius)
          largestRadius = radius;
        if (dot(normalize(vec.xyz), -normalize(V_alpha.xyz)) < 0.0f) {
          invalid = 1;
          sum = 0.0f;
        }
        sum += 1.0f - fabs(dot(normalize(vec.xyz), e1));
        break;
      }

      if (magnitude > prevMagnitude) {
        up = 1;
      }
      prevMagnitude = magnitude;
    }

    if (maxRadius[hook(15, j)] == 999 || invalid == 1) {
      invalid = 1;
      break;
    }
  }

  if (invalid != 1) {
    float avgSymmetry = 0.0f;
    for (char j = 0; j < arms / 2; ++j) {
      avgSymmetry += min(maxRadius[hook(15, j)], maxRadius[hook(15, arms / 2 + j)]) / max(maxRadius[hook(15, j)], maxRadius[hook(15, arms / 2 + j)]);
    }
    avgSymmetry /= arms / 2;
    R[hook(7, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = largestRadius;
    T[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = min(1.0f, (sum / (arms)) * avgSymmetry + 0.2f);
  } else {
    R[hook(7, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
    T[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
  }
}