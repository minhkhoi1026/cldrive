//{"dt":2,"states_new":1,"states_old":0}
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

inline float _f_I_Na_h_inf(const float V) {
  const float theta_h = -45;
  const float sigma_h = -7;

  return pow((1 + exp(-(V - theta_h) / sigma_h)), -1);
}

inline float _f_I_Na_tau_h(const float V) {
  const float theta_th = -40.5f;
  const float sigma_th = -6;

  return 0.1f + 0.75f * pow((1 + exp(-(V - theta_th) / sigma_th)), -1);
}

inline float _f_I_Na_dh_dt(const float h, const float V) {
  return (_f_I_Na_h_inf(V) - h) / _f_I_Na_tau_h(V);
}

inline float _f_n_inf(const float V) {
  const float theta_n = -33;
  const float sigma_n = 10;

  return pow(1 + exp(-(V - theta_n) / sigma_n), -1);
}

inline float _f_tau_n(const float V) {
  const float theta_tn = -33;
  const float sigma_tn = -15;

  return 0.1f + 0.5f * pow(1 + exp(-(V - theta_tn) / sigma_tn), -1);
}

inline float _f_dn_dt(const float n, const float V) {
  return (_f_n_inf(V) - n) / _f_tau_n(V);
}

inline float _f_z_inf(const float V) {
  const float theta_z = -39;
  const float sigma_z = 5;

  return pow(1 + exp(-(V - theta_z) / sigma_z), -1);
}

inline float _f_dz_dt(const float z, const float V) {
  const float tau_z = 75;

  return (_f_z_inf(V) - z) / tau_z;
}

inline float _f_s_inf(const float V) {
  const float theta_s = -20;
  const float sigma_s = 2;

  return pow(1 + exp(-(V - theta_s) / sigma_s), -1);
}

inline float _f_dsAMPA_dt(const float s_AMPA, const float V) {
  const float k_fP = 1;
  const float tau_AMPA = 5;

  return k_fP * _f_s_inf(V) * (1 - s_AMPA) - (s_AMPA / tau_AMPA);
}

inline float _f_dxNMDA_dt(const float x_NMDA, const float V) {
  const float k_xN = 1;
  const float tau2_NMDA = 14.3f;

  return k_xN * _f_s_inf(V) * (1 - x_NMDA) - (1 - _f_s_inf(V)) * x_NMDA / tau2_NMDA;
}

kernel void f_dxNMDA_dt(global struct state* states_old, global struct state* states_new, const float dt) {
  const unsigned int idx = get_global_id(0);

  struct state state_0 = states_old[hook(0, idx)];

  float f1, f2, f3, f4;

  f1 = _f_dxNMDA_dt(state_0.x_NMDA, state_0.V);
  f2 = _f_dxNMDA_dt(state_0.x_NMDA + dt * f1 / 2.0f, state_0.V);
  f3 = _f_dxNMDA_dt(state_0.x_NMDA + dt * f2 / 2.0f, state_0.V);
  f4 = _f_dxNMDA_dt(state_0.x_NMDA + dt * f3, state_0.V);

  states_new[hook(1, idx)].x_NMDA = state_0.x_NMDA + dt * (f1 + 2.0f * f2 + 2.0f * f3 + f4) / 6.0f;
}