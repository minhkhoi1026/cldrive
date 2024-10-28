//{"chances":1,"chances_sum":14,"crossover_probability":8,"crossover_rotation_mode":7,"crossover_translation_mode":6,"dist_grid":13,"dna1":15,"dna2":16,"dna_size":4,"individuals":5,"lo_grid":12,"mutation_chance":9,"mutation_probability":10,"new_individuals":17,"population_size":0,"reproduction_rns":3,"ttl_reproduction_rns":2,"ttl_torsions":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reproduce(global const long* population_size, global const long* chances, global const long* ttl_reproduction_rns, global const double* reproduction_rns, global const long* dna_size, global const double* individuals, global const long* crossover_translation_mode, global const long* crossover_rotation_mode, global const double* crossover_probability, global const double* mutation_chance, global const double* mutation_probability, global const long* ttl_torsions, global const double* lo_grid, global const double* dist_grid, global long* chances_sum, global double* dna1, global double* dna2, global double* new_individuals) {
  long i_id = get_global_id(0);

  long ttl_chances = 0;
  for (long i = 0; i < population_size[hook(0, 0)]; i++) {
    ttl_chances += chances[hook(1, i)];

    chances_sum[hook(14, i)] = ttl_chances;
  }
  ttl_chances += 1;

  long start_r_rns_idx = i_id * ttl_reproduction_rns[hook(2, 0)];
  long p1_loc = (long)(reproduction_rns[hook(3, start_r_rns_idx + 0)] * ttl_chances);
  long p2_loc = (long)(reproduction_rns[hook(3, start_r_rns_idx + 1)] * ttl_chances);

  if (p2_loc < p1_loc) {
    long ptmp_loc = p1_loc;
    p1_loc = p2_loc;
    p2_loc = ptmp_loc;
  }

  long p1_id, p2_id;
  for (long i = 0; i < population_size[hook(0, 0)]; i++) {
    if (p1_loc <= chances_sum[hook(14, i)]) {
      p1_id = i;
      break;
    }
  }
  for (long i = p1_id; i < population_size[hook(0, 0)]; i++) {
    if (p2_loc <= chances_sum[hook(14, i)]) {
      p2_id = i;
      break;
    }
  }

  long start_src_idx;
  start_src_idx = p1_id * dna_size[hook(4, 0)];
  long start_dna_idx = i_id * dna_size[hook(4, 0)];
  for (long i = 0; i < dna_size[hook(4, 0)]; i++) {
    dna1[hook(15, start_dna_idx + i)] = individuals[hook(5, start_src_idx + i)];
  }
  start_src_idx = p2_id * dna_size[hook(4, 0)];
  for (long i = 0; i < dna_size[hook(4, 0)]; i++) {
    dna2[hook(16, start_dna_idx + i)] = individuals[hook(5, start_src_idx + i)];
  }
  long start_dst_idx = i_id * dna_size[hook(4, 0)];

  if (p1_id != p2_id) {
    if (crossover_translation_mode[hook(6, 0)] == (long)0) {
      if (new_individuals[hook(17, start_dst_idx + 0)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 0)] = dna2[hook(16, start_dna_idx + 0)];
      }
      if (new_individuals[hook(17, start_dst_idx + 1)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 1)] = dna2[hook(16, start_dna_idx + 1)];
      }
      if (new_individuals[hook(17, start_dst_idx + 2)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 2)] = dna2[hook(16, start_dna_idx + 2)];
      }
    } else {
      if (new_individuals[hook(17, start_dst_idx + 0)] > crossover_probability[hook(8, 0)]) {
        for (long i = 0; i < 3; i++) {
          dna1[hook(15, start_dna_idx + 0 + i)] = dna2[hook(16, start_dna_idx + 0 + i)];
        }
      }
    }

    if (crossover_rotation_mode[hook(7, 0)] == (long)0) {
      if (new_individuals[hook(17, start_dst_idx + 3)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 3)] = dna2[hook(16, start_dna_idx + 3)];
      }
      if (new_individuals[hook(17, start_dst_idx + 4)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 4)] = dna2[hook(16, start_dna_idx + 4)];
      }
      if (new_individuals[hook(17, start_dst_idx + 5)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 5)] = dna2[hook(16, start_dna_idx + 5)];
      }
      if (new_individuals[hook(17, start_dst_idx + 6)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 6)] = dna2[hook(16, start_dna_idx + 6)];
      }
    } else {
      if (new_individuals[hook(17, start_dst_idx + 3)] > crossover_probability[hook(8, 0)]) {
        for (long i = 0; i < 4; i++) {
          dna1[hook(15, start_dna_idx + 3 + i)] = dna2[hook(16, start_dna_idx + 3 + i)];
        }
      }
    }

    for (long i = 0; i < ttl_torsions[hook(11, 0)]; i++) {
      if (new_individuals[hook(17, start_dst_idx + 7 + i)] > crossover_probability[hook(8, 0)]) {
        dna1[hook(15, start_dna_idx + 7 + i)] = dna2[hook(16, start_dna_idx + 7 + i)];
      }
    }
  }

  if (reproduction_rns[hook(3, start_r_rns_idx + 2)] < mutation_chance[hook(9, 0)]) {
    double two_pi = 2 * 3.14159265358979323846f;

    if (reproduction_rns[hook(3, start_r_rns_idx + 3)] < mutation_probability[hook(10, 0)]) {
      dna1[hook(15, start_dna_idx + 0)] = lo_grid[hook(12, 0)] + (reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 0))] * dist_grid[hook(13, 0)]);
      dna1[hook(15, start_dna_idx + 1)] = lo_grid[hook(12, 1)] + (reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 1))] * dist_grid[hook(13, 1)]);
      dna1[hook(15, start_dna_idx + 2)] = lo_grid[hook(12, 2)] + (reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 2))] * dist_grid[hook(13, 2)]);
    }

    if (reproduction_rns[hook(3, start_r_rns_idx + 4)] < mutation_probability[hook(10, 0)]) {
      double x0 = reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 3))];

      double t1 = reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 4))] * two_pi;

      double t2 = reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 5))] * two_pi;
      double r1 = sqrt(1.0 - x0);
      double r2 = sqrt(x0);
      dna1[hook(15, start_dna_idx + 4)] = sin(t1) * r1;
      dna1[hook(15, start_dna_idx + 5)] = cos(t1) * r1;
      dna1[hook(15, start_dna_idx + 6)] = sin(t2) * r2;
      dna1[hook(15, start_dna_idx + 3)] = cos(t2) * r2;
    }

    for (long i = 0; i < ttl_torsions[hook(11, 0)]; i++) {
      if (reproduction_rns[hook(3, start_r_rns_idx + 5 + i)] < mutation_probability[hook(10, 0)]) {
        dna1[hook(15, start_dna_idx + 7 + i)] = (reproduction_rns[hook(3, start_r_rns_idx + (5 + ttl_torsions[0hook(11, 0) + 7) + i)] - 0.5) * two_pi;
      }
    }
  }

  for (long i = 0; i < dna_size[hook(4, 0)]; i++) {
    new_individuals[hook(17, start_dst_idx + i)] = dna1[hook(15, start_dna_idx + i)];
  }
}