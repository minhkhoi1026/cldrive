//{"FREQ_SIZE":7,"HQDerivativeData":4,"H_SIZE":6,"LogTimeValues":2,"NUMBER_OF_DAYS":8,"Q_SIZE":5,"TestFrequencies":3,"meanArray":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hq_derivative(global float* values, global const float* meanArray, global const float* LogTimeValues, global const float* TestFrequencies, global const float* HQDerivativeData, const int Q_SIZE, const int H_SIZE, const int FREQ_SIZE, const int NUMBER_OF_DAYS) {
  const int globalid = get_global_id(0);
  const int localid = get_global_id(1);
  const int indexvalue = globalid + localid * (Q_SIZE);

  if (indexvalue >= Q_SIZE * H_SIZE) {
    return;
  } else {
    const float Mean = meanArray[hook(1, indexvalue)];

    float MaxValue = 0.0f;
    for (int k = 0; k < FREQ_SIZE; k++) {
      const float OmegaSecond = 2.0f * 3.14159f * TestFrequencies[hook(3, k)];
      float2 tempSum = (float2)(0.0f);

      for (int p = 0; p < NUMBER_OF_DAYS; p++) {
        float tempValue = 2.0f * OmegaSecond * LogTimeValues[hook(2, p)];
        tempSum = tempSum + (float2)(sin(tempValue), cos(tempValue));
      }

      const float Tau = atan2(tempSum.x, tempSum.y) * 1.0f / (2.0f * OmegaSecond);

      float4 tot = (float4)(0.0f);

      for (int p = 0; p < NUMBER_OF_DAYS; p++) {
        float Value = HQDerivativeData[hook(4, indexvalue * NUMBER_OF_DAYS + p)] - Mean;
        float OmegaSecondLTMT = OmegaSecond * (LogTimeValues[hook(2, p)] - Tau);
        float cosOmegaSecondLTMT = cos(OmegaSecondLTMT);
        float sinOmegaSecondLTMT = sin(OmegaSecondLTMT);

        tot = tot + (float4)(Value * cosOmegaSecondLTMT, Value * sinOmegaSecondLTMT, sinOmegaSecondLTMT * sinOmegaSecondLTMT, cosOmegaSecondLTMT * cosOmegaSecondLTMT);
      }

      tot.x = tot.x * tot.x;
      tot.y = tot.y * tot.y;

      float tempfloat = tot.x * 1.0f / tot.w + tot.y * 1.0f / tot.z;

      if (tempfloat > MaxValue) {
        MaxValue = tempfloat;
      }
    }
    values[hook(0, indexvalue)] = MaxValue;
  }
}