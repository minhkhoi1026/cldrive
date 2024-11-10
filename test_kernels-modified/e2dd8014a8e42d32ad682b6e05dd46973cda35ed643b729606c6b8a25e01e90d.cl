//{"dt":5,"states_new":1,"states_old":0,"sumFootprintAMPA":2,"sumFootprintGABAA":4,"sumFootprintNMDA":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct state {
  float V;
  float h;
  float n;
  float z;
  float s_AMPA;
  float x_NMDA;
  float s_NMDA;
  float s_GABAA;
  float I_app;
};

inline float _f_I_Na_m_inf(const float V) {
  const float theta_m = -30;
  const float sigma_m = 9.5f;

  return pow((1 + exp(-(V - theta_m) / sigma_m)), -1);
}

inline float _f_I_Na(const float V, const float h) {
  const float g_Na = 35;
  const float V_Na = 55;

  return g_Na * pow(_f_I_Na_m_inf(V), 3) * h * (V - V_Na);
}

inline float _f_p_inf(const float V) {
  const float theta_p = -47;
  const float sigma_p = 3;

  return pow((1 + exp(-(V - theta_p) / sigma_p)), -1);
}

inline float _f_I_NaP(const float V) {
  const float g_NaP = 0.2f;
  const float V_Na = 55;

  return g_NaP * _f_p_inf(V) * (V - V_Na);
}

inline float _f_I_Kdr(const float V, const float n) {
  const float g_Kdr = 3;
  const float V_K = -90;

  return g_Kdr * pow(n, 4) * (V - V_K);
}

inline float _f_I_Leak(const float V) {
  const float g_L = 0.05f;
  const float V_L = -70;

  return g_L * (V - V_L);
}

inline float _f_I_Kslow(const float V, const float z) {
  const float g_Kslow = 1.8f;
  const float V_K = -90;

  return g_Kslow * z * (V - V_K);
}

inline float _f_I_AMPA(const float V, const float sumFootprintAMPA) {
  const float g_AMPA = 0.08f;
  const float V_Glu = 0;

  return g_AMPA * (V - V_Glu) * sumFootprintAMPA;
}

inline float _f_f_NMDA(const float V) {
  const float theta_NMDA = 0;

  const float sigma_NMDA = 10;

  return pow(1 + exp(-(V - theta_NMDA) / sigma_NMDA), -1);
}

inline float _f_I_NMDA(const float V, const float sumFootprintNMDA) {
  const float g_NMDA = 0.07f;
  const float V_Glu = 0;

  return g_NMDA * _f_f_NMDA(V) * (V - V_Glu) * sumFootprintNMDA;
}

inline float _f_I_GABAA(const float V, const float sumFootprintGABAA) {
  const float g_GABAA = 0.05f;
  const float V_GABAA = -70;

  return g_GABAA * (V - V_GABAA) * sumFootprintGABAA;
}

inline float _f_dV_dt(const float V, const float h, const float n, const float z, const float I_app, const float sumFootprintAMPA, const float sumFootprintNMDA, const float sumFootprintGABAA) {
  return -_f_I_Na(V, h) - _f_I_NaP(V) - _f_I_Kdr(V, n) - _f_I_Kslow(V, z) - _f_I_Leak(V) - _f_I_AMPA(V, sumFootprintAMPA) - _f_I_NMDA(V, sumFootprintNMDA) - _f_I_GABAA(V, sumFootprintGABAA) + I_app;
}

kernel void f_dV_dt(global struct state* states_old, global struct state* states_new, global const float* sumFootprintAMPA, global const float* sumFootprintNMDA, global const float* sumFootprintGABAA, const float dt) {
  const unsigned int idx = get_global_id(0);

  const struct state state_0 = states_old[hook(0, idx)];
  const float sumFootprintAMPA_loc = sumFootprintAMPA[hook(2, idx)];
  const float sumFootprintNMDA_loc = sumFootprintNMDA[hook(3, idx)];
  const float sumFootprintGABAA_loc = sumFootprintGABAA[hook(4, idx)];

  float f1, f2, f3, f4;

  f1 = _f_dV_dt(state_0.V, state_0.h, state_0.n, state_0.z, state_0.I_app, sumFootprintAMPA_loc, sumFootprintNMDA_loc, sumFootprintGABAA_loc);
  f2 = _f_dV_dt(state_0.V + dt * f1 / 2.0f, state_0.h, state_0.n, state_0.z, state_0.I_app, sumFootprintAMPA_loc, sumFootprintNMDA_loc, sumFootprintGABAA_loc);
  f3 = _f_dV_dt(state_0.V + dt * f2 / 2.0f, state_0.h, state_0.n, state_0.z, state_0.I_app, sumFootprintAMPA_loc, sumFootprintNMDA_loc, sumFootprintGABAA_loc);
  f4 = _f_dV_dt(state_0.V + dt * f3, state_0.h, state_0.n, state_0.z, state_0.I_app, sumFootprintAMPA_loc, sumFootprintNMDA_loc, sumFootprintGABAA_loc);

  states_new[hook(1, idx)].V = state_0.V + dt * (f1 + 2.0f * f2 + 2.0f * f3 + f4) / 6.0f;
}