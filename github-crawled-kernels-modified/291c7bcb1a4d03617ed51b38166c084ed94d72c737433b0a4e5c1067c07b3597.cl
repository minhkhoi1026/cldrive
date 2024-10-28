//{"d_com":4,"d_finavalu":2,"d_initvalu":1,"d_params":3,"timeinst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void kernel_ecc(float timeinst, global float* d_initvalu, global float* d_finavalu, int valu_offset, global float* d_params) {
  float cycleLength;

  int offset_1;
  int offset_2;
  int offset_3;
  int offset_4;
  int offset_5;
  int offset_6;
  int offset_7;
  int offset_8;
  int offset_9;
  int offset_10;
  int offset_11;
  int offset_12;
  int offset_13;
  int offset_14;
  int offset_15;
  int offset_16;
  int offset_17;
  int offset_18;
  int offset_19;
  int offset_20;
  int offset_21;
  int offset_22;
  int offset_23;
  int offset_24;
  int offset_25;
  int offset_26;
  int offset_27;
  int offset_28;
  int offset_29;
  int offset_30;
  int offset_31;
  int offset_32;
  int offset_33;
  int offset_34;
  int offset_35;
  int offset_36;
  int offset_37;
  int offset_38;
  int offset_39;
  int offset_40;
  int offset_41;
  int offset_42;
  int offset_43;
  int offset_44;
  int offset_45;
  int offset_46;

  float d_initvalu_1;
  float d_initvalu_2;
  float d_initvalu_3;
  float d_initvalu_4;
  float d_initvalu_5;
  float d_initvalu_6;
  float d_initvalu_7;
  float d_initvalu_8;
  float d_initvalu_9;
  float d_initvalu_10;
  float d_initvalu_11;
  float d_initvalu_12;
  float d_initvalu_13;
  float d_initvalu_14;
  float d_initvalu_15;
  float d_initvalu_16;
  float d_initvalu_17;
  float d_initvalu_18;
  float d_initvalu_19;
  float d_initvalu_20;
  float d_initvalu_21;

  float d_initvalu_23;
  float d_initvalu_24;
  float d_initvalu_25;
  float d_initvalu_26;
  float d_initvalu_27;
  float d_initvalu_28;
  float d_initvalu_29;
  float d_initvalu_30;
  float d_initvalu_31;
  float d_initvalu_32;
  float d_initvalu_33;
  float d_initvalu_34;
  float d_initvalu_35;
  float d_initvalu_36;
  float d_initvalu_37;
  float d_initvalu_38;
  float d_initvalu_39;
  float d_initvalu_40;
  float pi;

  float R;
  float Frdy;
  float Temp;
  float FoRT;
  float Cmem;
  float Qpow;

  float cellLength;
  float cellRadius;
  float Vcell;
  float Vmyo;
  float Vsr;
  float Vsl;
  float Vjunc;

  float J_ca_juncsl;
  float J_ca_slmyo;
  float J_na_juncsl;
  float J_na_slmyo;

  float Fjunc;
  float Fsl;
  float Fjunc_CaL;
  float Fsl_CaL;

  float Cli;
  float Clo;
  float Ko;
  float Nao;
  float Cao;
  float Mgi;

  float ena_junc;
  float ena_sl;
  float ek;
  float eca_junc;
  float eca_sl;
  float ecl;

  float GNa;
  float GNaB;
  float IbarNaK;
  float KmNaip;
  float KmKo;

  float pNaK;
  float GtoSlow;
  float GtoFast;
  float gkp;

  float GClCa;
  float GClB;
  float KdClCa;

  float pNa;
  float pCa;
  float pK;

  float Q10CaL;

  float IbarNCX;
  float KmCai;
  float KmCao;
  float KmNai;
  float KmNao;
  float ksat;
  float nu;
  float Kdact;
  float Q10NCX;
  float IbarSLCaP;
  float KmPCa;
  float GCaB;
  float Q10SLCaP;

  float Q10SRCaP;
  float Vmax_SRCaP;
  float Kmf;
  float Kmr;
  float hillSRCaP;
  float ks;
  float koCa;
  float kom;
  float kiCa;
  float kim;
  float ec50SR;

  float Bmax_Naj;
  float Bmax_Nasl;
  float koff_na;
  float kon_na;
  float Bmax_TnClow;
  float koff_tncl;
  float kon_tncl;
  float Bmax_TnChigh;
  float koff_tnchca;
  float kon_tnchca;
  float koff_tnchmg;
  float kon_tnchmg;

  float Bmax_myosin;
  float koff_myoca;
  float kon_myoca;
  float koff_myomg;
  float kon_myomg;
  float Bmax_SR;
  float koff_sr;
  float kon_sr;
  float Bmax_SLlowsl;
  float Bmax_SLlowj;
  float koff_sll;
  float kon_sll;
  float Bmax_SLhighsl;
  float Bmax_SLhighj;
  float koff_slh;
  float kon_slh;
  float Bmax_Csqn;
  float koff_csqn;
  float kon_csqn;

  float am;
  float bm;
  float ah;
  float bh;
  float aj;
  float bj;
  float I_Na_junc;
  float I_Na_sl;

  float I_nabk_junc;
  float I_nabk_sl;

  float sigma;
  float fnak;
  float I_nak_junc;
  float I_nak_sl;
  float I_nak;

  float gkr;
  float xrss;
  float tauxr;
  float rkr;
  float I_kr;

  float pcaks_junc;
  float pcaks_sl;
  float gks_junc;
  float gks_sl;
  float eks;
  float xsss;
  float tauxs;
  float I_ks_junc;
  float I_ks_sl;
  float I_ks;

  float kp_kp;
  float I_kp_junc;
  float I_kp_sl;
  float I_kp;

  float xtoss;
  float ytoss;
  float rtoss;
  float tauxtos;
  float tauytos;
  float taurtos;
  float I_tos;

  float tauxtof;
  float tauytof;
  float I_tof;
  float I_to;

  float aki;
  float bki;
  float kiss;
  float I_ki;

  float I_ClCa_junc;
  float I_ClCa_sl;
  float I_ClCa;
  float I_Clbk;

  float dss;
  float taud;
  float fss;
  float tauf;

  float ibarca_j;
  float ibarca_sl;
  float ibark;
  float ibarna_j;
  float ibarna_sl;
  float I_Ca_junc;
  float I_Ca_sl;
  float I_Ca;
  float I_CaK;
  float I_CaNa_junc;
  float I_CaNa_sl;

  float Ka_junc;
  float Ka_sl;
  float s1_junc;
  float s1_sl;
  float s2_junc;
  float s3_junc;
  float s2_sl;
  float s3_sl;
  float I_ncx_junc;
  float I_ncx_sl;
  float I_ncx;

  float I_pca_junc;
  float I_pca_sl;
  float I_pca;

  float I_cabk_junc;
  float I_cabk_sl;
  float I_cabk;

  float MaxSR;
  float MinSR;
  float kCaSR;
  float koSRCa;
  float kiSRCa;
  float RI;
  float J_SRCarel;
  float J_serca;
  float J_SRleak;

  float J_CaB_cytosol;

  float J_CaB_junction;
  float J_CaB_sl;

  float oneovervsr;

  float I_Na_tot_junc;
  float I_Na_tot_sl;
  float oneovervsl;

  float I_K_tot;

  float I_Ca_tot_junc;
  float I_Ca_tot_sl;

  int state;
  float I_app;
  float V_hold;
  float V_test;
  float V_clamp;
  float R_clamp;

  float I_Na_tot;
  float I_Cl_tot;
  float I_Ca_tot;
  float I_tot;

  cycleLength = d_params[hook(3, 15)];

  offset_1 = valu_offset;
  offset_2 = valu_offset + 1;
  offset_3 = valu_offset + 2;
  offset_4 = valu_offset + 3;
  offset_5 = valu_offset + 4;
  offset_6 = valu_offset + 5;
  offset_7 = valu_offset + 6;
  offset_8 = valu_offset + 7;
  offset_9 = valu_offset + 8;
  offset_10 = valu_offset + 9;
  offset_11 = valu_offset + 10;
  offset_12 = valu_offset + 11;
  offset_13 = valu_offset + 12;
  offset_14 = valu_offset + 13;
  offset_15 = valu_offset + 14;
  offset_16 = valu_offset + 15;
  offset_17 = valu_offset + 16;
  offset_18 = valu_offset + 17;
  offset_19 = valu_offset + 18;
  offset_20 = valu_offset + 19;
  offset_21 = valu_offset + 20;
  offset_22 = valu_offset + 21;
  offset_23 = valu_offset + 22;
  offset_24 = valu_offset + 23;
  offset_25 = valu_offset + 24;
  offset_26 = valu_offset + 25;
  offset_27 = valu_offset + 26;
  offset_28 = valu_offset + 27;
  offset_29 = valu_offset + 28;
  offset_30 = valu_offset + 29;
  offset_31 = valu_offset + 30;
  offset_32 = valu_offset + 31;
  offset_33 = valu_offset + 32;
  offset_34 = valu_offset + 33;
  offset_35 = valu_offset + 34;
  offset_36 = valu_offset + 35;
  offset_37 = valu_offset + 36;
  offset_38 = valu_offset + 37;
  offset_39 = valu_offset + 38;
  offset_40 = valu_offset + 39;
  offset_41 = valu_offset + 40;
  offset_42 = valu_offset + 41;
  offset_43 = valu_offset + 42;
  offset_44 = valu_offset + 43;
  offset_45 = valu_offset + 44;
  offset_46 = valu_offset + 45;

  d_initvalu_1 = d_initvalu[hook(1, offset_1)];
  d_initvalu_2 = d_initvalu[hook(1, offset_2)];
  d_initvalu_3 = d_initvalu[hook(1, offset_3)];
  d_initvalu_4 = d_initvalu[hook(1, offset_4)];
  d_initvalu_5 = d_initvalu[hook(1, offset_5)];
  d_initvalu_6 = d_initvalu[hook(1, offset_6)];
  d_initvalu_7 = d_initvalu[hook(1, offset_7)];
  d_initvalu_8 = d_initvalu[hook(1, offset_8)];
  d_initvalu_9 = d_initvalu[hook(1, offset_9)];
  d_initvalu_10 = d_initvalu[hook(1, offset_10)];
  d_initvalu_11 = d_initvalu[hook(1, offset_11)];
  d_initvalu_12 = d_initvalu[hook(1, offset_12)];
  d_initvalu_13 = d_initvalu[hook(1, offset_13)];
  d_initvalu_14 = d_initvalu[hook(1, offset_14)];
  d_initvalu_15 = d_initvalu[hook(1, offset_15)];
  d_initvalu_16 = d_initvalu[hook(1, offset_16)];
  d_initvalu_17 = d_initvalu[hook(1, offset_17)];
  d_initvalu_18 = d_initvalu[hook(1, offset_18)];
  d_initvalu_19 = d_initvalu[hook(1, offset_19)];
  d_initvalu_20 = d_initvalu[hook(1, offset_20)];
  d_initvalu_21 = d_initvalu[hook(1, offset_21)];

  d_initvalu_23 = d_initvalu[hook(1, offset_23)];
  d_initvalu_24 = d_initvalu[hook(1, offset_24)];
  d_initvalu_25 = d_initvalu[hook(1, offset_25)];
  d_initvalu_26 = d_initvalu[hook(1, offset_26)];
  d_initvalu_27 = d_initvalu[hook(1, offset_27)];
  d_initvalu_28 = d_initvalu[hook(1, offset_28)];
  d_initvalu_29 = d_initvalu[hook(1, offset_29)];
  d_initvalu_30 = d_initvalu[hook(1, offset_30)];
  d_initvalu_31 = d_initvalu[hook(1, offset_31)];
  d_initvalu_32 = d_initvalu[hook(1, offset_32)];
  d_initvalu_33 = d_initvalu[hook(1, offset_33)];
  d_initvalu_34 = d_initvalu[hook(1, offset_34)];
  d_initvalu_35 = d_initvalu[hook(1, offset_35)];
  d_initvalu_36 = d_initvalu[hook(1, offset_36)];
  d_initvalu_37 = d_initvalu[hook(1, offset_37)];
  d_initvalu_38 = d_initvalu[hook(1, offset_38)];
  d_initvalu_39 = d_initvalu[hook(1, offset_39)];
  d_initvalu_40 = d_initvalu[hook(1, offset_40)];
  pi = 3.1416;

  R = 8314;
  Frdy = 96485;
  Temp = 310;
  FoRT = Frdy / R / Temp;
  Cmem = 1.3810e-10;
  Qpow = (Temp - 310) / 10;

  cellLength = 100;
  cellRadius = 10.25;
  Vcell = pi * pow(cellRadius, 2) * cellLength * 1e-15;
  Vmyo = 0.65 * Vcell;
  Vsr = 0.035 * Vcell;
  Vsl = 0.02 * Vcell;
  Vjunc = 0.0539 * 0.01 * Vcell;

  J_ca_juncsl = 1 / 1.2134e12;
  J_ca_slmyo = 1 / 2.68510e11;
  J_na_juncsl = 1 / (1.6382e12 / 3 * 100);
  J_na_slmyo = 1 / (1.8308e10 / 3 * 100);

  Fjunc = 0.11;
  Fsl = 1 - Fjunc;
  Fjunc_CaL = 0.9;
  Fsl_CaL = 1 - Fjunc_CaL;

  Cli = 15;
  Clo = 150;
  Ko = 5.4;
  Nao = 140;
  Cao = 1.8;
  Mgi = 1;

  ena_junc = (1 / FoRT) * log(Nao / d_initvalu_32);
  ena_sl = (1 / FoRT) * log(Nao / d_initvalu_33);
  ek = (1 / FoRT) * log(Ko / d_initvalu_35);
  eca_junc = (1 / FoRT / 2) * log(Cao / d_initvalu_36);
  eca_sl = (1 / FoRT / 2) * log(Cao / d_initvalu_37);
  ecl = (1 / FoRT) * log(Cli / Clo);

  GNa = 16.0;
  GNaB = 0.297e-3;
  IbarNaK = 1.90719;
  KmNaip = 11;
  KmKo = 1.5;

  pNaK = 0.01833;
  GtoSlow = 0.06;
  GtoFast = 0.02;
  gkp = 0.001;

  GClCa = 0.109625;
  GClB = 9e-3;
  KdClCa = 100e-3;

  pNa = 1.5e-8;
  pCa = 5.4e-4;
  pK = 2.7e-7;

  Q10CaL = 1.8;

  IbarNCX = 9.0;
  KmCai = 3.59e-3;
  KmCao = 1.3;
  KmNai = 12.29;
  KmNao = 87.5;
  ksat = 0.27;
  nu = 0.35;
  Kdact = 0.256e-3;
  Q10NCX = 1.57;
  IbarSLCaP = 0.0673;
  KmPCa = 0.5e-3;
  GCaB = 2.513e-4;
  Q10SLCaP = 2.35;

  Q10SRCaP = 2.6;
  Vmax_SRCaP = 2.86e-4;
  Kmf = 0.246e-3;
  Kmr = 1.7;
  hillSRCaP = 1.787;
  ks = 25;
  koCa = 10;
  kom = 0.06;
  kiCa = 0.5;
  kim = 0.005;
  ec50SR = 0.45;

  Bmax_Naj = 7.561;
  Bmax_Nasl = 1.65;
  koff_na = 1e-3;
  kon_na = 0.1e-3;
  Bmax_TnClow = 70e-3;
  koff_tncl = 19.6e-3;
  kon_tncl = 32.7;
  Bmax_TnChigh = 140e-3;
  koff_tnchca = 0.032e-3;
  kon_tnchca = 2.37;
  koff_tnchmg = 3.33e-3;
  kon_tnchmg = 3e-3;

  Bmax_myosin = 140e-3;
  koff_myoca = 0.46e-3;
  kon_myoca = 13.8;
  koff_myomg = 0.057e-3;
  kon_myomg = 0.0157;
  Bmax_SR = 19 * 0.9e-3;
  koff_sr = 60e-3;
  kon_sr = 100;
  Bmax_SLlowsl = 37.38e-3 * Vmyo / Vsl;
  Bmax_SLlowj = 4.62e-3 * Vmyo / Vjunc * 0.1;
  koff_sll = 1300e-3;
  kon_sll = 100;
  Bmax_SLhighsl = 13.35e-3 * Vmyo / Vsl;
  Bmax_SLhighj = 1.65e-3 * Vmyo / Vjunc * 0.1;
  koff_slh = 30e-3;
  kon_slh = 100;
  Bmax_Csqn = 2.7;
  koff_csqn = 65;
  kon_csqn = 100;

  am = 0.32 * (d_initvalu_39 + 47.13) / (1 - exp(-0.1 * (d_initvalu_39 + 47.13)));
  bm = 0.08 * exp(-d_initvalu_39 / 11);
  if (d_initvalu_39 >= -40) {
    ah = 0;
    aj = 0;
    bh = 1 / (0.13 * (1 + exp(-(d_initvalu_39 + 10.66) / 11.1)));
    bj = 0.3 * exp(-2.535e-7 * d_initvalu_39) / (1 + exp(-0.1 * (d_initvalu_39 + 32)));
  } else {
    ah = 0.135 * exp((80 + d_initvalu_39) / -6.8);
    bh = 3.56 * exp(0.079 * d_initvalu_39) + 3.1e5 * exp(0.35 * d_initvalu_39);
    aj = (-127140 * exp(0.2444 * d_initvalu_39) - 3.474e-5 * exp(-0.04391 * d_initvalu_39)) * (d_initvalu_39 + 37.78) / (1 + exp(0.311 * (d_initvalu_39 + 79.23)));
    bj = 0.1212 * exp(-0.01052 * d_initvalu_39) / (1 + exp(-0.1378 * (d_initvalu_39 + 40.14)));
  }
  d_finavalu[hook(2, offset_1)] = am * (1 - d_initvalu_1) - bm * d_initvalu_1;
  d_finavalu[hook(2, offset_2)] = ah * (1 - d_initvalu_2) - bh * d_initvalu_2;
  d_finavalu[hook(2, offset_3)] = aj * (1 - d_initvalu_3) - bj * d_initvalu_3;
  I_Na_junc = Fjunc * GNa * pow(d_initvalu_1, 3) * d_initvalu_2 * d_initvalu_3 * (d_initvalu_39 - ena_junc);
  I_Na_sl = Fsl * GNa * pow(d_initvalu_1, 3) * d_initvalu_2 * d_initvalu_3 * (d_initvalu_39 - ena_sl);

  I_nabk_junc = Fjunc * GNaB * (d_initvalu_39 - ena_junc);
  I_nabk_sl = Fsl * GNaB * (d_initvalu_39 - ena_sl);

  sigma = (exp(Nao / 67.3) - 1) / 7;
  fnak = 1 / (1 + 0.1245 * exp(-0.1 * d_initvalu_39 * FoRT) + 0.0365 * sigma * exp(-d_initvalu_39 * FoRT));
  I_nak_junc = Fjunc * IbarNaK * fnak * Ko / (1 + pow((KmNaip / d_initvalu_32), 4)) / (Ko + KmKo);
  I_nak_sl = Fsl * IbarNaK * fnak * Ko / (1 + pow((KmNaip / d_initvalu_33), 4)) / (Ko + KmKo);
  I_nak = I_nak_junc + I_nak_sl;

  gkr = 0.03 * sqrt(Ko / 5.4);
  xrss = 1 / (1 + exp(-(d_initvalu_39 + 50) / 7.5));
  tauxr = 1 / (0.00138 * (d_initvalu_39 + 7) / (1 - exp(-0.123 * (d_initvalu_39 + 7))) + 6.1e-4 * (d_initvalu_39 + 10) / (exp(0.145 * (d_initvalu_39 + 10)) - 1));
  d_finavalu[hook(2, offset_12)] = (xrss - d_initvalu_12) / tauxr;
  rkr = 1 / (1 + exp((d_initvalu_39 + 33) / 22.4));
  I_kr = gkr * d_initvalu_12 * rkr * (d_initvalu_39 - ek);

  pcaks_junc = -log10(d_initvalu_36) + 3.0;
  pcaks_sl = -log10(d_initvalu_37) + 3.0;
  gks_junc = 0.07 * (0.057 + 0.19 / (1 + exp((-7.2 + pcaks_junc) / 0.6)));
  gks_sl = 0.07 * (0.057 + 0.19 / (1 + exp((-7.2 + pcaks_sl) / 0.6)));
  eks = (1 / FoRT) * log((Ko + pNaK * Nao) / (d_initvalu_35 + pNaK * d_initvalu_34));
  xsss = 1 / (1 + exp(-(d_initvalu_39 - 1.5) / 16.7));
  tauxs = 1 / (7.19e-5 * (d_initvalu_39 + 30) / (1 - exp(-0.148 * (d_initvalu_39 + 30))) + 1.31e-4 * (d_initvalu_39 + 30) / (exp(0.0687 * (d_initvalu_39 + 30)) - 1));
  d_finavalu[hook(2, offset_13)] = (xsss - d_initvalu_13) / tauxs;
  I_ks_junc = Fjunc * gks_junc * pow(d_initvalu_12, 2) * (d_initvalu_39 - eks);
  I_ks_sl = Fsl * gks_sl * pow(d_initvalu_13, 2) * (d_initvalu_39 - eks);
  I_ks = I_ks_junc + I_ks_sl;

  kp_kp = 1 / (1 + exp(7.488 - d_initvalu_39 / 5.98));
  I_kp_junc = Fjunc * gkp * kp_kp * (d_initvalu_39 - ek);
  I_kp_sl = Fsl * gkp * kp_kp * (d_initvalu_39 - ek);
  I_kp = I_kp_junc + I_kp_sl;

  xtoss = 1 / (1 + exp(-(d_initvalu_39 + 3.0) / 15));
  ytoss = 1 / (1 + exp((d_initvalu_39 + 33.5) / 10));
  rtoss = 1 / (1 + exp((d_initvalu_39 + 33.5) / 10));
  tauxtos = 9 / (1 + exp((d_initvalu_39 + 3.0) / 15)) + 0.5;
  tauytos = 3e3 / (1 + exp((d_initvalu_39 + 60.0) / 10)) + 30;
  taurtos = 2800 / (1 + exp((d_initvalu_39 + 60.0) / 10)) + 220;
  d_finavalu[hook(2, offset_8)] = (xtoss - d_initvalu_8) / tauxtos;
  d_finavalu[hook(2, offset_9)] = (ytoss - d_initvalu_9) / tauytos;
  d_finavalu[hook(2, offset_40)] = (rtoss - d_initvalu_40) / taurtos;
  I_tos = GtoSlow * d_initvalu_8 * (d_initvalu_9 + 0.5 * d_initvalu_40) * (d_initvalu_39 - ek);

  tauxtof = 3.5 * exp(-d_initvalu_39 * d_initvalu_39 / 30 / 30) + 1.5;
  tauytof = 20.0 / (1 + exp((d_initvalu_39 + 33.5) / 10)) + 20.0;
  d_finavalu[hook(2, offset_10)] = (xtoss - d_initvalu_10) / tauxtof;
  d_finavalu[hook(2, offset_11)] = (ytoss - d_initvalu_11) / tauytof;
  I_tof = GtoFast * d_initvalu_10 * d_initvalu_11 * (d_initvalu_39 - ek);
  I_to = I_tos + I_tof;

  aki = 1.02 / (1 + exp(0.2385 * (d_initvalu_39 - ek - 59.215)));
  bki = (0.49124 * exp(0.08032 * (d_initvalu_39 + 5.476 - ek)) + exp(0.06175 * (d_initvalu_39 - ek - 594.31))) / (1 + exp(-0.5143 * (d_initvalu_39 - ek + 4.753)));
  kiss = aki / (aki + bki);
  I_ki = 0.9 * sqrt(Ko / 5.4) * kiss * (d_initvalu_39 - ek);

  I_ClCa_junc = Fjunc * GClCa / (1 + KdClCa / d_initvalu_36) * (d_initvalu_39 - ecl);
  I_ClCa_sl = Fsl * GClCa / (1 + KdClCa / d_initvalu_37) * (d_initvalu_39 - ecl);
  I_ClCa = I_ClCa_junc + I_ClCa_sl;
  I_Clbk = GClB * (d_initvalu_39 - ecl);

  dss = 1 / (1 + exp(-(d_initvalu_39 + 14.5) / 6.0));
  taud = dss * (1 - exp(-(d_initvalu_39 + 14.5) / 6.0)) / (0.035 * (d_initvalu_39 + 14.5));
  fss = 1 / (1 + exp((d_initvalu_39 + 35.06) / 3.6)) + 0.6 / (1 + exp((50 - d_initvalu_39) / 20));
  tauf = 1 / (0.0197 * exp(-pow(0.0337 * (d_initvalu_39 + 14.5), 2)) + 0.02);
  d_finavalu[hook(2, offset_4)] = (dss - d_initvalu_4) / taud;
  d_finavalu[hook(2, offset_5)] = (fss - d_initvalu_5) / tauf;
  d_finavalu[hook(2, offset_6)] = 1.7 * d_initvalu_36 * (1 - d_initvalu_6) - 11.9e-3 * d_initvalu_6;
  d_finavalu[hook(2, offset_7)] = 1.7 * d_initvalu_37 * (1 - d_initvalu_7) - 11.9e-3 * d_initvalu_7;

  ibarca_j = pCa * 4 * (d_initvalu_39 * Frdy * FoRT) * (0.341 * d_initvalu_36 * exp(2 * d_initvalu_39 * FoRT) - 0.341 * Cao) / (exp(2 * d_initvalu_39 * FoRT) - 1);
  ibarca_sl = pCa * 4 * (d_initvalu_39 * Frdy * FoRT) * (0.341 * d_initvalu_37 * exp(2 * d_initvalu_39 * FoRT) - 0.341 * Cao) / (exp(2 * d_initvalu_39 * FoRT) - 1);
  ibark = pK * (d_initvalu_39 * Frdy * FoRT) * (0.75 * d_initvalu_35 * exp(d_initvalu_39 * FoRT) - 0.75 * Ko) / (exp(d_initvalu_39 * FoRT) - 1);
  ibarna_j = pNa * (d_initvalu_39 * Frdy * FoRT) * (0.75 * d_initvalu_32 * exp(d_initvalu_39 * FoRT) - 0.75 * Nao) / (exp(d_initvalu_39 * FoRT) - 1);
  ibarna_sl = pNa * (d_initvalu_39 * Frdy * FoRT) * (0.75 * d_initvalu_33 * exp(d_initvalu_39 * FoRT) - 0.75 * Nao) / (exp(d_initvalu_39 * FoRT) - 1);
  I_Ca_junc = (Fjunc_CaL * ibarca_j * d_initvalu_4 * d_initvalu_5 * (1 - d_initvalu_6) * pow(Q10CaL, Qpow)) * 0.45;
  I_Ca_sl = (Fsl_CaL * ibarca_sl * d_initvalu_4 * d_initvalu_5 * (1 - d_initvalu_7) * pow(Q10CaL, Qpow)) * 0.45;
  I_Ca = I_Ca_junc + I_Ca_sl;
  d_finavalu[hook(2, offset_43)] = -I_Ca * Cmem / (Vmyo * 2 * Frdy) * 1e3;
  I_CaK = (ibark * d_initvalu_4 * d_initvalu_5 * (Fjunc_CaL * (1 - d_initvalu_6) + Fsl_CaL * (1 - d_initvalu_7)) * pow(Q10CaL, Qpow)) * 0.45;
  I_CaNa_junc = (Fjunc_CaL * ibarna_j * d_initvalu_4 * d_initvalu_5 * (1 - d_initvalu_6) * pow(Q10CaL, Qpow)) * 0.45;
  I_CaNa_sl = (Fsl_CaL * ibarna_sl * d_initvalu_4 * d_initvalu_5 * (1 - d_initvalu_7) * pow(Q10CaL, Qpow)) * 0.45;

  Ka_junc = 1 / (1 + pow((Kdact / d_initvalu_36), 3));
  Ka_sl = 1 / (1 + pow((Kdact / d_initvalu_37), 3));
  s1_junc = exp(nu * d_initvalu_39 * FoRT) * pow(d_initvalu_32, 3) * Cao;
  s1_sl = exp(nu * d_initvalu_39 * FoRT) * pow(d_initvalu_33, 3) * Cao;
  s2_junc = exp((nu - 1) * d_initvalu_39 * FoRT) * pow(Nao, 3) * d_initvalu_36;
  s3_junc = (KmCai * pow(Nao, 3) * (1 + pow((d_initvalu_32 / KmNai), 3)) + pow(KmNao, 3) * d_initvalu_36 + pow(KmNai, 3) * Cao * (1 + d_initvalu_36 / KmCai) + KmCao * pow(d_initvalu_32, 3) + pow(d_initvalu_32, 3) * Cao + pow(Nao, 3) * d_initvalu_36) * (1 + ksat * exp((nu - 1) * d_initvalu_39 * FoRT));
  s2_sl = exp((nu - 1) * d_initvalu_39 * FoRT) * pow(Nao, 3) * d_initvalu_37;
  s3_sl = (KmCai * pow(Nao, 3) * (1 + pow((d_initvalu_33 / KmNai), 3)) + pow(KmNao, 3) * d_initvalu_37 + pow(KmNai, 3) * Cao * (1 + d_initvalu_37 / KmCai) + KmCao * pow(d_initvalu_33, 3) + pow(d_initvalu_33, 3) * Cao + pow(Nao, 3) * d_initvalu_37) * (1 + ksat * exp((nu - 1) * d_initvalu_39 * FoRT));
  I_ncx_junc = Fjunc * IbarNCX * pow(Q10NCX, Qpow) * Ka_junc * (s1_junc - s2_junc) / s3_junc;
  I_ncx_sl = Fsl * IbarNCX * pow(Q10NCX, Qpow) * Ka_sl * (s1_sl - s2_sl) / s3_sl;
  I_ncx = I_ncx_junc + I_ncx_sl;
  d_finavalu[hook(2, offset_45)] = 2 * I_ncx * Cmem / (Vmyo * 2 * Frdy) * 1e3;

  I_pca_junc = Fjunc * pow(Q10SLCaP, Qpow) * IbarSLCaP * pow(d_initvalu_36, (float)(1.6)) / (pow(KmPCa, (float)(1.6)) + pow(d_initvalu_36, (float)(1.6)));
  I_pca_sl = Fsl * pow(Q10SLCaP, Qpow) * IbarSLCaP * pow(d_initvalu_37, (float)(1.6)) / (pow(KmPCa, (float)(1.6)) + pow(d_initvalu_37, (float)(1.6)));
  I_pca = I_pca_junc + I_pca_sl;
  d_finavalu[hook(2, offset_44)] = -I_pca * Cmem / (Vmyo * 2 * Frdy) * 1e3;

  I_cabk_junc = Fjunc * GCaB * (d_initvalu_39 - eca_junc);
  I_cabk_sl = Fsl * GCaB * (d_initvalu_39 - eca_sl);
  I_cabk = I_cabk_junc + I_cabk_sl;
  d_finavalu[hook(2, offset_46)] = -I_cabk * Cmem / (Vmyo * 2 * Frdy) * 1e3;

  MaxSR = 15;
  MinSR = 1;
  kCaSR = MaxSR - (MaxSR - MinSR) / (1 + pow(ec50SR / d_initvalu_31, (float)(2.5)));
  koSRCa = koCa / kCaSR;
  kiSRCa = kiCa * kCaSR;
  RI = 1 - d_initvalu_14 - d_initvalu_15 - d_initvalu_16;
  d_finavalu[hook(2, offset_14)] = (kim * RI - kiSRCa * d_initvalu_36 * d_initvalu_14) - (koSRCa * pow(d_initvalu_36, 2) * d_initvalu_14 - kom * d_initvalu_15);
  d_finavalu[hook(2, offset_15)] = (koSRCa * pow(d_initvalu_36, 2) * d_initvalu_14 - kom * d_initvalu_15) - (kiSRCa * d_initvalu_36 * d_initvalu_15 - kim * d_initvalu_16);
  d_finavalu[hook(2, offset_16)] = (kiSRCa * d_initvalu_36 * d_initvalu_15 - kim * d_initvalu_16) - (kom * d_initvalu_16 - koSRCa * pow(d_initvalu_36, 2) * RI);
  J_SRCarel = ks * d_initvalu_15 * (d_initvalu_31 - d_initvalu_36);
  J_serca = pow(Q10SRCaP, Qpow) * Vmax_SRCaP * (pow((d_initvalu_38 / Kmf), hillSRCaP) - pow((d_initvalu_31 / Kmr), hillSRCaP)) / (1 + pow((d_initvalu_38 / Kmf), hillSRCaP) + pow((d_initvalu_31 / Kmr), hillSRCaP));
  J_SRleak = 5.348e-6 * (d_initvalu_31 - d_initvalu_36);

  d_finavalu[hook(2, offset_17)] = kon_na * d_initvalu_32 * (Bmax_Naj - d_initvalu_17) - koff_na * d_initvalu_17;
  d_finavalu[hook(2, offset_18)] = kon_na * d_initvalu_33 * (Bmax_Nasl - d_initvalu_18) - koff_na * d_initvalu_18;

  d_finavalu[hook(2, offset_19)] = kon_tncl * d_initvalu_38 * (Bmax_TnClow - d_initvalu_19) - koff_tncl * d_initvalu_19;
  d_finavalu[hook(2, offset_20)] = kon_tnchca * d_initvalu_38 * (Bmax_TnChigh - d_initvalu_20 - d_initvalu_21) - koff_tnchca * d_initvalu_20;
  d_finavalu[hook(2, offset_21)] = kon_tnchmg * Mgi * (Bmax_TnChigh - d_initvalu_20 - d_initvalu_21) - koff_tnchmg * d_initvalu_21;
  d_finavalu[hook(2, offset_22)] = 0;
  d_finavalu[hook(2, offset_23)] = kon_myoca * d_initvalu_38 * (Bmax_myosin - d_initvalu_23 - d_initvalu_24) - koff_myoca * d_initvalu_23;
  d_finavalu[hook(2, offset_24)] = kon_myomg * Mgi * (Bmax_myosin - d_initvalu_23 - d_initvalu_24) - koff_myomg * d_initvalu_24;
  d_finavalu[hook(2, offset_25)] = kon_sr * d_initvalu_38 * (Bmax_SR - d_initvalu_25) - koff_sr * d_initvalu_25;
  J_CaB_cytosol = d_finavalu[hook(2, offset_19)] + d_finavalu[hook(2, offset_20)] + d_finavalu[hook(2, offset_21)] + d_finavalu[hook(2, offset_22)] + d_finavalu[hook(2, offset_23)] + d_finavalu[hook(2, offset_24)] + d_finavalu[hook(2, offset_25)];

  d_finavalu[hook(2, offset_26)] = kon_sll * d_initvalu_36 * (Bmax_SLlowj - d_initvalu_26) - koff_sll * d_initvalu_26;
  d_finavalu[hook(2, offset_27)] = kon_sll * d_initvalu_37 * (Bmax_SLlowsl - d_initvalu_27) - koff_sll * d_initvalu_27;
  d_finavalu[hook(2, offset_28)] = kon_slh * d_initvalu_36 * (Bmax_SLhighj - d_initvalu_28) - koff_slh * d_initvalu_28;
  d_finavalu[hook(2, offset_29)] = kon_slh * d_initvalu_37 * (Bmax_SLhighsl - d_initvalu_29) - koff_slh * d_initvalu_29;
  J_CaB_junction = d_finavalu[hook(2, offset_26)] + d_finavalu[hook(2, offset_28)];
  J_CaB_sl = d_finavalu[hook(2, offset_27)] + d_finavalu[hook(2, offset_29)];

  d_finavalu[hook(2, offset_30)] = kon_csqn * d_initvalu_31 * (Bmax_Csqn - d_initvalu_30) - koff_csqn * d_initvalu_30;
  oneovervsr = 1 / Vsr;
  d_finavalu[hook(2, offset_31)] = J_serca * Vmyo * oneovervsr - (J_SRleak * Vmyo * oneovervsr + J_SRCarel) - d_finavalu[hook(2, offset_30)];

  I_Na_tot_junc = I_Na_junc + I_nabk_junc + 3 * I_ncx_junc + 3 * I_nak_junc + I_CaNa_junc;
  I_Na_tot_sl = I_Na_sl + I_nabk_sl + 3 * I_ncx_sl + 3 * I_nak_sl + I_CaNa_sl;
  d_finavalu[hook(2, offset_32)] = -I_Na_tot_junc * Cmem / (Vjunc * Frdy) + J_na_juncsl / Vjunc * (d_initvalu_33 - d_initvalu_32) - d_finavalu[hook(2, offset_17)];
  oneovervsl = 1 / Vsl;
  d_finavalu[hook(2, offset_33)] = -I_Na_tot_sl * Cmem * oneovervsl / Frdy + J_na_juncsl * oneovervsl * (d_initvalu_32 - d_initvalu_33) + J_na_slmyo * oneovervsl * (d_initvalu_34 - d_initvalu_33) - d_finavalu[hook(2, offset_18)];
  d_finavalu[hook(2, offset_34)] = J_na_slmyo / Vmyo * (d_initvalu_33 - d_initvalu_34);

  I_K_tot = I_to + I_kr + I_ks + I_ki - 2 * I_nak + I_CaK + I_kp;
  d_finavalu[hook(2, offset_35)] = 0;

  I_Ca_tot_junc = I_Ca_junc + I_cabk_junc + I_pca_junc - 2 * I_ncx_junc;
  I_Ca_tot_sl = I_Ca_sl + I_cabk_sl + I_pca_sl - 2 * I_ncx_sl;
  d_finavalu[hook(2, offset_36)] = -I_Ca_tot_junc * Cmem / (Vjunc * 2 * Frdy) + J_ca_juncsl / Vjunc * (d_initvalu_37 - d_initvalu_36) - J_CaB_junction + (J_SRCarel)*Vsr / Vjunc + J_SRleak * Vmyo / Vjunc;
  d_finavalu[hook(2, offset_37)] = -I_Ca_tot_sl * Cmem / (Vsl * 2 * Frdy) + J_ca_juncsl / Vsl * (d_initvalu_36 - d_initvalu_37) + J_ca_slmyo / Vsl * (d_initvalu_38 - d_initvalu_37) - J_CaB_sl;
  d_finavalu[hook(2, offset_38)] = -J_serca - J_CaB_cytosol + J_ca_slmyo / Vmyo * (d_initvalu_37 - d_initvalu_38);

  state = 1;
  switch (state) {
    case 0:
      I_app = 0;
      break;
    case 1:
      if (fmod(timeinst, cycleLength) <= 5) {
        I_app = 9.5;
      } else {
        I_app = 0.0;
      }
      break;
    case 2:
      V_hold = -55;
      V_test = 0;
      if (timeinst > 0.5 & timeinst < 200.5) {
        V_clamp = V_test;
      } else {
        V_clamp = V_hold;
      }
      R_clamp = 0.04;
      I_app = (V_clamp - d_initvalu_39) / R_clamp;
      break;
  }

  I_Na_tot = I_Na_tot_junc + I_Na_tot_sl;
  I_Cl_tot = I_ClCa + I_Clbk;
  I_Ca_tot = I_Ca_tot_junc + I_Ca_tot_sl;
  I_tot = I_Na_tot + I_Cl_tot + I_Ca_tot + I_K_tot;
  d_finavalu[hook(2, offset_39)] = -(I_tot - I_app);

  d_finavalu[hook(2, offset_41)] = 0;
  d_finavalu[hook(2, offset_42)] = 0;
}

void kernel_cam(float timeinst, global float* d_initvalu, global float* d_finavalu, int valu_offset, global float* d_params, int params_offset, global float* d_com, int com_offset, float Ca) {
  float Btot;
  float CaMKIItot;
  float CaNtot;
  float PP1tot;
  float K;
  float Mg;

  int offset_1;
  int offset_2;
  int offset_3;
  int offset_4;
  int offset_5;
  int offset_6;
  int offset_7;
  int offset_8;
  int offset_9;
  int offset_10;
  int offset_11;
  int offset_12;
  int offset_13;
  int offset_14;
  int offset_15;

  float CaM;
  float Ca2CaM;
  float Ca4CaM;
  float CaMB;
  float Ca2CaMB;
  float Ca4CaMB;
  float Pb2;
  float Pb;
  float Pt;
  float Pt2;
  float Pa;
  float Ca4CaN;
  float CaMCa4CaN;
  float Ca2CaMCa4CaN;
  float Ca4CaMCa4CaN;

  float Kd02;
  float Kd24;
  float k20;
  float k02;
  float k42;
  float k24;

  float k0Boff;
  float k0Bon;
  float k2Boff;
  float k2Bon;
  float k4Boff;
  float k4Bon;

  float k20B;
  float k02B;
  float k42B;
  float k24B;

  float kbi;
  float kib;
  float kpp1;
  float Kmpp1;
  float kib2;
  float kb2i;
  float kb24;
  float kb42;
  float kta;
  float kat;
  float kt42;
  float kt24;
  float kat2;
  float kt2a;

  float kcanCaoff;
  float kcanCaon;
  float kcanCaM4on;
  float kcanCaM4off;
  float kcanCaM2on;
  float kcanCaM2off;
  float kcanCaM0on;
  float kcanCaM0off;
  float k02can;
  float k20can;
  float k24can;
  float k42can;

  float rcn02;
  float rcn24;

  float B;
  float rcn02B;
  float rcn24B;
  float rcn0B;
  float rcn2B;
  float rcn4B;

  float Ca2CaN;
  float rcnCa4CaN;
  float rcn02CaN;
  float rcn24CaN;
  float rcn0CaN;
  float rcn2CaN;
  float rcn4CaN;

  float Pix;
  float rcnCKib2;
  float rcnCKb2b;
  float rcnCKib;
  float T;
  float kbt;
  float rcnCKbt;
  float rcnCKtt2;
  float rcnCKta;
  float rcnCKt2a;
  float rcnCKt2b2;
  float rcnCKai;

  float dCaM;
  float dCa2CaM;
  float dCa4CaM;
  float dCaMB;
  float dCa2CaMB;
  float dCa4CaMB;

  float dPb2;
  float dPb;
  float dPt;
  float dPt2;
  float dPa;

  float dCa4CaN;
  float dCaMCa4CaN;
  float dCa2CaMCa4CaN;
  float dCa4CaMCa4CaN;

  Btot = d_params[hook(3, params_offset + 1)];
  CaMKIItot = d_params[hook(3, params_offset + 2)];
  CaNtot = d_params[hook(3, params_offset + 3)];
  PP1tot = d_params[hook(3, params_offset + 4)];
  K = d_params[hook(3, 16)];
  Mg = d_params[hook(3, 17)];

  offset_1 = valu_offset;
  offset_2 = valu_offset + 1;
  offset_3 = valu_offset + 2;
  offset_4 = valu_offset + 3;
  offset_5 = valu_offset + 4;
  offset_6 = valu_offset + 5;
  offset_7 = valu_offset + 6;
  offset_8 = valu_offset + 7;
  offset_9 = valu_offset + 8;
  offset_10 = valu_offset + 9;
  offset_11 = valu_offset + 10;
  offset_12 = valu_offset + 11;
  offset_13 = valu_offset + 12;
  offset_14 = valu_offset + 13;
  offset_15 = valu_offset + 14;

  CaM = d_initvalu[hook(1, offset_1)];
  Ca2CaM = d_initvalu[hook(1, offset_2)];
  Ca4CaM = d_initvalu[hook(1, offset_3)];
  CaMB = d_initvalu[hook(1, offset_4)];
  Ca2CaMB = d_initvalu[hook(1, offset_5)];
  Ca4CaMB = d_initvalu[hook(1, offset_6)];
  Pb2 = d_initvalu[hook(1, offset_7)];
  Pb = d_initvalu[hook(1, offset_8)];
  Pt = d_initvalu[hook(1, offset_9)];
  Pt2 = d_initvalu[hook(1, offset_10)];
  Pa = d_initvalu[hook(1, offset_11)];
  Ca4CaN = d_initvalu[hook(1, offset_12)];
  CaMCa4CaN = d_initvalu[hook(1, offset_13)];
  Ca2CaMCa4CaN = d_initvalu[hook(1, offset_14)];
  Ca4CaMCa4CaN = d_initvalu[hook(1, offset_15)];

  if (Mg <= 1) {
    Kd02 = 0.0025 * (1 + K / 0.94 - Mg / 0.012) * (1 + K / 8.1 + Mg / 0.022);
    Kd24 = 0.128 * (1 + K / 0.64 + Mg / 0.0014) * (1 + K / 13.0 - Mg / 0.153);
  } else {
    Kd02 = 0.0025 * (1 + K / 0.94 - 1 / 0.012 + (Mg - 1) / 0.060) * (1 + K / 8.1 + 1 / 0.022 + (Mg - 1) / 0.068);
    Kd24 = 0.128 * (1 + K / 0.64 + 1 / 0.0014 + (Mg - 1) / 0.005) * (1 + K / 13.0 - 1 / 0.153 + (Mg - 1) / 0.150);
  }
  k20 = 10;
  k02 = k20 / Kd02;
  k42 = 500;
  k24 = k42 / Kd24;

  k0Boff = 0.0014;
  k0Bon = k0Boff / 0.2;
  k2Boff = k0Boff / 100;
  k2Bon = k0Bon;
  k4Boff = k2Boff;
  k4Bon = k0Bon;

  k20B = k20 / 100;
  k02B = k02;
  k42B = k42;
  k24B = k24;

  kbi = 2.2;
  kib = kbi / 33.5e-3;
  kpp1 = 1.72;
  Kmpp1 = 11.5;
  kib2 = kib;
  kb2i = kib2 * 5;
  kb24 = k24;
  kb42 = k42 * 33.5e-3 / 5;
  kta = kbi / 1000;
  kat = kib;
  kt42 = k42 * 33.5e-6 / 5;
  kt24 = k24;
  kat2 = kib;
  kt2a = kib * 5;

  kcanCaoff = 1;
  kcanCaon = kcanCaoff / 0.5;
  kcanCaM4on = 46;
  kcanCaM4off = 0.0013;
  kcanCaM2on = kcanCaM4on;
  kcanCaM2off = 2508 * kcanCaM4off;
  kcanCaM0on = kcanCaM4on;
  kcanCaM0off = 165 * kcanCaM2off;
  k02can = k02;
  k20can = k20 / 165;
  k24can = k24;
  k42can = k20 / 2508;

  rcn02 = k02 * pow(Ca, 2) * CaM - k20 * Ca2CaM;
  rcn24 = k24 * pow(Ca, 2) * Ca2CaM - k42 * Ca4CaM;

  B = Btot - CaMB - Ca2CaMB - Ca4CaMB;
  rcn02B = k02B * pow(Ca, 2) * CaMB - k20B * Ca2CaMB;
  rcn24B = k24B * pow(Ca, 2) * Ca2CaMB - k42B * Ca4CaMB;
  rcn0B = k0Bon * CaM * B - k0Boff * CaMB;
  rcn2B = k2Bon * Ca2CaM * B - k2Boff * Ca2CaMB;
  rcn4B = k4Bon * Ca4CaM * B - k4Boff * Ca4CaMB;

  Ca2CaN = CaNtot - Ca4CaN - CaMCa4CaN - Ca2CaMCa4CaN - Ca4CaMCa4CaN;
  rcnCa4CaN = kcanCaon * pow(Ca, 2) * Ca2CaN - kcanCaoff * Ca4CaN;
  rcn02CaN = k02can * pow(Ca, 2) * CaMCa4CaN - k20can * Ca2CaMCa4CaN;
  rcn24CaN = k24can * pow(Ca, 2) * Ca2CaMCa4CaN - k42can * Ca4CaMCa4CaN;
  rcn0CaN = kcanCaM0on * CaM * Ca4CaN - kcanCaM0off * CaMCa4CaN;
  rcn2CaN = kcanCaM2on * Ca2CaM * Ca4CaN - kcanCaM2off * Ca2CaMCa4CaN;
  rcn4CaN = kcanCaM4on * Ca4CaM * Ca4CaN - kcanCaM4off * Ca4CaMCa4CaN;

  Pix = 1 - Pb2 - Pb - Pt - Pt2 - Pa;
  rcnCKib2 = kib2 * Ca2CaM * Pix - kb2i * Pb2;
  rcnCKb2b = kb24 * pow(Ca, 2) * Pb2 - kb42 * Pb;
  rcnCKib = kib * Ca4CaM * Pix - kbi * Pb;
  T = Pb + Pt + Pt2 + Pa;
  kbt = 0.055 * T + 0.0074 * pow(T, 2) + 0.015 * pow(T, 3);
  rcnCKbt = kbt * Pb - kpp1 * PP1tot * Pt / (Kmpp1 + CaMKIItot * Pt);
  rcnCKtt2 = kt42 * Pt - kt24 * pow(Ca, 2) * Pt2;
  rcnCKta = kta * Pt - kat * Ca4CaM * Pa;
  rcnCKt2a = kt2a * Pt2 - kat2 * Ca2CaM * Pa;
  rcnCKt2b2 = kpp1 * PP1tot * Pt2 / (Kmpp1 + CaMKIItot * Pt2);
  rcnCKai = kpp1 * PP1tot * Pa / (Kmpp1 + CaMKIItot * Pa);

  dCaM = 1e-3 * (-rcn02 - rcn0B - rcn0CaN);
  dCa2CaM = 1e-3 * (rcn02 - rcn24 - rcn2B - rcn2CaN + CaMKIItot * (-rcnCKib2 + rcnCKt2a));
  dCa4CaM = 1e-3 * (rcn24 - rcn4B - rcn4CaN + CaMKIItot * (-rcnCKib + rcnCKta));
  dCaMB = 1e-3 * (rcn0B - rcn02B);
  dCa2CaMB = 1e-3 * (rcn02B + rcn2B - rcn24B);
  dCa4CaMB = 1e-3 * (rcn24B + rcn4B);

  dPb2 = 1e-3 * (rcnCKib2 - rcnCKb2b + rcnCKt2b2);
  dPb = 1e-3 * (rcnCKib + rcnCKb2b - rcnCKbt);
  dPt = 1e-3 * (rcnCKbt - rcnCKta - rcnCKtt2);
  dPt2 = 1e-3 * (rcnCKtt2 - rcnCKt2a - rcnCKt2b2);
  dPa = 1e-3 * (rcnCKta + rcnCKt2a - rcnCKai);

  dCa4CaN = 1e-3 * (rcnCa4CaN - rcn0CaN - rcn2CaN - rcn4CaN);
  dCaMCa4CaN = 1e-3 * (rcn0CaN - rcn02CaN);
  dCa2CaMCa4CaN = 1e-3 * (rcn2CaN + rcn02CaN - rcn24CaN);
  dCa4CaMCa4CaN = 1e-3 * (rcn4CaN + rcn24CaN);

  d_finavalu[hook(2, offset_1)] = dCaM;
  d_finavalu[hook(2, offset_2)] = dCa2CaM;
  d_finavalu[hook(2, offset_3)] = dCa4CaM;
  d_finavalu[hook(2, offset_4)] = dCaMB;
  d_finavalu[hook(2, offset_5)] = dCa2CaMB;
  d_finavalu[hook(2, offset_6)] = dCa4CaMB;
  d_finavalu[hook(2, offset_7)] = dPb2;
  d_finavalu[hook(2, offset_8)] = dPb;
  d_finavalu[hook(2, offset_9)] = dPt;
  d_finavalu[hook(2, offset_10)] = dPt2;
  d_finavalu[hook(2, offset_11)] = dPa;
  d_finavalu[hook(2, offset_12)] = dCa4CaN;
  d_finavalu[hook(2, offset_13)] = dCaMCa4CaN;
  d_finavalu[hook(2, offset_14)] = dCa2CaMCa4CaN;
  d_finavalu[hook(2, offset_15)] = dCa4CaMCa4CaN;

  d_finavalu[hook(2, com_offset)] = 1e-3 * (2 * CaMKIItot * (rcnCKtt2 - rcnCKb2b) - 2 * (rcn02 + rcn24 + rcn02B + rcn24B + rcnCa4CaN + rcn02CaN + rcn24CaN));
}

kernel void kernel_gpu_opencl(int timeinst, global float* d_initvalu, global float* d_finavalu, global float* d_params, global float* d_com) {
  int bx;
  int tx;

  int valu_offset;
  int params_offset;
  int com_offset;

  float CaDyad;
  float CaSL;
  float CaCyt;
  bx = get_group_id(0);
  tx = get_local_id(0);

  if (bx == 0) {
    if (tx == 0) {
      valu_offset = 0;

      kernel_ecc(timeinst, d_initvalu, d_finavalu, valu_offset, d_params);
    }

  }

  else if (bx == 1) {
    if (tx == 0) {
      valu_offset = 46;
      params_offset = 0;
      com_offset = 0;
      CaDyad = d_initvalu[hook(1, 35)] * 1e3;

      kernel_cam(timeinst, d_initvalu, d_finavalu, valu_offset, d_params, params_offset, d_com, com_offset, CaDyad);

      valu_offset = 61;
      params_offset = 5;
      com_offset = 1;
      CaSL = d_initvalu[hook(1, 36)] * 1e3;

      kernel_cam(timeinst, d_initvalu, d_finavalu, valu_offset, d_params, params_offset, d_com, com_offset, CaSL);

      valu_offset = 76;
      params_offset = 10;
      com_offset = 2;
      CaCyt = d_initvalu[hook(1, 37)] * 1e3;

      kernel_cam(timeinst, d_initvalu, d_finavalu, valu_offset, d_params, params_offset, d_com, com_offset, CaCyt);
    }
  }
}