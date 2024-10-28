//{"elements_surrounding_elements":1,"fc_density_energy":7,"fc_momentum_x":4,"fc_momentum_y":5,"fc_momentum_z":6,"ff_fc_density_energy":13,"ff_fc_momentum_x":10,"ff_fc_momentum_y":11,"ff_fc_momentum_z":12,"ff_variable":9,"fluxes":8,"nelr":0,"normals":2,"variables":3}
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

kernel void compute_flux(int nelr, global int* elements_surrounding_elements, global float* normals, global float* variables, global float* fc_momentum_x, global float* fc_momentum_y, global float* fc_momentum_z, global float* fc_density_energy, global float* fluxes, global float* ff_variable, global float3* ff_fc_momentum_x, global float3* ff_fc_momentum_y, global float3* ff_fc_momentum_z, global float3* ff_fc_density_energy) {
  const float smoothing_coefficient = 0.2f;
  const int i = get_global_id(0);

  int j, nb;
  float3 normal;
  float normal_len;
  float factor;

  float density_i = variables[hook(3, i + 0 * nelr)];
  float3 momentum_i;
  momentum_i.x = variables[hook(3, i + (1 + 0) * nelr)];
  momentum_i.y = variables[hook(3, i + (1 + 1) * nelr)];
  momentum_i.z = variables[hook(3, i + (1 + 2) * nelr)];

  float density_energy_i = variables[hook(3, i + (1 + 3) * nelr)];

  float3 velocity_i;
  compute_velocity(density_i, momentum_i, &velocity_i);
  float speed_sqd_i = compute_speed_sqd(velocity_i);
  float speed_i = sqrt(speed_sqd_i);
  float pressure_i = compute_pressure(density_i, density_energy_i, speed_sqd_i);
  float speed_of_sound_i = compute_speed_of_sound(density_i, pressure_i);
  float3 fc_i_momentum_x, fc_i_momentum_y, fc_i_momentum_z;
  float3 fc_i_density_energy;

  fc_i_momentum_x.x = fc_momentum_x[hook(4, i + 0 * nelr)];
  fc_i_momentum_x.y = fc_momentum_x[hook(4, i + 1 * nelr)];
  fc_i_momentum_x.z = fc_momentum_x[hook(4, i + 2 * nelr)];

  fc_i_momentum_y.x = fc_momentum_y[hook(5, i + 0 * nelr)];
  fc_i_momentum_y.y = fc_momentum_y[hook(5, i + 1 * nelr)];
  fc_i_momentum_y.z = fc_momentum_y[hook(5, i + 2 * nelr)];

  fc_i_momentum_z.x = fc_momentum_z[hook(6, i + 0 * nelr)];
  fc_i_momentum_z.y = fc_momentum_z[hook(6, i + 1 * nelr)];
  fc_i_momentum_z.z = fc_momentum_z[hook(6, i + 2 * nelr)];

  fc_i_density_energy.x = fc_density_energy[hook(7, i + 0 * nelr)];
  fc_i_density_energy.y = fc_density_energy[hook(7, i + 1 * nelr)];
  fc_i_density_energy.z = fc_density_energy[hook(7, i + 2 * nelr)];

  float flux_i_density = 0.0f;
  float3 flux_i_momentum;
  flux_i_momentum.x = 0.0f;
  flux_i_momentum.y = 0.0f;
  flux_i_momentum.z = 0.0f;
  float flux_i_density_energy = 0.0f;

  float3 velocity_nb;
  float density_nb, density_energy_nb;
  float3 momentum_nb;
  float3 fc_nb_momentum_x, fc_nb_momentum_y, fc_nb_momentum_z;
  float3 fc_nb_density_energy;
  float speed_sqd_nb, speed_of_sound_nb, pressure_nb;

  for (j = 0; j < 4; j++) {
    nb = elements_surrounding_elements[hook(1, i + j * nelr)];
    normal.x = normals[hook(2, i + (j + 0 * 4) * nelr)];
    normal.y = normals[hook(2, i + (j + 1 * 4) * nelr)];
    normal.z = normals[hook(2, i + (j + 2 * 4) * nelr)];
    normal_len = sqrt(normal.x * normal.x + normal.y * normal.y + normal.z * normal.z);

    if (nb >= 0) {
      density_nb = variables[hook(3, nb + 0 * nelr)];
      momentum_nb.x = variables[hook(3, nb + (1 + 0) * nelr)];
      momentum_nb.y = variables[hook(3, nb + (1 + 1) * nelr)];
      momentum_nb.z = variables[hook(3, nb + (1 + 2) * nelr)];
      density_energy_nb = variables[hook(3, nb + (1 + 3) * nelr)];
      compute_velocity(density_nb, momentum_nb, &velocity_nb);
      speed_sqd_nb = compute_speed_sqd(velocity_nb);
      pressure_nb = compute_pressure(density_nb, density_energy_nb, speed_sqd_nb);
      speed_of_sound_nb = compute_speed_of_sound(density_nb, pressure_nb);

      fc_nb_momentum_x.x = fc_momentum_x[hook(4, nb + 0 * nelr)];
      fc_nb_momentum_x.y = fc_momentum_x[hook(4, nb + 1 * nelr)];
      fc_nb_momentum_x.z = fc_momentum_x[hook(4, nb + 2 * nelr)];

      fc_nb_momentum_y.x = fc_momentum_y[hook(5, nb + 0 * nelr)];
      fc_nb_momentum_y.y = fc_momentum_y[hook(5, nb + 1 * nelr)];
      fc_nb_momentum_y.z = fc_momentum_y[hook(5, nb + 2 * nelr)];

      fc_nb_momentum_z.x = fc_momentum_z[hook(6, nb + 0 * nelr)];
      fc_nb_momentum_z.y = fc_momentum_z[hook(6, nb + 1 * nelr)];
      fc_nb_momentum_z.z = fc_momentum_z[hook(6, nb + 2 * nelr)];

      fc_nb_density_energy.x = fc_density_energy[hook(7, nb + 0 * nelr)];
      fc_nb_density_energy.y = fc_density_energy[hook(7, nb + 1 * nelr)];
      fc_nb_density_energy.z = fc_density_energy[hook(7, nb + 2 * nelr)];

      factor = -normal_len * smoothing_coefficient * 0.5f * (speed_i + sqrt(speed_sqd_nb) + speed_of_sound_i + speed_of_sound_nb);
      flux_i_density += factor * (density_i - density_nb);
      flux_i_density_energy += factor * (density_energy_i - density_energy_nb);
      flux_i_momentum.x += factor * (momentum_i.x - momentum_nb.x);
      flux_i_momentum.y += factor * (momentum_i.y - momentum_nb.y);
      flux_i_momentum.z += factor * (momentum_i.z - momentum_nb.z);

      factor = 0.5f * normal.x;
      flux_i_density += factor * (momentum_nb.x + momentum_i.x);
      flux_i_density_energy += factor * (fc_nb_density_energy.x + fc_i_density_energy.x);
      flux_i_momentum.x += factor * (fc_nb_momentum_x.x + fc_i_momentum_x.x);
      flux_i_momentum.y += factor * (fc_nb_momentum_y.x + fc_i_momentum_y.x);
      flux_i_momentum.z += factor * (fc_nb_momentum_z.x + fc_i_momentum_z.x);

      factor = 0.5f * normal.y;
      flux_i_density += factor * (momentum_nb.y + momentum_i.y);
      flux_i_density_energy += factor * (fc_nb_density_energy.y + fc_i_density_energy.y);
      flux_i_momentum.x += factor * (fc_nb_momentum_x.y + fc_i_momentum_x.y);
      flux_i_momentum.y += factor * (fc_nb_momentum_y.y + fc_i_momentum_y.y);
      flux_i_momentum.z += factor * (fc_nb_momentum_z.y + fc_i_momentum_z.y);

      factor = 0.5f * normal.z;
      flux_i_density += factor * (momentum_nb.z + momentum_i.z);
      flux_i_density_energy += factor * (fc_nb_density_energy.z + fc_i_density_energy.z);
      flux_i_momentum.x += factor * (fc_nb_momentum_x.z + fc_i_momentum_x.z);
      flux_i_momentum.y += factor * (fc_nb_momentum_y.z + fc_i_momentum_y.z);
      flux_i_momentum.z += factor * (fc_nb_momentum_z.z + fc_i_momentum_z.z);
    } else if (nb == -1) {
      flux_i_momentum.x += normal.x * pressure_i;
      flux_i_momentum.y += normal.y * pressure_i;
      flux_i_momentum.z += normal.z * pressure_i;
    } else if (nb == -2) {
      factor = 0.5f * normal.x;
      flux_i_density += factor * (ff_variable[hook(9, 1 + 0)] + momentum_i.x);
      flux_i_density_energy += factor * (ff_fc_density_energy[hook(13, 0)].x + fc_i_density_energy.x);
      flux_i_momentum.x += factor * (ff_fc_momentum_x[hook(10, 0)].x + fc_i_momentum_x.x);
      flux_i_momentum.y += factor * (ff_fc_momentum_y[hook(11, 0)].x + fc_i_momentum_y.x);
      flux_i_momentum.z += factor * (ff_fc_momentum_z[hook(12, 0)].x + fc_i_momentum_z.x);

      factor = 0.5f * normal.y;
      flux_i_density += factor * (ff_variable[hook(9, 1 + 1)] + momentum_i.y);
      flux_i_density_energy += factor * (ff_fc_density_energy[hook(13, 0)].y + fc_i_density_energy.y);
      flux_i_momentum.x += factor * (ff_fc_momentum_x[hook(10, 0)].y + fc_i_momentum_x.y);
      flux_i_momentum.y += factor * (ff_fc_momentum_y[hook(11, 0)].y + fc_i_momentum_y.y);
      flux_i_momentum.z += factor * (ff_fc_momentum_z[hook(12, 0)].y + fc_i_momentum_z.y);

      factor = 0.5f * normal.z;
      flux_i_density += factor * (ff_variable[hook(9, 1 + 2)] + momentum_i.z);
      flux_i_density_energy += factor * (ff_fc_density_energy[hook(13, 0)].z + fc_i_density_energy.z);
      flux_i_momentum.x += factor * (ff_fc_momentum_x[hook(10, 0)].z + fc_i_momentum_x.z);
      flux_i_momentum.y += factor * (ff_fc_momentum_y[hook(11, 0)].z + fc_i_momentum_y.z);
      flux_i_momentum.z += factor * (ff_fc_momentum_z[hook(12, 0)].z + fc_i_momentum_z.z);
    }
  }

  fluxes[hook(8, i + 0 * nelr)] = flux_i_density;
  fluxes[hook(8, i + (1 + 0) * nelr)] = flux_i_momentum.x;
  fluxes[hook(8, i + (1 + 1) * nelr)] = flux_i_momentum.y;
  fluxes[hook(8, i + (1 + 2) * nelr)] = flux_i_momentum.z;
  fluxes[hook(8, i + (1 + 3) * nelr)] = flux_i_density_energy;
}