//{"Input":0,"Output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Diffusivity_32f(global float* Input, global float* Output) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int tempminus_x = 0;
  int tempplus_x = 0;
  int tempminus_y = 0;
  int tempplus_y = 0;
  int tempminus_z = 0;
  int tempplus_z = 0;

  int linear_coord = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;

  int linear_coord_minus_one_x = tempminus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_x = tempplus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_minus_one_y = i + get_global_size(2) * (tempminus_y) + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_y = i + get_global_size(2) * (tempplus_y) + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_minus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempminus_z);
  int linear_coord_plus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempplus_z);

  float d_xminus1 = 0;
  float d_xplus1 = 0;
  float d_yminus1 = 0;
  float d_yplus1 = 0;
  float d_zminus1 = 0;
  float d_zplus1 = 0;

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

  float d = Input[hook(0, linear_coord)];
  d_xminus1 = Input[hook(0, linear_coord_minus_one_x)];
  d_xplus1 = Input[hook(0, linear_coord_plus_one_x)];
  d_yminus1 = Input[hook(0, linear_coord_minus_one_y)];
  d_yplus1 = Input[hook(0, linear_coord_plus_one_y)];
  d_zminus1 = Input[hook(0, linear_coord_minus_one_z)];
  d_zplus1 = Input[hook(0, linear_coord_plus_one_z)];

  float temp = sqrt(pow((d_xplus1 - d_xminus1), 2) + pow((d_yplus1 - d_yminus1), 2) + pow((d_zplus1 - d_zminus1), 2));

  temp = pow(temp / 100, 2);
  temp = exp(-temp);

  Output[hook(1, linear_coord)] = temp;
}