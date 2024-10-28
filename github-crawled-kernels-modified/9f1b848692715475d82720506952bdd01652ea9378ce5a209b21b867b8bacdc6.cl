//{"FE":4,"LATOMS":5,"LCLJS":6,"atoms":1,"cLJs":2,"nAtoms":0,"poss":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 getCoulomb(float4 atom, float3 pos) {
  float3 dp = pos - atom.xyz;
  float ir2 = 1.0f / (dot(dp, dp) + 1e-4f);
  float ir = sqrt(ir2);
  float E = atom.w * sqrt(ir2);
  return (float4)(dp * (E * ir2), E);
}

float4 getLJ(float3 apos, float2 cLJ, float3 pos) {
  float3 dp = pos - apos;
  float ir2 = 1.0f / (dot(dp, dp) + 1e-4f);
  float ir6 = ir2 * ir2 * ir2;
  float E = (cLJ.y * ir6 - cLJ.x) * ir6;
  float3 F = ((12.0f * cLJ.y * ir6 - 6.0f * cLJ.x) * ir6 * ir2) * dp;
  return (float4)(F, E);
}

float4 getMorse(float3 dp, float3 REA) {
  float r = sqrt(dot(dp, dp) + 1e-4f);
  float expar = exp(REA.z * (r - REA.x));
  float E = REA.y * expar * (expar - 2);
  float fr = REA.y * expar * (expar - 1) * 2 * REA.z;
  return (float4)(dp * (fr / r), E);
}

float8 getLJC(float4 atom, float2 cLJ, float3 pos) {
  float3 dp = pos - atom.xyz;
  float ir2 = 1.0 / (dot(dp, dp) + 1e-4f);
  float ir6 = ir2 * ir2 * ir2;
  float ELJ = (cLJ.y * ir6 - cLJ.x) * ir6;
  float3 FLJ = ((12.0f * cLJ.y * ir6 - 6.0f * cLJ.x) * ir6 * ir2) * dp;
  float ir = sqrt(ir2);
  float Eel = atom.w * sqrt(ir2);
  return (float8)(FLJ, ELJ, dp * (Eel * ir2), Eel);
}

kernel void evalLJ(const int nAtoms, global float4* atoms, global float2* cLJs, global float4* poss, global float4* FE) {
  local float4 LATOMS[32];
  local float2 LCLJS[32];
  const int iG = get_global_id(0);
  const int iL = get_local_id(0);
  const int nL = get_local_size(0);

  float3 pos = poss[hook(3, iG)].xyz;
  float4 fe = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  for (int i0 = 0; i0 < nAtoms; i0 += nL) {
    int i = i0 + iL;
    if (i >= nAtoms)
      break;

    LATOMS[hook(5, iL)] = atoms[hook(1, i)];
    LCLJS[hook(6, iL)] = cLJs[hook(2, i)];
    barrier(0x01);
    for (int j = 0; j < nL; j++) {
      fe += getLJ(LATOMS[hook(5, j)].xyz, LCLJS[hook(6, j)], pos);
    }
    barrier(0x01);
  }
  FE[hook(4, iG)] = fe;
}