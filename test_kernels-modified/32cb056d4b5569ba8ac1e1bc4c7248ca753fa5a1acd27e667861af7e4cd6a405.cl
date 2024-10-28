//{"UH1":11,"UH2":12,"X":10,"X1_a":3,"X2_a":4,"X3_a":5,"X4_a":6,"data_len":2,"potential_evap":1,"precip":0,"qobs":7,"qsim":9,"skillscores":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float s_curves1(float t, float x4) {
  if (t <= 0) {
    return 0;
  } else if (t < x4) {
    return pow((t / x4), (float)2.5);
  } else {
    return 1;
  }
}

float s_curves2(float t, float x4) {
  if (t <= 0) {
    return 0;
  } else if (t < x4) {
    return 0.5 * pow((t / x4), (float)2.5);
  } else if (t < 2 * x4) {
    return 1 - 0.5 * pow((2 - t / x4), (float)2.5);
  } else {
    return 1;
  }
}

kernel void gr4j(global const float* precip, global const float* potential_evap, int data_len, global const float* X1_a, global const float* X2_a, global const float* X3_a, global const float* X4_a, global const float* qobs, global float* skillscores, global float* qsim) {
  int gid = get_global_id(0);
  float X1 = X1_a[hook(3, gid)];
  float X2 = X2_a[hook(4, gid)];
  float X3 = X3_a[hook(5, gid)];
  float X4 = X4_a[hook(6, gid)];

  float production_store = 0;
  float routing_store = 0;

  float X[30] = {0};
  int NH = 10;

  float UH1[10] = {0};
  float UH2[20] = {0};

  int t;
  for (t = 1; t < NH; t++) {
    X[hook(10, t - 1)] = s_curves1(t, X4) - s_curves1(t - 1, X4);
  }

  for (t = 1; t < 2 * NH; t++) {
    X[hook(10, NH + t - 1)] = s_curves2(t, X4) - s_curves2(t - 1, X4);
  }

  for (t = 0; t < 30; t++) {
  }

  int i;
  int j;
  float P;
  float E;
  float net_evap;
  float WS;
  float reservoir_production;
  float routing_pattern;
  float ps_div_x1;
  float percolation;
  float groundwater_exchange;
  float R2;
  float QR;
  float QD;
  float sum = 0;
  for (i = 0; i < data_len; i++) {
    P = precip[hook(0, i)];
    E = potential_evap[hook(1, i)];

    if (P > E) {
      net_evap = 0;
      WS = (P - E) / X1;
      WS = WS > 13 ? 13 : WS;

      reservoir_production = (X1 * (1 - pow(production_store / X1, 2)) * tanh(WS)) / (1 + production_store / X1 * tanh(WS));

      routing_pattern = P - E - reservoir_production;
    } else {
      WS = (E - P) / X1;
      WS = WS > 13 ? 13 : WS;
      ps_div_x1 = (2 - production_store / X1) * tanh(WS);
      net_evap = production_store * (ps_div_x1) / (1 + (1 - production_store / X1) * tanh(WS));

      reservoir_production = 0;
      routing_pattern = 0;
    }

    production_store = production_store - net_evap + reservoir_production;

    percolation = production_store / pow((1 + pow((production_store / (float)2.25 / X1), (float)4)), (float)0.25);

    routing_pattern = routing_pattern + (production_store - percolation);
    production_store = percolation;

    for (j = 0; j <= NH - 2; j++) {
      UH1[hook(11, j)] = UH1[hook(11, j + 1)] + X[hook(10, j)] * routing_pattern;
    }

    for (j = 0; j <= NH - 2; j++) {
      UH2[hook(12, j)] = UH2[hook(12, j + 1)] + X[hook(10, j + NH)] * routing_pattern;
    }

    UH2[hook(12, 19)] = X[hook(10, 29)] * routing_pattern;
    groundwater_exchange = X2 * pow((routing_store / X3), (float)3.5);

    routing_store = fmax(0, routing_store + UH1[hook(11, 0)] * (float)0.9 + groundwater_exchange);

    R2 = routing_store / pow((1 + pow((routing_store / X3), 4)), (float)0.25);
    QR = routing_store - R2;
    routing_store = R2;
    QD = fmax(0, UH2[hook(12, 0)] * 0.1 + groundwater_exchange);
    qsim[hook(9, gid * data_len + i)] = QR + QD;

    sum += qsim[hook(9, gid * data_len + i)];
  }
  float m = sum / data_len;
  float nse;
  int offset = gid * data_len;
  float e1 = 0;
  float e2 = 0;
  for (t = 0; t < data_len; t++) {
    e1 += pow(qobs[hook(7, t)] - qsim[hook(9, t + offset)], 2);
    e2 += pow(qobs[hook(7, t)] - m, 2);
  }

  if (e1 == 0) {
    nse = 1;
  } else {
    nse = 1 - e1 / e2;
  }

  skillscores[hook(8, gid)] = nse;
}