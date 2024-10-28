//{"duration":4,"from_vec":0,"positions":2,"time":3,"to_vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float quad_ease_in_out(float t, float b, float c, float d) {
  float inner_t = t / (d / 2.0f);

  if (inner_t < 1.0f) {
    return (c / 2.0f * (pow(inner_t, 2))) + b;
  }

  float temp = inner_t - 1.0f;
  return (-c / 2.0f * (((inner_t - 2.0f) * (temp)) - 1.0f) + b);
}

float back_ease_out(float t, float b, float c, float d) {
  float s = 1.70158f;
  float inner_t = (t / d) - 1.0f;
  return (c * (inner_t * inner_t * ((s + 1.0f) * inner_t + s) + 1.0f) + b);
}

float elastic_ease_out(float t, float b, float c, float d) {
  if (t == 0.0f) {
    return b;
  }

  float inner_t = t / d;
  if (inner_t == 1.0f) {
    return b + c;
  }

  float p = d * 0.3f;
  float a = c;
  float s = p / 4.0f;
  float temp = (inner_t * d - s) * (2.0f * 3.14159265358979323846264338327950288f) / p;
  return (a * pow(2.0f, -10.0f * inner_t) * sin(temp) + c + b);
}

kernel void update_animation(global float3 const* const restrict from_vec, global float3 const* const restrict to_vec, global float3* const restrict positions, float time, float duration) {
  size_t const idx = get_global_id(0);
  float3 const from = from_vec[hook(0, idx)];
  float3 const to = to_vec[hook(1, idx)];

  positions[hook(2, idx)] = (float3)(elastic_ease_out(time, from.x, to.x - from.x, duration), elastic_ease_out(time, from.y, to.y - from.y, duration), elastic_ease_out(time, from.z, to.z - from.z, duration));
}