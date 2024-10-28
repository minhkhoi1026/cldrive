//{"hct":1,"result":4,"tlrns":2,"v":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Vessel {
  float R;
  float pressure_in;
  float pressure_out;
  float GP;
  float tone;
  float flow;
  float Ppl;

  float gamma;
  float phi;
  float c;

  float peri_a;
  float peri_b;
  float peri_c;
  float peri_d;
  float P_0;

  float D;
  float len;

  float vessel_ratio;

  float pad[14 + 2 * 16];
};

struct Result {
  float R;
  float delta_R;
  float D;
  float Dmin;
  float Dmax;
  float volume;
  float viscosity_factor;

  float pad[1 + 8 + 3 * 16];
};

inline float sqr(float n) {
  return n * n;
}

inline float viscosityFactor(float D, float Hct) {
  const float a = 1.0 / fma((float)1e-11, pown(D, 12), (float)1.0);
  const float C = (0.8 + exp((float)-0.075 * D)) * (a - 1.0) + a;

  const float mi_a = exp((float)-1.3 * D) * 220.0;
  const float mi_b = exp((float)-0.06 * powr(D, (float)0.645)) * -2.44;
  const float Mi45 = mi_a + mi_b + 3.2;

  float bb;
  if (C > 0.01 || C < -0.01) {
    const float b = pow((float)1.0 - Hct, C) - 1.0;
    const float b1 = pow((float)0.55, C) - 1.0;
    bb = b / b1;
  } else {
    bb = log((float)1.0 - Hct) / log((float)0.55);
  }
  return fma(Mi45 - (float)1.0, bb, (float)1.0) / 3.2;
}

kernel void multiSegmentedVesselFlow(int width, float hct, float tlrns, global struct Vessel* v, global struct Result* result) {
  const size_t vessel_index = get_global_id(0) + get_global_id(1) * width;
  const struct Vessel vein = v[hook(3, vessel_index)];

  float Pout = fmax(vein.pressure_out, vein.P_0);
  const float starling_P = vein.P_0 - fmin(vein.pressure_out, vein.P_0);
  const float starling_F = vein.flow;

  const float starling_R = (starling_P < 1e-5 && starling_F < 1e-5) ? 0 : starling_P / starling_F;
  float Rtot = 0.0;

  float D;
  float D_integral = 0.0;
  float volume = 0.0;
  float viscosity = 0.0;
  float dL = vein.len / (float)128;

  if (vein.D < 0.1) {
    result[hook(4, vessel_index)].D = 0.0;
    result[hook(4, vessel_index)].Dmin = 0.0;
    result[hook(4, vessel_index)].Dmax = 0.0;

    result[hook(4, vessel_index)].viscosity_factor = (__builtin_inff());
    result[hook(4, vessel_index)].volume = 0.0;
    result[hook(4, vessel_index)].R = (__builtin_inff());
    result[hook(4, vessel_index)].delta_R = 0.0;
    return;
  }

  for (int sum = 0; sum < 128; sum++) {
    const float Pv = 1.35951002636 * (Pout - vein.tone);
    const float Px = vein.Ppl + vein.peri_a + vein.peri_b / (1.0 + exp((vein.peri_c - Pv + vein.Ppl) / vein.peri_d));
    const float Ptm = Pv - Px;

    D = vein.D * vein.gamma - (vein.gamma - 1.0) * vein.D * exp(-Ptm * vein.phi / (vein.gamma - 1.0));
    const float vf = viscosityFactor(D, hct);

    const float Rs = 128 * 1.2501e8 / 3.14159265358979323846 * vf * dL / sqr(sqr(D)) * vein.vessel_ratio;

    volume += 3.14159265358979323846 / 4.0 * sqr(D) * dL;
    viscosity += vf;
    D_integral += D;

    if (sum == 0)
      result[hook(4, vessel_index)].Dmin = D;

    Pout = Pout + vein.flow * Rs;
    Rtot += Rs;
  }

  Rtot += starling_R;
  result[hook(4, vessel_index)].R = Rtot;
  result[hook(4, vessel_index)].D = D_integral / 128;
  result[hook(4, vessel_index)].Dmax = D;
  result[hook(4, vessel_index)].volume = volume / (1e9 * vein.vessel_ratio);
  result[hook(4, vessel_index)].viscosity_factor = viscosity / 128;
  result[hook(4, vessel_index)].delta_R = fabs(vein.R - Rtot) / vein.R;
}