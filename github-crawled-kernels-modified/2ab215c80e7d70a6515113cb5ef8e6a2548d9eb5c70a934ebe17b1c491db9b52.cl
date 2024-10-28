//{"areas":2,"nelr":0,"step_factors":3,"variables":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void compute_flux_contribution(private float* density, private float3* momentum, private float* density_energy, float pressure, private float3* velocity, private float3* fc_momentum_x, private float3* fc_momentum_y, private float3* fc_momentum_z, private float3* fc_density_energy) {
  (*fc_momentum_x).x = (*velocity).x * (*momentum).x + pressure;
  (*fc_momentum_x).y = (*velocity).x * (*momentum).y;
  (*fc_momentum_x).z = (*velocity).x * (*momentum).z;

  (*fc_momentum_y).x = (*fc_momentum_x).y;
  (*fc_momentum_y).y = (*velocity).y * (*momentum).y + pressure;
  (*fc_momentum_y).z = (*velocity).y * (*momentum).z;

  (*fc_momentum_z).x = (*fc_momentum_x).z;
  (*fc_momentum_z).y = (*fc_momentum_y).z;
  (*fc_momentum_z).z = (*velocity).z * (*momentum).z + pressure;

  float de_p = *density_energy + pressure;
  (*fc_density_energy).x = (*velocity).x * de_p;
  (*fc_density_energy).y = (*velocity).y * de_p;
  (*fc_density_energy).z = (*velocity).z * de_p;
}

void compute_velocity(float density, float3 momentum, private float3* velocity) {
  (*velocity).x = momentum.x / density;
  (*velocity).y = momentum.y / density;
  (*velocity).z = momentum.z / density;
}

float compute_speed_of_sound(float density, float pressure) {
  return sqrt(1.4f * pressure / density);
}

float compute_speed_sqd(float3 velocity) {
  return velocity.x * velocity.x + velocity.y * velocity.y + velocity.z * velocity.z;
}

float compute_pressure(float density, float density_energy, float speed_sqd) {
  return (1.4f - 1.0f) * (density_energy - 0.5f * density * speed_sqd);
}

kernel void compute_step_factor(int nelr, global float* variables, global float* areas, global float* step_factors) {
  const int i = get_global_id(0);

  float density = variables[hook(1, i + 0 * nelr)];
  float3 momentum;
  momentum.x = variables[hook(1, i + (1 + 0) * nelr)];
  momentum.y = variables[hook(1, i + (1 + 1) * nelr)];
  momentum.z = variables[hook(1, i + (1 + 2) * nelr)];

  float density_energy = variables[hook(1, i + (1 + 3) * nelr)];

  float3 velocity;
  compute_velocity(density, momentum, &velocity);
  float speed_sqd = compute_speed_sqd(velocity);
  float pressure = compute_pressure(density, density_energy, speed_sqd);
  float speed_of_sound = compute_speed_of_sound(density, pressure);

  step_factors[hook(3, i)] = 0.5f / (sqrt(areas[hook(2, i)]) * (sqrt(speed_sqd) + speed_of_sound));
}