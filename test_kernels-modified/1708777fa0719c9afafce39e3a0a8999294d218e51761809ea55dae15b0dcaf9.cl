//{"E_star":3,"E_star_loc":13,"I":6,"I_loc":16,"R":7,"R_loc":17,"R_star":4,"R_star_loc":14,"S":5,"S_loc":15,"S_star":2,"S_star_loc":12,"nLoc":1,"nTpt":0,"output":11,"p_ir":10,"p_ir_loc":20,"p_rs":9,"p_rs_loc":19,"p_se":8,"p_se_loc":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline double logFactorial(int n) {
  if (n != 0) {
    return (0.5 * log(6.283185 * n) + n * log(1.0 * n) - n);
  }
  return (0);
}

inline double logChoose(int n, int x) {
  if ((x != 0) && (n != 0)) {
    return (logFactorial(n) - logFactorial(x) - logFactorial(n - x));
  }
  return (0.0);
}

inline double dbinom(int x, int n, double p) {
  if (n != 0 && p != 1.0 && p != 0.0) {
    return (logChoose(n, x) + x * log(p) + (n - x) * log(1 - p));
  } else if (n == 0) {
    return (x == 0 ? 0.0 : -(__builtin_inff()));
  } else if (p == 0.0) {
    return (x == 0 ? 0.0 : -(__builtin_inff()));
  } else if (p == 1.0) {
    return (x == n ? 0.0 : -(__builtin_inff()));
  }
  return (-(__builtin_inff()));
}

kernel void FC_R_Star_Part1(int nTpt, int nLoc, global int* S_star, global int* E_star, global int* R_star, global int* S, global int* I, global int* R, global double* p_se, global double* p_rs, global double* p_ir, global double* output, local int* S_star_loc, local int* E_star_loc, local int* R_star_loc, local int* S_loc, local int* I_loc, local int* R_loc, local double* p_se_loc, local double* p_rs_loc, local double* p_ir_loc) {
  size_t globalId = get_global_id(0);
  int i;
  int totalSize = nLoc * nTpt;
  size_t localId = get_local_id(0);
  size_t localSize = get_local_size(0);
  size_t groupId = get_group_id(0);
  double partialResult = 0.0;

  if (globalId < totalSize) {
    S_star_loc[hook(12, localId)] = S_star[hook(2, globalId)];
    E_star_loc[hook(13, localId)] = E_star[hook(3, globalId)];
    R_star_loc[hook(14, localId)] = R_star[hook(4, globalId)];
    S_loc[hook(15, localId)] = S[hook(5, globalId)];
    I_loc[hook(16, localId)] = I[hook(6, globalId)];
    R_loc[hook(17, localId)] = R[hook(7, globalId)];
    p_se_loc[hook(18, localId)] = p_se[hook(8, globalId)];
    p_rs_loc[hook(19, localId)] = p_rs[hook(9, globalId % nTpt)];
    p_ir_loc[hook(20, localId)] = p_ir[hook(10, globalId % nTpt)];

    if ((R_star_loc[hook(14, localId)] >= 0) && (R_star_loc[hook(14, localId)] <= I_loc[hook(16, localId)]) && (S_star_loc[hook(12, localId)] <= R_loc[hook(17, localId)])) {
      partialResult = ((logChoose(I_loc[hook(16, localId)], R_star_loc[hook(14, localId)]) + R_star_loc[hook(14, localId)] * log(p_ir_loc[hook(20, localId)]) + (I_loc[hook(16, localId)] - R_star_loc[hook(14, localId)]) * log(1 - p_ir_loc[hook(20, localId)])) + dbinom(S_star_loc[hook(12, localId)], R_loc[hook(17, localId)], p_rs_loc[hook(19, localId)]) + dbinom(E_star_loc[hook(13, localId)], S_loc[hook(15, localId)], p_se_loc[hook(18, localId)]));
    } else {
      partialResult = -(__builtin_inff());
    }
  }
  p_rs_loc[hook(19, localId)] = partialResult;

  barrier(0x01);
  for (i = localSize / 2; i > 0; i >>= 1) {
    if (localId < i) {
      p_rs_loc[hook(19, localId)] += p_rs_loc[hook(19, localId + i)];
    }
    barrier(0x01);
  }
  if (localId == 0) {
    output[hook(11, groupId)] = p_rs_loc[hook(19, localId)];
  }
}