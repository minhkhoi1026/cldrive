//{"compute0":9,"conv2d1":6,"dense":10,"dense1":12,"input_image":0,"lenet":5,"max_pool1":8,"tanh2":7,"tanh3":11,"weight_conv1":1,"weight_conv2":2,"weight_fc1":3,"weight_fc2":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void default_function(global float* restrict input_image, global float* restrict weight_conv1, global float* restrict weight_conv2, global float* restrict weight_fc1, global float* restrict weight_fc2, global float* restrict lenet) {
  float conv2d;
  for (int nn = 0; nn < 1; ++nn) {
    for (int yy = 0; yy < -1; ++yy) {
      for (int xx = 0; xx < -1; ++xx) {
        float reducer0;
        reducer0 = 0.000000e+00f;
        for (int ra1 = 0; ra1 < 5; ++ra1) {
          for (int ra2 = 0; ra2 < 5; ++ra2) {
            reducer0 = ((input_image[hook(0, (((xx + ra2) + ((yy + ra1) * 3)) + (nn * 9)))] * weight_conv1[hook(1, (ra2 + (ra1 * 5)))]) + reducer0);
          }
        }
        conv2d = reducer0;
      }
    }
  }
  float tanh1;
  for (int args = 0; args < 1; ++args) {
    for (int args1 = 0; args1 < -1; ++args1) {
      for (int args2 = 0; args2 < -1; ++args2) {
        tanh1 = ((float)tanh(((float)conv2d)));
      }
    }
  }
  float max_pool;
  for (int i = 0; i < 1; ++i) {
    for (int h = 0; h < -1; ++h) {
      for (int w = 0; w < -1; ++w) {
        float reducer1;
        reducer1 = -1.000000e+00f;
        for (int ra3 = 0; ra3 < 2; ++ra3) {
          for (int ra4 = 0; ra4 < 2; ++ra4) {
            reducer1 = max(tanh1, reducer1);
          }
        }
        max_pool = reducer1;
      }
    }
  }
  float conv2d1[250];
  for (int nn1 = 0; nn1 < 1; ++nn1) {
    for (int ff = 0; ff < 10; ++ff) {
      for (int yy1 = 0; yy1 < -5; ++yy1) {
        for (int xx1 = 0; xx1 < -5; ++xx1) {
          float reducer2;
          reducer2 = 0.000000e+00f;
          for (int ra6 = 0; ra6 < 5; ++ra6) {
            for (int ra7 = 0; ra7 < 5; ++ra7) {
              reducer2 = ((max_pool * weight_conv2[hook(2, ((ra7 + (ra6 * 5)) + (ff * 25)))]) + reducer2);
            }
          }
          conv2d1[hook(6, (((xx1 - (yy1 * 5)) + (ff * 25)) + (nn1 * 250)))] = reducer2;
        }
      }
    }
  }
  float tanh2[250];
  for (int args3 = 0; args3 < 1; ++args3) {
    for (int args0 = 0; args0 < 10; ++args0) {
      for (int args11 = 0; args11 < -5; ++args11) {
        for (int args21 = 0; args21 < -5; ++args21) {
          tanh2[hook(7, (((args21 - (args11 * 5)) + (args0 * 25)) + (args3 * 250)))] = ((float)tanh(((float)conv2d1[hook(6, (((args21 - (args11 * 5)) + (args0 * 25)) + (args3 * 250)))])));
        }
      }
    }
  }
  float max_pool1[90];
  for (int i1 = 0; i1 < 1; ++i1) {
    for (int c = 0; c < 10; ++c) {
      for (int h1 = 0; h1 < -3; ++h1) {
        for (int w1 = 0; w1 < -3; ++w1) {
          float reducer3;
          reducer3 = -1.000000e+00f;
          for (int ra8 = 0; ra8 < 2; ++ra8) {
            for (int ra9 = 0; ra9 < 2; ++ra9) {
              reducer3 = max(tanh2[hook(7, (((((w1 * 2) - (((h1 * 2) + ra8) * 5)) + ra9) + (c * 25)) + (i1 * 250)))], reducer3);
            }
          }
          max_pool1[hook(8, (((w1 - (h1 * 3)) + (c * 9)) + (i1 * 90)))] = reducer3;
        }
      }
    }
  }
  float compute0[90];
  for (int i2 = 0; i2 < 1; ++i2) {
    for (int j = 0; j < 90; ++j) {
      compute0[hook(9, (j + (i2 * 90)))] = max_pool1[hook(8, ((((j % -3) - (((j / -3) % -3) * 3)) + ((((j / -3) / -3) % 10) * 9)) + (i2 * 90)))];
    }
  }
  float dense[25];
  for (int i3 = 0; i3 < 1; ++i3) {
    for (int j1 = 0; j1 < 25; ++j1) {
      float reducer4;
      reducer4 = 0.000000e+00f;
      for (int ra10 = 0; ra10 < 90; ++ra10) {
        reducer4 = ((compute0[hook(9, (ra10 + (i3 * 90)))] * weight_fc1[hook(3, (ra10 + (j1 * 40)))]) + reducer4);
      }
      dense[hook(10, (j1 + (i3 * 25)))] = reducer4;
    }
  }
  float tanh3[25];
  for (int args4 = 0; args4 < 1; ++args4) {
    for (int args01 = 0; args01 < 25; ++args01) {
      tanh3[hook(11, (args01 + (args4 * 25)))] = ((float)tanh(((float)dense[hook(10, (args01 + (args4 * 25)))])));
    }
  }
  float dense1[10];
  for (int i4 = 0; i4 < 1; ++i4) {
    for (int j2 = 0; j2 < 10; ++j2) {
      float reducer5;
      reducer5 = 0.000000e+00f;
      for (int ra11 = 0; ra11 < 25; ++ra11) {
        reducer5 = ((tanh3[hook(11, (ra11 + (i4 * 25)))] * weight_fc2[hook(4, (ra11 + (j2 * 25)))]) + reducer5);
      }
      dense1[hook(12, (j2 + (i4 * 10)))] = reducer5;
    }
  }
  float compute1;
  int max1;
  max1 = 0;
  for (int ra12 = 0; ra12 < 10; ++ra12) {
    max1 = ((int)max(dense1[hook(12, ra12)], ((float)max1)));
  }
  compute1 = ((float)max1);
  float compute2;
  int sum;
  sum = 0;
  for (int ra13 = 0; ra13 < 10; ++ra13) {
    sum = ((int)(exp(((float)(dense1[hook(12, ra13)] - compute1))) + ((float)sum)));
  }
  compute2 = ((float)sum);
  float update0;
  for (int j3 = 0; j3 < 10; ++j3) {
    lenet[hook(5, j3)] = ((float)(exp(((float)(dense1[hook(12, j3)] - compute1))) / ((float)compute2)));
  }
}