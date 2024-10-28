//{"Diffusivity":1,"Out":3,"Raw":0,"deltaT":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AnisotropicFilter_32f(global float* Raw, global float* Diffusivity, float deltaT, global float* Out) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  float r_xminus1 = 0;
  float r_xplus1 = 0;
  float r_yminus1 = 0;
  float r_yplus1 = 0;
  float r_zminus1 = 0;
  float r_zplus1 = 0;

  float d_xminus1 = 0;
  float d_xplus1 = 0;
  float d_yminus1 = 0;
  float d_yplus1 = 0;
  float d_zminus1 = 0;
  float d_zplus1 = 0;

  int tempminus_x = 0;
  int tempplus_x = 0;
  int tempminus_y = 0;
  int tempplus_y = 0;
  int tempminus_z = 0;
  int tempplus_z = 0;

  int linear_coord = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  float final = 0;

  if (i - 1 < 0) {
    tempminus_x = i;
  } else {
    tempminus_x = i - 1;
  }

  if (i + 1 >= get_global_size(2)) {
    tempplus_x = i;
  } else {
    tempplus_x = i + 1;
  }

  if (j - 1 < 0) {
    tempminus_y = j;
  } else {
    tempminus_y = j - 1;
  }

  if (j + 1 >= get_global_size(1)) {
    tempplus_y = j;
  } else {
    tempplus_y = j + 1;
  }

  if (k - 1 < 0) {
    tempminus_z = k;
  } else {
    tempminus_z = k - 1;
  }

  if (k + 1 >= get_global_size(0)) {
    tempplus_z = k;
  } else {
    tempplus_z = k + 1;
  }

  float r = Raw[hook(0, linear_coord)];
  float d = Diffusivity[hook(1, linear_coord)];

  int linear_coord_minus_one_x = tempminus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_x = tempplus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  r_xminus1 = Raw[hook(0, linear_coord_minus_one_x)] - r;
  r_xplus1 = Raw[hook(0, linear_coord_plus_one_x)] - r;
  d_xminus1 = Diffusivity[hook(1, linear_coord_minus_one_x)];
  d_xplus1 = Diffusivity[hook(1, linear_coord_plus_one_x)];

  int linear_coord_minus_one_y = i + get_global_size(2) * (tempminus_y) + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_y = i + get_global_size(2) * (tempplus_y) + get_global_size(2) * get_global_size(1) * k;
  r_yminus1 = Raw[hook(0, linear_coord_minus_one_y)] - r;
  r_yplus1 = Raw[hook(0, linear_coord_plus_one_y)] - r;
  d_yminus1 = Diffusivity[hook(1, linear_coord_minus_one_y)];
  d_yplus1 = Diffusivity[hook(1, linear_coord_plus_one_y)];

  int linear_coord_minus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempminus_z);
  int linear_coord_plus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempplus_z);
  r_zminus1 = Raw[hook(0, linear_coord_minus_one_z)] - r;
  r_zplus1 = Raw[hook(0, linear_coord_plus_one_z)] - r;
  d_zminus1 = Diffusivity[hook(1, linear_coord_minus_one_z)];
  d_zplus1 = Diffusivity[hook(1, linear_coord_plus_one_z)];

  float divergence = r_xplus1 * d_xplus1 + r_xminus1 * d_xminus1 + r_yplus1 * d_yplus1 + r_yminus1 * d_yminus1 + r_zplus1 * d_zplus1 + r_zminus1 * d_zminus1;

  final = r + deltaT * divergence;

  Out[hook(3, linear_coord)] = final;
}