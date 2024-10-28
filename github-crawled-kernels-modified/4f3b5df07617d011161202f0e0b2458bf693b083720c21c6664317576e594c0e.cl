//{"Coef_Three":11,"Coef_Two":10,"FREQ_SIZE":14,"H":7,"HQDerivativeData":5,"H_SIZE":13,"LogTimeValues":2,"M":8,"NUMBER_OF_DAYS":15,"Omega":9,"Q":6,"Q_SIZE":12,"TestFrequencies":4,"TimeValues":3,"meanArray":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hq_derivative(global float* values, global float* meanArray, global const float* LogTimeValues, global const float* TimeValues, global const float* TestFrequencies, global float* HQDerivativeData, global float* Q, global float* H, float M, float Omega, float Coef_Two, float Coef_Three, int Q_SIZE, int H_SIZE, int FREQ_SIZE, int NUMBER_OF_DAYS) {
  int globalid = get_global_id(0);
  int localid = get_global_id(1);
  int indexvalue = globalid + localid * (Q_SIZE);

  if (indexvalue >= Q_SIZE * H_SIZE) {
    return;
  } else {
    float OmegaSecond, SinSum, CosSum, CosResidSum, SinResidSum, Tau;
    Tau = 0.0f;

    float Mean;
    Mean = meanArray[hook(1, indexvalue)];

    float MaxValue;
    MaxValue = 0.0f;
    for (int k = 0; k < FREQ_SIZE; k++) {
      OmegaSecond = 2.0f * 3.14159f * TestFrequencies[hook(4, k)];
      SinSum = 0.0f;
      CosSum = 0.0f;

      for (int p = 0; p < NUMBER_OF_DAYS; p++) {
        SinSum = SinSum + sin(2.0f * OmegaSecond * LogTimeValues[hook(2, p)]);
        CosSum = CosSum + cos(2.0f * OmegaSecond * LogTimeValues[hook(2, p)]);
      }

      Tau = atan2(SinSum, CosSum) * 1.0f / (2.0f * OmegaSecond);
      CosResidSum = 0.0f;
      SinResidSum = 0.0f;
      SinSum = 0.0f;
      CosSum = 0.0f;

      for (int p = 0; p < NUMBER_OF_DAYS; p++) {
        float Value = HQDerivativeData[hook(5, indexvalue * NUMBER_OF_DAYS + p)] - Mean;
        CosResidSum = CosResidSum + Value * cos(OmegaSecond * (LogTimeValues[hook(2, p)] - Tau));
        SinResidSum = SinResidSum + Value * sin(OmegaSecond * (LogTimeValues[hook(2, p)] - Tau));
        SinSum = SinSum + pow(sin(OmegaSecond * (LogTimeValues[hook(2, p)] - Tau)), 2.0f);
        CosSum = CosSum + pow(cos(OmegaSecond * (LogTimeValues[hook(2, p)] - Tau)), 2.0f);
      }

      CosResidSum = pow(CosResidSum, 2.0f);
      SinResidSum = pow(SinResidSum, 2.0f);

      float tempfloat;
      tempfloat = CosResidSum * 1.0f / CosSum + SinResidSum * 1.0f / SinSum;

      if (tempfloat > MaxValue) {
        MaxValue = tempfloat;
      }
    }
    values[hook(0, indexvalue)] = MaxValue;
  }
}