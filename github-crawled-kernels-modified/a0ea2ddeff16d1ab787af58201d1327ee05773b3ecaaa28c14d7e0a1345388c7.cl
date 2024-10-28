//{"block_counts":2,"distances":28,"in":7,"in[i]":13,"in[j]":16,"input":0,"max_block_count":4,"out":6,"out[i]":17,"out[j]":12,"positions":31,"ref":30,"ref[y]":29,"res":15,"res[0]":18,"res[1]":20,"res[2]":22,"res[3]":24,"res[4]":25,"res[5]":23,"res[6]":21,"res[7]":19,"res[j]":14,"similar_coords":1,"st1":11,"st2":8,"st3":9,"st4":10,"threshold":3,"window_step_size":5,"x":27,"y":26}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void dct(const float in[8], float out[8], bool normalize) {
  float st2[8], st3[2];
  float tmp;

  out[hook(6, 0)] = in[hook(7, 0)] + in[hook(7, 7)];
  out[hook(6, 1)] = in[hook(7, 1)] + in[hook(7, 6)];
  out[hook(6, 2)] = in[hook(7, 2)] + in[hook(7, 5)];
  out[hook(6, 3)] = in[hook(7, 3)] + in[hook(7, 4)];

  out[hook(6, 4)] = in[hook(7, 3)] - in[hook(7, 4)];
  out[hook(6, 5)] = in[hook(7, 2)] - in[hook(7, 5)];
  out[hook(6, 6)] = in[hook(7, 1)] - in[hook(7, 6)];
  out[hook(6, 7)] = in[hook(7, 0)] - in[hook(7, 7)];

  st2[hook(8, 0)] = out[hook(6, 0)] + out[hook(6, 3)];
  st2[hook(8, 1)] = out[hook(6, 1)] + out[hook(6, 2)];
  st2[hook(8, 2)] = out[hook(6, 1)] - out[hook(6, 2)];
  st2[hook(8, 3)] = out[hook(6, 0)] - out[hook(6, 3)];

  tmp = 0.83146961230254523707878837761791f * (out[hook(6, 4)] + out[hook(6, 7)]);

  st2[hook(8, 4)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * out[hook(6, 7)];
  st2[hook(8, 7)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * out[hook(6, 4)];

  tmp = 0.98078528040323044912618223613424f * (out[hook(6, 5)] + out[hook(6, 6)]);

  st2[hook(8, 5)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * out[hook(6, 6)];
  st2[hook(8, 6)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * out[hook(6, 5)];

  out[hook(6, 0)] = st2[hook(8, 0)] + st2[hook(8, 1)];
  out[hook(6, 4)] = st2[hook(8, 0)] - st2[hook(8, 1)];

  tmp = 0.54119610014619698439972320536639f * (st2[hook(8, 2)] + st2[hook(8, 3)]);

  out[hook(6, 2)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * st2[hook(8, 3)];
  out[hook(6, 6)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * st2[hook(8, 2)];

  st3[hook(9, 0)] = st2[hook(8, 4)] + st2[hook(8, 6)];
  st3[hook(9, 1)] = st2[hook(8, 5)] + st2[hook(8, 7)];
  out[hook(6, 3)] = st2[hook(8, 7)] - st2[hook(8, 5)];
  out[hook(6, 5)] = st2[hook(8, 4)] - st2[hook(8, 6)];

  out[hook(6, 7)] = st3[hook(9, 1)] - st3[hook(9, 0)];
  out[hook(6, 3)] *= 1.41421356237309504880168872420969808f;
  out[hook(6, 5)] *= 1.41421356237309504880168872420969808f;
  out[hook(6, 1)] = st3[hook(9, 0)] + st3[hook(9, 1)];

  if (normalize)
    for (int i = 0; i < 8; i++)
      out[hook(6, i)] *= 0.35355339059327376220042218105242f;
}

inline void idct(const float in[8], float out[8], bool normalize) {
  float st1[8], st4[2];
  float tmp;

  st4[hook(10, 0)] = in[hook(7, 1)] - in[hook(7, 7)];
  st1[hook(11, 5)] = in[hook(7, 3)] * 1.41421356237309504880168872420969808f;
  st1[hook(11, 6)] = in[hook(7, 5)] * 1.41421356237309504880168872420969808f;
  st4[hook(10, 1)] = in[hook(7, 1)] + in[hook(7, 7)];

  out[hook(6, 0)] = in[hook(7, 0)] + in[hook(7, 4)];
  out[hook(6, 1)] = in[hook(7, 0)] - in[hook(7, 4)];

  tmp = 0.54119610014619698439972320536639f * (in[hook(7, 2)] + in[hook(7, 6)]);

  out[hook(6, 2)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * in[hook(7, 6)];
  out[hook(6, 3)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * in[hook(7, 2)];

  out[hook(6, 4)] = st4[hook(10, 0)] + st1[hook(11, 6)];
  out[hook(6, 5)] = st4[hook(10, 1)] - st1[hook(11, 5)];
  out[hook(6, 6)] = st4[hook(10, 0)] - st1[hook(11, 6)];
  out[hook(6, 7)] = st1[hook(11, 5)] + st4[hook(10, 1)];

  st1[hook(11, 0)] = out[hook(6, 0)] + out[hook(6, 3)];
  st1[hook(11, 1)] = out[hook(6, 1)] + out[hook(6, 2)];
  st1[hook(11, 2)] = out[hook(6, 1)] - out[hook(6, 2)];
  st1[hook(11, 3)] = out[hook(6, 0)] - out[hook(6, 3)];

  tmp = 0.83146961230254523707878837761791f * (out[hook(6, 4)] + out[hook(6, 7)]);

  st1[hook(11, 4)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * out[hook(6, 7)];
  st1[hook(11, 7)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * out[hook(6, 4)];

  tmp = 0.98078528040323044912618223613424f * (out[hook(6, 5)] + out[hook(6, 6)]);

  st1[hook(11, 5)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * out[hook(6, 6)];
  st1[hook(11, 6)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * out[hook(6, 5)];

  out[hook(6, 0)] = st1[hook(11, 0)] + st1[hook(11, 7)];
  out[hook(6, 1)] = st1[hook(11, 1)] + st1[hook(11, 6)];
  out[hook(6, 2)] = st1[hook(11, 2)] + st1[hook(11, 5)];
  out[hook(6, 3)] = st1[hook(11, 3)] + st1[hook(11, 4)];

  out[hook(6, 4)] = st1[hook(11, 3)] - st1[hook(11, 4)];
  out[hook(6, 5)] = st1[hook(11, 2)] - st1[hook(11, 5)];
  out[hook(6, 6)] = st1[hook(11, 1)] - st1[hook(11, 6)];
  out[hook(6, 7)] = st1[hook(11, 0)] - st1[hook(11, 7)];

  if (normalize)
    for (int i = 0; i < 8; i++)
      out[hook(6, i)] *= 0.35355339059327376220042218105242f;
}

inline void transpose(float in[8][8], float out[8][8]) {
  int i, j;
  for (j = 0; j < 8; j++) {
    for (i = 0; i < 8; i++) {
      out[hook(6, j)][hook(12, i)] = in[hook(7, i)][hook(13, j)];
    }
  }
}

inline void dct2(float in[8][8], float out[8][8]) {
  int i, j;

  float res[8][8];

  for (j = 0; j < 8; j++) {
    float st2[8], st3[2];
    float tmp;

    res[hook(15, j)][hook(14, 0)] = in[hook(7, j)][hook(16, 0)] + in[hook(7, j)][hook(16, 7)];
    res[hook(15, j)][hook(14, 1)] = in[hook(7, j)][hook(16, 1)] + in[hook(7, j)][hook(16, 6)];
    res[hook(15, j)][hook(14, 2)] = in[hook(7, j)][hook(16, 2)] + in[hook(7, j)][hook(16, 5)];
    res[hook(15, j)][hook(14, 3)] = in[hook(7, j)][hook(16, 3)] + in[hook(7, j)][hook(16, 4)];

    res[hook(15, j)][hook(14, 4)] = in[hook(7, j)][hook(16, 3)] - in[hook(7, j)][hook(16, 4)];
    res[hook(15, j)][hook(14, 5)] = in[hook(7, j)][hook(16, 2)] - in[hook(7, j)][hook(16, 5)];
    res[hook(15, j)][hook(14, 6)] = in[hook(7, j)][hook(16, 1)] - in[hook(7, j)][hook(16, 6)];
    res[hook(15, j)][hook(14, 7)] = in[hook(7, j)][hook(16, 0)] - in[hook(7, j)][hook(16, 7)];

    st2[hook(8, 0)] = res[hook(15, j)][hook(14, 0)] + res[hook(15, j)][hook(14, 3)];
    st2[hook(8, 1)] = res[hook(15, j)][hook(14, 1)] + res[hook(15, j)][hook(14, 2)];
    st2[hook(8, 2)] = res[hook(15, j)][hook(14, 1)] - res[hook(15, j)][hook(14, 2)];
    st2[hook(8, 3)] = res[hook(15, j)][hook(14, 0)] - res[hook(15, j)][hook(14, 3)];

    tmp = 0.83146961230254523707878837761791f * (res[hook(15, j)][hook(14, 4)] + res[hook(15, j)][hook(14, 7)]);

    st2[hook(8, 4)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * res[hook(15, j)][hook(14, 7)];
    st2[hook(8, 7)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * res[hook(15, j)][hook(14, 4)];

    tmp = 0.98078528040323044912618223613424f * (res[hook(15, j)][hook(14, 5)] + res[hook(15, j)][hook(14, 6)]);

    st2[hook(8, 5)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * res[hook(15, j)][hook(14, 6)];
    st2[hook(8, 6)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * res[hook(15, j)][hook(14, 5)];

    res[hook(15, j)][hook(14, 0)] = st2[hook(8, 0)] + st2[hook(8, 1)];
    res[hook(15, j)][hook(14, 4)] = st2[hook(8, 0)] - st2[hook(8, 1)];

    tmp = 0.54119610014619698439972320536639f * (st2[hook(8, 2)] + st2[hook(8, 3)]);

    res[hook(15, j)][hook(14, 2)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * st2[hook(8, 3)];
    res[hook(15, j)][hook(14, 6)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * st2[hook(8, 2)];

    st3[hook(9, 0)] = st2[hook(8, 4)] + st2[hook(8, 6)];
    st3[hook(9, 1)] = st2[hook(8, 5)] + st2[hook(8, 7)];
    res[hook(15, j)][hook(14, 3)] = st2[hook(8, 7)] - st2[hook(8, 5)];
    res[hook(15, j)][hook(14, 5)] = st2[hook(8, 4)] - st2[hook(8, 6)];

    res[hook(15, j)][hook(14, 7)] = st3[hook(9, 1)] - st3[hook(9, 0)];
    res[hook(15, j)][hook(14, 3)] *= 1.41421356237309504880168872420969808f;
    res[hook(15, j)][hook(14, 5)] *= 1.41421356237309504880168872420969808f;
    res[hook(15, j)][hook(14, 1)] = st3[hook(9, 0)] + st3[hook(9, 1)];
  }

  for (i = 0; i < 8; i++) {
    float st2[8], st3[2];
    float tmp;

    out[hook(6, i)][hook(17, 0)] = res[hook(15, 0)][hook(18, i)] + res[hook(15, 7)][hook(19, i)];
    out[hook(6, i)][hook(17, 1)] = res[hook(15, 1)][hook(20, i)] + res[hook(15, 6)][hook(21, i)];
    out[hook(6, i)][hook(17, 2)] = res[hook(15, 2)][hook(22, i)] + res[hook(15, 5)][hook(23, i)];
    out[hook(6, i)][hook(17, 3)] = res[hook(15, 3)][hook(24, i)] + res[hook(15, 4)][hook(25, i)];

    out[hook(6, i)][hook(17, 4)] = res[hook(15, 3)][hook(24, i)] - res[hook(15, 4)][hook(25, i)];
    out[hook(6, i)][hook(17, 5)] = res[hook(15, 2)][hook(22, i)] - res[hook(15, 5)][hook(23, i)];
    out[hook(6, i)][hook(17, 6)] = res[hook(15, 1)][hook(20, i)] - res[hook(15, 6)][hook(21, i)];
    out[hook(6, i)][hook(17, 7)] = res[hook(15, 0)][hook(18, i)] - res[hook(15, 7)][hook(19, i)];

    st2[hook(8, 0)] = out[hook(6, i)][hook(17, 0)] + out[hook(6, i)][hook(17, 3)];
    st2[hook(8, 1)] = out[hook(6, i)][hook(17, 1)] + out[hook(6, i)][hook(17, 2)];
    st2[hook(8, 2)] = out[hook(6, i)][hook(17, 1)] - out[hook(6, i)][hook(17, 2)];
    st2[hook(8, 3)] = out[hook(6, i)][hook(17, 0)] - out[hook(6, i)][hook(17, 3)];

    tmp = 0.83146961230254523707878837761791f * (out[hook(6, i)][hook(17, 4)] + out[hook(6, i)][hook(17, 7)]);

    st2[hook(8, 4)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * out[hook(6, i)][hook(17, 7)];
    st2[hook(8, 7)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * out[hook(6, i)][hook(17, 4)];

    tmp = 0.98078528040323044912618223613424f * (out[hook(6, i)][hook(17, 5)] + out[hook(6, i)][hook(17, 6)]);

    st2[hook(8, 5)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * out[hook(6, i)][hook(17, 6)];
    st2[hook(8, 6)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * out[hook(6, i)][hook(17, 5)];

    out[hook(6, i)][hook(17, 0)] = st2[hook(8, 0)] + st2[hook(8, 1)];
    out[hook(6, i)][hook(17, 4)] = st2[hook(8, 0)] - st2[hook(8, 1)];

    tmp = 0.54119610014619698439972320536639f * (st2[hook(8, 2)] + st2[hook(8, 3)]);

    out[hook(6, i)][hook(17, 2)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * st2[hook(8, 3)];
    out[hook(6, i)][hook(17, 6)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * st2[hook(8, 2)];

    st3[hook(9, 0)] = st2[hook(8, 4)] + st2[hook(8, 6)];
    st3[hook(9, 1)] = st2[hook(8, 5)] + st2[hook(8, 7)];
    out[hook(6, i)][hook(17, 3)] = st2[hook(8, 7)] - st2[hook(8, 5)];
    out[hook(6, i)][hook(17, 5)] = st2[hook(8, 4)] - st2[hook(8, 6)];

    out[hook(6, i)][hook(17, 7)] = st3[hook(9, 1)] - st3[hook(9, 0)];
    out[hook(6, i)][hook(17, 3)] *= 1.41421356237309504880168872420969808f;
    out[hook(6, i)][hook(17, 5)] *= 1.41421356237309504880168872420969808f;
    out[hook(6, i)][hook(17, 1)] = st3[hook(9, 0)] + st3[hook(9, 1)];

    for (j = 0; j < 8; j++) {
      out[hook(6, i)][hook(17, j)] *= 0.125f;
    }
  }
}

inline void idct2(float in[8][8], float out[8][8]) {
  int i, j;

  float res[8][8];

  for (j = 0; j < 8; j++) {
    float st1[8], st4[2];
    float tmp;

    st4[hook(10, 0)] = in[hook(7, j)][hook(16, 1)] - in[hook(7, j)][hook(16, 7)];
    st1[hook(11, 5)] = in[hook(7, j)][hook(16, 3)] * 1.41421356237309504880168872420969808f;
    st1[hook(11, 6)] = in[hook(7, j)][hook(16, 5)] * 1.41421356237309504880168872420969808f;
    st4[hook(10, 1)] = in[hook(7, j)][hook(16, 1)] + in[hook(7, j)][hook(16, 7)];

    res[hook(15, j)][hook(14, 0)] = in[hook(7, j)][hook(16, 0)] + in[hook(7, j)][hook(16, 4)];
    res[hook(15, j)][hook(14, 1)] = in[hook(7, j)][hook(16, 0)] - in[hook(7, j)][hook(16, 4)];

    tmp = 0.54119610014619698439972320536639f * (in[hook(7, j)][hook(16, 2)] + in[hook(7, j)][hook(16, 6)]);

    res[hook(15, j)][hook(14, 2)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * in[hook(7, j)][hook(16, 6)];
    res[hook(15, j)][hook(14, 3)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * in[hook(7, j)][hook(16, 2)];

    res[hook(15, j)][hook(14, 4)] = st4[hook(10, 0)] + st1[hook(11, 6)];
    res[hook(15, j)][hook(14, 5)] = st4[hook(10, 1)] - st1[hook(11, 5)];
    res[hook(15, j)][hook(14, 6)] = st4[hook(10, 0)] - st1[hook(11, 6)];
    res[hook(15, j)][hook(14, 7)] = st1[hook(11, 5)] + st4[hook(10, 1)];

    st1[hook(11, 0)] = res[hook(15, j)][hook(14, 0)] + res[hook(15, j)][hook(14, 3)];
    st1[hook(11, 1)] = res[hook(15, j)][hook(14, 1)] + res[hook(15, j)][hook(14, 2)];
    st1[hook(11, 2)] = res[hook(15, j)][hook(14, 1)] - res[hook(15, j)][hook(14, 2)];
    st1[hook(11, 3)] = res[hook(15, j)][hook(14, 0)] - res[hook(15, j)][hook(14, 3)];

    tmp = 0.83146961230254523707878837761791f * (res[hook(15, j)][hook(14, 4)] + res[hook(15, j)][hook(14, 7)]);

    st1[hook(11, 4)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * res[hook(15, j)][hook(14, 7)];
    st1[hook(11, 7)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * res[hook(15, j)][hook(14, 4)];

    tmp = 0.98078528040323044912618223613424f * (res[hook(15, j)][hook(14, 5)] + res[hook(15, j)][hook(14, 6)]);

    st1[hook(11, 5)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * res[hook(15, j)][hook(14, 6)];
    st1[hook(11, 6)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * res[hook(15, j)][hook(14, 5)];

    res[hook(15, j)][hook(14, 0)] = st1[hook(11, 0)] + st1[hook(11, 7)];
    res[hook(15, j)][hook(14, 1)] = st1[hook(11, 1)] + st1[hook(11, 6)];
    res[hook(15, j)][hook(14, 2)] = st1[hook(11, 2)] + st1[hook(11, 5)];
    res[hook(15, j)][hook(14, 3)] = st1[hook(11, 3)] + st1[hook(11, 4)];

    res[hook(15, j)][hook(14, 4)] = st1[hook(11, 3)] - st1[hook(11, 4)];
    res[hook(15, j)][hook(14, 5)] = st1[hook(11, 2)] - st1[hook(11, 5)];
    res[hook(15, j)][hook(14, 6)] = st1[hook(11, 1)] - st1[hook(11, 6)];
    res[hook(15, j)][hook(14, 7)] = st1[hook(11, 0)] - st1[hook(11, 7)];
  }

  for (i = 0; i < 8; i++) {
    float st1[8], st4[2];
    float tmp;

    st4[hook(10, 0)] = res[hook(15, 1)][hook(20, i)] - res[hook(15, 7)][hook(19, i)];
    st1[hook(11, 5)] = res[hook(15, 3)][hook(24, i)] * 1.41421356237309504880168872420969808f;
    st1[hook(11, 6)] = res[hook(15, 5)][hook(23, i)] * 1.41421356237309504880168872420969808f;
    st4[hook(10, 1)] = res[hook(15, 1)][hook(20, i)] + res[hook(15, 7)][hook(19, i)];

    out[hook(6, i)][hook(17, 0)] = res[hook(15, 0)][hook(18, i)] + res[hook(15, 4)][hook(25, i)];
    out[hook(6, i)][hook(17, 1)] = res[hook(15, 0)][hook(18, i)] - res[hook(15, 4)][hook(25, i)];

    tmp = 0.54119610014619698439972320536639f * (res[hook(15, 2)][hook(22, i)] + res[hook(15, 6)][hook(21, i)]);

    out[hook(6, i)][hook(17, 2)] = tmp - (0.54119610014619698439972320536639f + 1.3065629648763765278566431734272f) * res[hook(15, 6)][hook(21, i)];
    out[hook(6, i)][hook(17, 3)] = tmp + (1.3065629648763765278566431734272f - 0.54119610014619698439972320536639f) * res[hook(15, 2)][hook(22, i)];

    out[hook(6, i)][hook(17, 4)] = st4[hook(10, 0)] + st1[hook(11, 6)];
    out[hook(6, i)][hook(17, 5)] = st4[hook(10, 1)] - st1[hook(11, 5)];
    out[hook(6, i)][hook(17, 6)] = st4[hook(10, 0)] - st1[hook(11, 6)];
    out[hook(6, i)][hook(17, 7)] = st1[hook(11, 5)] + st4[hook(10, 1)];

    st1[hook(11, 0)] = out[hook(6, i)][hook(17, 0)] + out[hook(6, i)][hook(17, 3)];
    st1[hook(11, 1)] = out[hook(6, i)][hook(17, 1)] + out[hook(6, i)][hook(17, 2)];
    st1[hook(11, 2)] = out[hook(6, i)][hook(17, 1)] - out[hook(6, i)][hook(17, 2)];
    st1[hook(11, 3)] = out[hook(6, i)][hook(17, 0)] - out[hook(6, i)][hook(17, 3)];

    tmp = 0.83146961230254523707878837761791f * (out[hook(6, i)][hook(17, 4)] + out[hook(6, i)][hook(17, 7)]);

    st1[hook(11, 4)] = tmp - (0.83146961230254523707878837761791f + 0.55557023301960222474283081394853f) * out[hook(6, i)][hook(17, 7)];
    st1[hook(11, 7)] = tmp + (0.55557023301960222474283081394853f - 0.83146961230254523707878837761791f) * out[hook(6, i)][hook(17, 4)];

    tmp = 0.98078528040323044912618223613424f * (out[hook(6, i)][hook(17, 5)] + out[hook(6, i)][hook(17, 6)]);

    st1[hook(11, 5)] = tmp - (0.98078528040323044912618223613424f + 0.19509032201612826784828486847702f) * out[hook(6, i)][hook(17, 6)];
    st1[hook(11, 6)] = tmp + (0.19509032201612826784828486847702f - 0.98078528040323044912618223613424f) * out[hook(6, i)][hook(17, 5)];

    out[hook(6, i)][hook(17, 0)] = st1[hook(11, 0)] + st1[hook(11, 7)];
    out[hook(6, i)][hook(17, 1)] = st1[hook(11, 1)] + st1[hook(11, 6)];
    out[hook(6, i)][hook(17, 2)] = st1[hook(11, 2)] + st1[hook(11, 5)];
    out[hook(6, i)][hook(17, 3)] = st1[hook(11, 3)] + st1[hook(11, 4)];

    out[hook(6, i)][hook(17, 4)] = st1[hook(11, 3)] - st1[hook(11, 4)];
    out[hook(6, i)][hook(17, 5)] = st1[hook(11, 2)] - st1[hook(11, 5)];
    out[hook(6, i)][hook(17, 6)] = st1[hook(11, 1)] - st1[hook(11, 6)];
    out[hook(6, i)][hook(17, 7)] = st1[hook(11, 0)] - st1[hook(11, 7)];

    for (j = 0; j < 8; j++) {
      out[hook(6, i)][hook(17, j)] *= 0.125f;
    }
  }
}
inline void haar(float x[8], float y[8]) {
  int i, j;
  int k = 8;

  for (j = 0; j < 3; j++) {
    int k2 = k;
    k >>= 1;

    for (i = 0; i < k; i++) {
      int i2 = i << 1;
      int i21 = i2 + 1;
      y[hook(26, i)] = (x[hook(27, i2)] + x[hook(27, i21)]) * 0.70710678118654752440084436210485f;
      y[hook(26, i + k)] = (x[hook(27, i2)] - x[hook(27, i21)]) * 0.70710678118654752440084436210485f;
    }

    for (i = 0; i < k2; i++) {
      x[hook(27, i)] = y[hook(26, i)];
    }
  }
}

inline void ihaar(float x[8], float y[8]) {
  int i, j;
  int k = 1;

  for (j = 0; j < 3; j++) {
    for (i = 0; i < k; i++) {
      int i2 = i << 1;
      int ik = i + k;
      y[hook(26, i2)] = (x[hook(27, i)] + x[hook(27, ik)]) * 0.70710678118654752440084436210485f;
      y[hook(26, i2 + 1)] = (x[hook(27, i)] - x[hook(27, ik)]) * 0.70710678118654752440084436210485f;
    }

    k <<= 1;

    for (i = 0; i < k; i++) {
      x[hook(27, i)] = y[hook(26, i)];
    }
  }
}

constant sampler_t sampler = 0

                             | 4 | 0x10;

constant float kaiser_b_2[] = {0.1924f, 0.2989f, 0.3846f, 0.4325f, 0.4325f, 0.3846f, 0.2989f, 0.1924f, 0.2989f, 0.4642f, 0.5974f, 0.6717f, 0.6717f, 0.5974f, 0.4642f, 0.2989f, 0.3846f, 0.5974f, 0.7688f, 0.8644f, 0.8644f, 0.7688f, 0.5974f, 0.3846f, 0.4325f, 0.6717f, 0.8644f, 0.9718f, 0.9718f, 0.8644f, 0.6717f, 0.4325f, 0.4325f, 0.6717f, 0.8644f, 0.9718f, 0.9718f, 0.8644f, 0.6717f, 0.4325f, 0.3846f, 0.5974f, 0.7688f, 0.8644f, 0.8644f, 0.7688f, 0.5974f, 0.3846f, 0.2989f, 0.4642f, 0.5974f, 0.6717f, 0.6717f, 0.5974f, 0.4642f, 0.2989f, 0.1924f, 0.2989f, 0.3846f, 0.4325f, 0.4325f, 0.3846f, 0.2989f, 0.1924f};

inline void threshold_2d(float in[8][8]) {
  int i, j;
  for (j = 0; j < 8; j++) {
    for (i = 0; i < 8; i++) {
      if (fabs(in[hook(7, j)][hook(16, i)]) <= (2.0f * (float)25))
        in[hook(7, j)][hook(16, i)] = 0.0f;
    }
  }
}

inline void threshold_1d(float in[8], int* weight_count, int block_count) {
  int i;
  for (i = 0; i < 8; i++) {
    if (fabs(in[hook(7, i)]) <= (2.7f * (float)25))
      in[hook(7, i)] = 0.0f;
    else
      (*weight_count)++;
  }
}

kernel void calc_distances(read_only image2d_t input, global short* similar_coords, global uchar* block_counts, const int threshold, const int max_block_count, const int window_step_size) {
  const short2 gid = {get_global_id(0) * 3, get_global_id(1) * 3};
  const size_t tot_globals = get_global_size(0) * get_global_size(1);
  const size_t global_id = get_global_id(1) * get_global_size(0) + get_global_id(0);

  int distances[32];
  short2 positions[32];
  short block_count = 0;

  for (int n = 0; n < max_block_count; n++)
    distances[hook(28, n)] = 2147483647;

  for (int j = 19 % window_step_size; j < 39; j += window_step_size) {
    for (int i = 19 % window_step_size; i < 39; i += window_step_size) {
      uchar ref[8][8];

      for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
          const int2 ref_pos = {gid.x + x, gid.y + y};
          ref[hook(30, y)][hook(29, x)] = (uchar)read_imageui(input, sampler, ref_pos).s0;
        }
      }

      int d = 0;

      for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
          const int2 pos = {gid.x + i + x - 19, gid.y + j + y - 19};
          const uchar b = (uchar)read_imageui(input, sampler, pos).s0;
          d += (ref[hook(30, y)][hook(29, x)] - b) * (ref[hook(30, y)][hook(29, x)] - b);
        }
      }

      if (d <= threshold) {
        for (int n = 0; n < max_block_count; n++) {
          if (d < distances[hook(28, n)]) {
            for (int k = max_block_count - 1; k > n; k--) {
              distances[hook(28, k)] = distances[hook(28, k - 1)];
              positions[hook(31, k)] = positions[hook(31, k - 1)];
            }
            block_count++;
            distances[hook(28, n)] = d;
            positions[hook(31, n)].x = i;
            positions[hook(31, n)].y = j;
            break;
          }
        }
      }
    }
  }

  if (block_count > max_block_count)
    block_count = max_block_count;
  block_counts[hook(2, global_id)] = (uchar)block_count;

  for (int n = 0; n < block_count; n++) {
    const int ind = 2 * (n * tot_globals + global_id);
    similar_coords[hook(1, ind)] = positions[hook(31, n)].x;
    similar_coords[hook(1, ind + 1)] = positions[hook(31, n)].y;
  }
}