//{"chances":3,"e_totals":0,"max_inherited_prob":2,"normalizer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_chances(global const double* e_totals, global const long* normalizer, global const long* max_inherited_prob, global long* chances) {
  long i_id = get_global_id(0);
  double score = e_totals[hook(0, i_id)] / (double)normalizer[hook(1, 0)];

  if (e_totals[hook(0, i_id)] == (__builtin_inff())) {
    chances[hook(3, i_id)] = 1;
    return;
  }
  if (score < 0.0) {
    chances[hook(3, i_id)] = max_inherited_prob[hook(2, 0)];
    return;
  }
  double power = log(score);
  if ((long)power < max_inherited_prob[hook(2, 0)]) {
    chances[hook(3, i_id)] = (long)((double)max_inherited_prob[hook(2, 0)] - power);
  } else {
    chances[hook(3, i_id)] = 1;
  }
}