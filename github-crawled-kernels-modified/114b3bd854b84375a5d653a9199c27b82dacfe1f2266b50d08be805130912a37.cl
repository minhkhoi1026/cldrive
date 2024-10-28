//{"A":19,"AR_Estimates":2,"A[0]":25,"A[1]":27,"Beta_Volumes":1,"Cxx":32,"Cxx[0]":31,"Cxx[1]":33,"DATA_D":13,"DATA_H":12,"DATA_W":11,"InvOmegaT":46,"InvOmegaT[0]":45,"InvOmegaT[1]":47,"Mask":4,"NUMBER_OF_ITERATIONS":16,"NUMBER_OF_REGRESSORS":15,"NUMBER_OF_VOLUMES":14,"OmegaT":50,"OmegaT[0]":49,"OmegaT[1]":51,"Seeds":5,"Statistical_Maps":0,"Volumes":3,"XtildeYtilde":44,"Xtildesquared":42,"Xtildesquared[0]":41,"Xtildesquared[1]":43,"beta":30,"betaT":48,"c_InvOmega0":7,"c_S00":8,"c_S01":9,"c_S11":10,"c_X_GLM":6,"cholA":18,"cholA[0]":24,"cholA[1]":26,"cholCov":23,"cholCov[0]":28,"cholCov[1]":29,"inv_Cxx":35,"inv_Cxx[0]":34,"inv_Cxx[1]":36,"m00":37,"m01":38,"m10":39,"m11":40,"mu":22,"random":21,"randvalues":20,"slice":17,"temp":52}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

double unirand(private int* seed) {
  double const a = 16807.0;
  double const m = 2147483647.0;
  double const reciprocal_m = 1.0 / m;
  double temp = (*seed) * a;
  *seed = (int)(temp - m * floor(temp * reciprocal_m));

  return ((double)(*seed) * reciprocal_m);
}

double normalrand(private int* seed) {
  double u = unirand(seed);
  double v = unirand(seed);

  return sqrt(-2.0 * log(u)) * cos(2.0 * 3.141592653589793 * v);
}

double gamrnd(float a, float b, private int* seed) {
  double x = 0.0;
  for (int i = 0; i < 2 * (int)round(a); i++) {
    double rand_value = normalrand(seed);
    x += rand_value * rand_value;
  }

  return 2.0 * b / x;
}
int Cholesky(float* cholA, float factor, constant float* A, int N) {
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      cholA[hook(18, i + j * N)] = 0.0f;

      if (i == j) {
        float value = 0.0f;
        for (int k = 0; k <= (j - 1); k++) {
          value += cholA[hook(18, k + j * N)] * cholA[hook(18, k + j * N)];
        }
        cholA[hook(18, j + j * N)] = sqrt(factor * A[hook(19, j + j * N)] - value);
      } else if (i > j) {
        float value = 0.0f;
        for (int k = 0; k <= (j - 1); k++) {
          value += cholA[hook(18, k + i * N)] * cholA[hook(18, k + j * N)];
        }
        cholA[hook(18, j + i * N)] = 1 / cholA[hook(18, j + j * N)] * (factor * A[hook(19, j + i * N)] - value);
      }
    }
  }

  return 0;
}

int MultivariateRandomOld(float* random, float* mu, constant float* Cov, float Sigma, int N, private int* seed) {
  float randvalues[2];
  float cholCov[4];

  switch (N) {
    case 2:

      randvalues[hook(20, 0)] = normalrand(seed);
      randvalues[hook(20, 1)] = normalrand(seed);

      Cholesky(cholCov, Sigma, Cov, N);

      random[hook(21, 0)] = mu[hook(22, 0)] + cholCov[hook(23, 0 + 0 * N)] * randvalues[hook(20, 0)] + cholCov[hook(23, 1 + 0 * N)] * randvalues[hook(20, 1)];
      random[hook(21, 1)] = mu[hook(22, 1)] + cholCov[hook(23, 0 + 1 * N)] * randvalues[hook(20, 0)] + cholCov[hook(23, 1 + 1 * N)] * randvalues[hook(20, 1)];

      break;

    case 3:

      break;

    case 4:

      break;

    default:
      1;
      break;
  }

  return 0;
}

int Cholesky1(float* cholA, float factor, float A) {
  *cholA = sqrt(factor * A);

  return 0;
}

int Cholesky2(float cholA[2][2], float factor, float A[2][2]) {
  cholA[hook(18, 0)][hook(24, 0)] = sqrt(factor * A[hook(19, 0)][hook(25, 0)]);

  cholA[hook(18, 1)][hook(26, 0)] = 1.0f / cholA[hook(18, 0)][hook(24, 0)] * (factor * A[hook(19, 1)][hook(27, 0)]);

  cholA[hook(18, 0)][hook(24, 1)] = 0.0f;

  cholA[hook(18, 1)][hook(26, 1)] = sqrt(factor * A[hook(19, 1)][hook(27, 1)] - cholA[hook(18, 0)][hook(24, 1)] * cholA[hook(18, 0)][hook(24, 1)] - cholA[hook(18, 1)][hook(26, 0)] * cholA[hook(18, 1)][hook(26, 0)]);

  return 0;
}

int MultivariateRandom1(float* random, float mu, private float Cov, float Sigma, private int* seed) {
  float randvalues;
  float cholCov;

  randvalues = normalrand(seed);
  Cholesky1(&cholCov, Sigma, Cov);
  random[hook(21, 0)] = mu + cholCov * randvalues;

  return 0;
}

int MultivariateRandom2(float* random, float* mu, private float Cov[2][2], float Sigma, private int* seed) {
  float randvalues[2];
  float cholCov[2][2];

  randvalues[hook(20, 0)] = normalrand(seed);
  randvalues[hook(20, 1)] = normalrand(seed);

  Cholesky2(cholCov, Sigma, Cov);

  random[hook(21, 0)] = mu[hook(22, 0)] + cholCov[hook(23, 0)][hook(28, 0)] * randvalues[hook(20, 0)] + cholCov[hook(23, 0)][hook(28, 1)] * randvalues[hook(20, 1)];
  random[hook(21, 1)] = mu[hook(22, 1)] + cholCov[hook(23, 0)][hook(28, 1)] * randvalues[hook(20, 0)] + cholCov[hook(23, 1)][hook(29, 1)] * randvalues[hook(20, 1)];

  return 0;
}

int CalculateBetaWeightsBayesian(private float* beta, private float value, constant float* c_X_GLM, int v, int NUMBER_OF_VOLUMES, int NUMBER_OF_REGRESSORS) {
  switch (NUMBER_OF_REGRESSORS) {
    case 1:

      beta[hook(30, 0)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)];

      break;

    case 2:

      beta[hook(30, 0)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(30, 1)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)];

      break;

    case 3:

      beta[hook(30, 0)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(30, 1)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(30, 2)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 2 + v)];

      break;

    case 4:

      beta[hook(30, 0)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(30, 1)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(30, 2)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(30, 3)] += value * c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 3 + v)];

      break;

    default:
      1;
      break;
  }

  return 0;
}

float Determinant_2x2(float Cxx[2][2]) {
  return Cxx[hook(32, 0)][hook(31, 0)] * Cxx[hook(32, 1)][hook(33, 1)] - Cxx[hook(32, 0)][hook(31, 1)] * Cxx[hook(32, 1)][hook(33, 0)];
}

void Invert_2x2(float Cxx[2][2], float inv_Cxx[2][2]) {
  float determinant = Determinant_2x2(Cxx) + 0.001f;

  inv_Cxx[hook(35, 0)][hook(34, 0)] = Cxx[hook(32, 1)][hook(33, 1)] / determinant;
  inv_Cxx[hook(35, 0)][hook(34, 1)] = -Cxx[hook(32, 0)][hook(31, 1)] / determinant;
  inv_Cxx[hook(35, 1)][hook(36, 0)] = -Cxx[hook(32, 1)][hook(33, 0)] / determinant;
  inv_Cxx[hook(35, 1)][hook(36, 1)] = Cxx[hook(32, 0)][hook(31, 0)] / determinant;
}

float myabs(float value) {
  if (value < 0.0f)
    return -value;
  else
    return value;
}
kernel void CalculateStatisticalMapsGLMBayesian(global float* Statistical_Maps, global float* Beta_Volumes, global float* AR_Estimates, global const float* Volumes, global const float* Mask, global const int* Seeds, local float* c_X_GLM, local float* c_InvOmega0, local float* c_S00, local float* c_S01, local float* c_S11, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_ITERATIONS, private int slice) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(4, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] != 1.0f) {
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 0, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 1, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 2, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 3, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 4, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 5, DATA_W, DATA_H, DATA_D))] = 0.0f;

    Beta_Volumes[hook(1, Calculate4DIndex(x, y, slice, 0, DATA_W, DATA_H, DATA_D))] = 0.0f;
    Beta_Volumes[hook(1, Calculate4DIndex(x, y, slice, 1, DATA_W, DATA_H, DATA_D))] = 0.0f;

    AR_Estimates[hook(2, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] = 0.0f;

    return;
  }

  int seed = Seeds[hook(5, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))];

  float iota = 1.0f;
  float r = 0.5f;
  float c = 0.3f;
  float a0 = 0.01f;
  float b0 = 0.01f;

  float InvA0 = c * c;

  float prcBurnin = 10.0f;

  float beta[2];
  float betaT[2];

  int nBurnin = (int)round((float)NUMBER_OF_ITERATIONS * (prcBurnin / 100.0f));

  int probability1 = 0;
  int probability2 = 0;
  int probability3 = 0;
  int probability4 = 0;
  int probability5 = 0;
  int probability6 = 0;

  float m00[2];
  float m01[2];
  float m10[2];
  float m11[2];

  m00[hook(37, 0)] = 0.0f;
  m00[hook(37, 1)] = 0.0f;

  m01[hook(38, 0)] = 0.0f;
  m01[hook(38, 1)] = 0.0f;

  m10[hook(39, 0)] = 0.0f;
  m10[hook(39, 1)] = 0.0f;

  m11[hook(40, 0)] = 0.0f;
  m11[hook(40, 1)] = 0.0f;

  float g00 = 0.0f;
  float g01 = 0.0f;
  float g11 = 0.0f;

  float old_value = Volumes[hook(3, Calculate3DIndex(x, y, 0, DATA_W, DATA_H))];

  m00[hook(37, 0)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + 0)] * old_value;
  m00[hook(37, 1)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + 0)] * old_value;

  g00 += old_value * old_value;

  for (int v = 1; v < NUMBER_OF_VOLUMES; v++) {
    float value = Volumes[hook(3, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

    m00[hook(37, 0)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)] * value;
    m00[hook(37, 1)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)] * value;

    m01[hook(38, 0)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)] * old_value;
    m01[hook(38, 1)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)] * old_value;

    m10[hook(39, 0)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + (v - 1))] * value;
    m10[hook(39, 1)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + (v - 1))] * value;

    m11[hook(40, 0)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + (v - 1))] * old_value;
    m11[hook(40, 1)] += c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + (v - 1))] * old_value;

    g00 += value * value;
    g01 += value * old_value;
    g11 += old_value * old_value;

    old_value = value;
  }

  float InvOmegaT[2][2];
  float OmegaT[2][2];
  float Xtildesquared[2][2];
  float XtildeYtilde[2];
  float Ytildesquared;

  Xtildesquared[hook(42, 0)][hook(41, 0)] = c_S00[hook(8, 0 + 0 * 2)];
  Xtildesquared[hook(42, 0)][hook(41, 1)] = c_S00[hook(8, 0 + 1 * 2)];
  Xtildesquared[hook(42, 1)][hook(43, 0)] = c_S00[hook(8, 1 + 0 * 2)];
  Xtildesquared[hook(42, 1)][hook(43, 1)] = c_S00[hook(8, 1 + 1 * 2)];

  XtildeYtilde[hook(44, 0)] = m00[hook(37, 0)];
  XtildeYtilde[hook(44, 1)] = m00[hook(37, 1)];

  Ytildesquared = g00;

  float sigma2;
  float rho, rhoT, rhoProp, bT;

  rho = 0.0f;

  for (int i = 0; i < (nBurnin + NUMBER_OF_ITERATIONS); i++) {
    InvOmegaT[hook(46, 0)][hook(45, 0)] = c_InvOmega0[hook(7, 0 + 0 * NUMBER_OF_REGRESSORS)] + Xtildesquared[hook(42, 0)][hook(41, 0)];
    InvOmegaT[hook(46, 0)][hook(45, 1)] = c_InvOmega0[hook(7, 0 + 1 * NUMBER_OF_REGRESSORS)] + Xtildesquared[hook(42, 0)][hook(41, 1)];
    InvOmegaT[hook(46, 1)][hook(47, 0)] = c_InvOmega0[hook(7, 1 + 0 * NUMBER_OF_REGRESSORS)] + Xtildesquared[hook(42, 1)][hook(43, 0)];
    InvOmegaT[hook(46, 1)][hook(47, 1)] = c_InvOmega0[hook(7, 1 + 1 * NUMBER_OF_REGRESSORS)] + Xtildesquared[hook(42, 1)][hook(43, 1)];
    Invert_2x2(InvOmegaT, OmegaT);

    betaT[hook(48, 0)] = OmegaT[hook(50, 0)][hook(49, 0)] * XtildeYtilde[hook(44, 0)] + OmegaT[hook(50, 0)][hook(49, 1)] * XtildeYtilde[hook(44, 1)];
    betaT[hook(48, 1)] = OmegaT[hook(50, 1)][hook(51, 0)] * XtildeYtilde[hook(44, 0)] + OmegaT[hook(50, 1)][hook(51, 1)] * XtildeYtilde[hook(44, 1)];

    float aT = a0 + (float)NUMBER_OF_VOLUMES / 2.0f;
    float temp[2];
    temp[hook(52, 0)] = InvOmegaT[hook(46, 0)][hook(45, 0)] * betaT[hook(48, 0)] + InvOmegaT[hook(46, 0)][hook(45, 1)] * betaT[hook(48, 1)];
    temp[hook(52, 1)] = InvOmegaT[hook(46, 1)][hook(47, 0)] * betaT[hook(48, 0)] + InvOmegaT[hook(46, 1)][hook(47, 1)] * betaT[hook(48, 1)];
    bT = b0 + 0.5f * (Ytildesquared - betaT[hook(48, 0)] * temp[hook(52, 0)] - betaT[hook(48, 1)] * temp[hook(52, 1)]);

    sigma2 = gamrnd(aT, bT, &seed);

    MultivariateRandom2(beta, betaT, OmegaT, sigma2, &seed);

    if (i > nBurnin) {
      if (beta[hook(30, 0)] > 0.0f) {
        probability1++;
      }

      if (beta[hook(30, 1)] > 0.0f) {
        probability2++;
      }

      if (beta[hook(30, 0)] < 0.0f) {
        probability3++;
      }

      if (beta[hook(30, 1)] < 0.0f) {
        probability4++;
      }

      if ((beta[hook(30, 0)] - beta[hook(30, 1)]) > 0.0f) {
        probability5++;
      }

      if ((beta[hook(30, 1)] - beta[hook(30, 0)]) > 0.0f) {
        probability6++;
      }
    }

    float zsquared = 0.0f;
    float zu = 0.0f;
    float old_eps = 0.0f;

    for (int v = 1; v < NUMBER_OF_VOLUMES; v++) {
      float eps = Volumes[hook(3, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];
      eps -= c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(30, 0)];
      eps -= c_X_GLM[hook(6, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(30, 1)];

      zsquared += eps * eps;
      zu += eps * old_eps;

      old_eps = eps;
    }

    float InvAT = InvA0 + zsquared / sigma2;
    float AT = 1.0f / InvAT;
    rhoT = AT * zu / sigma2;
    MultivariateRandom1(&rhoProp, rhoT, AT, sigma2, &seed);

    if (myabs(rhoProp) < 1.0f) {
      rho = rhoProp;
    }

    Xtildesquared[hook(42, 0)][hook(41, 0)] = c_S00[hook(8, 0 + 0 * 2)] - 2.0f * rho * c_S01[hook(9, 0 + 0 * 2)] + rho * rho * c_S11[hook(10, 0 + 0 * 2)];
    Xtildesquared[hook(42, 0)][hook(41, 1)] = c_S00[hook(8, 0 + 1 * 2)] - 2.0f * rho * c_S01[hook(9, 0 + 1 * 2)] + rho * rho * c_S11[hook(10, 0 + 1 * 2)];
    Xtildesquared[hook(42, 1)][hook(43, 0)] = c_S00[hook(8, 1 + 0 * 2)] - 2.0f * rho * c_S01[hook(9, 1 + 0 * 2)] + rho * rho * c_S11[hook(10, 1 + 0 * 2)];
    Xtildesquared[hook(42, 1)][hook(43, 1)] = c_S00[hook(8, 1 + 1 * 2)] - 2.0f * rho * c_S01[hook(9, 1 + 1 * 2)] + rho * rho * c_S11[hook(10, 1 + 1 * 2)];

    XtildeYtilde[hook(44, 0)] = m00[hook(37, 0)] - rho * (m01[hook(38, 0)] + m10[hook(39, 0)]) + rho * rho * m11[hook(40, 0)];
    XtildeYtilde[hook(44, 1)] = m00[hook(37, 1)] - rho * (m01[hook(38, 1)] + m10[hook(39, 1)]) + rho * rho * m11[hook(40, 1)];

    Ytildesquared = g00 - 2.0f * rho * g01 + rho * rho * g11;
  }

  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 0, DATA_W, DATA_H, DATA_D))] = (float)probability1 / (float)NUMBER_OF_ITERATIONS;
  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 1, DATA_W, DATA_H, DATA_D))] = (float)probability2 / (float)NUMBER_OF_ITERATIONS;
  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 2, DATA_W, DATA_H, DATA_D))] = (float)probability3 / (float)NUMBER_OF_ITERATIONS;
  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 3, DATA_W, DATA_H, DATA_D))] = (float)probability4 / (float)NUMBER_OF_ITERATIONS;
  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 4, DATA_W, DATA_H, DATA_D))] = (float)probability5 / (float)NUMBER_OF_ITERATIONS;
  Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, 5, DATA_W, DATA_H, DATA_D))] = (float)probability6 / (float)NUMBER_OF_ITERATIONS;

  Beta_Volumes[hook(1, Calculate4DIndex(x, y, slice, 0, DATA_W, DATA_H, DATA_D))] = beta[hook(30, 0)];
  Beta_Volumes[hook(1, Calculate4DIndex(x, y, slice, 1, DATA_W, DATA_H, DATA_D))] = beta[hook(30, 1)];

  AR_Estimates[hook(2, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] = rhoT;
}