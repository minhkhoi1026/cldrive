//{"gradient_image":0,"n_segments":2,"output_costs":3,"segments":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct segment {
  float2 midpoint_pixel;
  float2 extent;
};

struct line {
  float2 start, end;
};

inline float lanczos(float x, float a) {
  if (x > fabs(a))
    return 0.f;

  if (fabs(x / a) < 1e-4f)
    return 1.f;

  float k = (a * sinpi(x) * sinpi(x / a)) / (3.14159f * 3.14159f * x * x);
  return k;
}

inline float4 lanczos_sample(read_only image2d_t input, float2 coord) {
  sampler_t nn_sampler = 0 | 2 | 0x10;

  int2 centre = convert_int2(round(coord));
  int a = 2;
  float norm = 0.f;
  float4 sample = (float4)(0.f, 0.f, 0.f, 0.f);

  for (int dx = -a; dx <= a; ++dx) {
    for (int dy = -a; dy <= a; ++dy) {
      int2 pixel_coord = centre + (int2)(dx, dy);
      float2 delta = coord - convert_float2(pixel_coord);

      float k = lanczos(delta.x, a) * lanczos(delta.y, a);

      norm += k;
      sample += k * read_imagef(input, nn_sampler, pixel_coord);
    }
  }

  return sample / norm;
}

void gradient(read_only image2d_t input, int2 coord, float4* dx, float4* dy, float2 pixel_to_linear_scale) {
  sampler_t nn_sampler = 0 | 2 | 0x10;

  float4 l = read_imagef(input, nn_sampler, coord + (int2)(-1, 0));
  float4 r = read_imagef(input, nn_sampler, coord + (int2)(1, 0));
  *dx = (r - l) * (0.5f / pixel_to_linear_scale.x);

  float4 b = read_imagef(input, nn_sampler, coord + (int2)(0, -1));
  float4 t = read_imagef(input, nn_sampler, coord + (int2)(0, 1));
  *dy = (t - b) * (0.5f / pixel_to_linear_scale.y);
}

void lanczos_gradient(read_only image2d_t input, float2 coord, float4* dx, float4* dy, float2 pixel_to_linear_scale) {
  float4 l = lanczos_sample(input, coord + (float2)(-1, 0));
  float4 r = lanczos_sample(input, coord + (float2)(1, 0));
  *dx = (r - l) * (0.5f / pixel_to_linear_scale.x);

  float4 b = lanczos_sample(input, coord + (float2)(0, -1));
  float4 t = lanczos_sample(input, coord + (float2)(0, 1));
  *dy = (t - b) * (0.5f / pixel_to_linear_scale.y);
}

float segment_cost(read_only image2d_t gradient_image, const struct segment seg) {
  float2 midpoint_grad = lanczos_sample(gradient_image, seg.midpoint_pixel).xy;
  float2 direction = normalize(seg.extent);
  float midpoint_slope = dot(direction, midpoint_grad);

  float seg_length = length(seg.extent);
  float vertical_disp = midpoint_slope * seg_length;
  float euc_distance = length((float4)(direction * seg_length, vertical_disp, 0.f));

  return euc_distance;
}

float line_cost(read_only image2d_t gradient_image, const float2 start, const float2 end, float2 pixel_linear_scale) {
  float2 delta = end - start;

  float delta_len = length(delta);
  delta = normalize(delta);

  float cost = 0.f;
  float2 last_seg_end = start;
  for (float alpha = 0.f; alpha < delta_len; alpha += 1.f) {
    float2 seg_start = last_seg_end;
    float2 seg_end = min(alpha + 1.f, delta_len) * delta + start;
    float2 midpoint = 0.5f * (seg_end - seg_start);
    float2 extent = (seg_end - seg_start) * pixel_linear_scale;

    struct segment seg = {
        .midpoint_pixel = midpoint,
        .extent = extent,
    };
    cost += segment_cost(gradient_image, seg);

    last_seg_end = seg_end;
  }

  return cost;
}

kernel void segment_costs(read_only image2d_t gradient_image, global struct segment* segments, const int n_segments, global float* output_costs) {
  const int idx = get_global_id(0);
  if (idx >= n_segments)
    return;
  output_costs[hook(3, idx)] = segment_cost(gradient_image, segments[hook(1, idx)]);
}