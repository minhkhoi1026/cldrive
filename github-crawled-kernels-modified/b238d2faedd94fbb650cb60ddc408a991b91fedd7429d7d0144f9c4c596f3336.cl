//{"B":11,"K":8,"N":13,"V":16,"W":7,"X":15,"fixedW":9,"input":0,"lookup":14,"midstate0":3,"midstate16":4,"nFactor":6,"output":1,"padcache":2,"target":5,"tmp":10,"w":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int N[] = {0x00000000U, 0x00000001U, 0x00000003U, 0x00000007U, 0x0000000FU, 0x0000001FU, 0x0000003FU, 0x0000007FU, 0x000000FFU, 0x000001FFU, 0x000003FFU, 0x000007FFU, 0x00000FFFU, 0x00001FFFU, 0x00003FFFU, 0x00007FFFU, 0x0000FFFFU, 0x0001FFFFU, 0x0003FFFFU, 0x0000FFFFU, 0x000FFFFFU};

constant unsigned int K[] = {0x428a2f98U, 0x71374491U, 0xb5c0fbcfU, 0xe9b5dba5U, 0x3956c25bU, 0x59f111f1U, 0x923f82a4U, 0xab1c5ed5U, 0xd807aa98U, 0x12835b01U, 0x243185beU, 0x550c7dc3U, 0x72be5d74U, 0x80deb1feU, 0x9bdc06a7U, 0xe49b69c1U, 0xefbe4786U, 0x0fc19dc6U, 0x240ca1ccU, 0x2de92c6fU, 0x4a7484aaU, 0x5cb0a9dcU, 0x76f988daU, 0x983e5152U, 0xa831c66dU, 0xb00327c8U, 0xbf597fc7U, 0xc6e00bf3U, 0xd5a79147U, 0x06ca6351U, 0x14292967U, 0x27b70a85U, 0x2e1b2138U, 0x4d2c6dfcU, 0x53380d13U, 0x650a7354U, 0x766a0abbU, 0x81c2c92eU, 0x92722c85U, 0xa2bfe8a1U, 0xa81a664bU, 0xc24b8b70U, 0xc76c51a3U, 0xd192e819U, 0xd6990624U, 0xf40e3585U, 0x106aa070U, 0x19a4c116U, 0x1e376c08U, 0x2748774cU, 0x34b0bcb5U, 0x391c0cb3U, 0x4ed8aa4aU, 0x5b9cca4fU, 0x682e6ff3U, 0x748f82eeU, 0x78a5636fU, 0x84c87814U, 0x8cc70208U, 0x90befffaU, 0xa4506cebU, 0xbef9a3f7U, 0xc67178f2U, 0x98c7e2a2U, 0xfc08884dU, 0xcd2a11aeU, 0x510e527fU, 0x9b05688cU, 0xC3910C8EU, 0xfb6feee7U, 0x2a01a605U, 0x0c2e12e0U, 0x4498517BU, 0x6a09e667U, 0xa4ce148bU, 0x95F61999U, 0xc19bf174U, 0xBB67AE85U, 0x3C6EF372U, 0xA54FF53AU, 0x1F83D9ABU, 0x5BE0CD19U, 0x5C5C5C5CU, 0x36363636U, 0x80000000U, 0x000007FFU, 0x00000280U, 0x000004a0U, 0x00000300U};
void SHA256(uint4* restrict state0, uint4* restrict state1, const uint4 block0, const uint4 block1, const uint4 block2, const uint4 block3) {
  uint4 S0 = *state0;
  uint4 S1 = *state1;
  uint4 W[4] = {block0, block1, block2, block3};

  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 0)].x + K[hook(8, 0)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 0)].y + K[hook(8, 1)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 0)].z + K[hook(8, 2)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 0)].w + K[hook(8, 3)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 1)].x + K[hook(8, 4)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 1)].y + K[hook(8, 5)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 1)].z + K[hook(8, 6)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 1)].w + K[hook(8, 7)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 2)].x + K[hook(8, 8)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 2)].y + K[hook(8, 9)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 2)].z + K[hook(8, 10)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 2)].w + K[hook(8, 11)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 3)].x + K[hook(8, 12)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 3)].y + K[hook(8, 13)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 3)].z + K[hook(8, 14)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 3)].w + K[hook(8, 76)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 0)].x + K[hook(8, 15)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 0)].y + K[hook(8, 16)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 0)].z + K[hook(8, 17)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 0)].w + K[hook(8, 18)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 1)].x + K[hook(8, 19)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 1)].y + K[hook(8, 20)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 1)].z + K[hook(8, 21)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 1)].w + K[hook(8, 22)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 2)].x + K[hook(8, 23)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 2)].y + K[hook(8, 24)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 2)].z + K[hook(8, 25)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 2)].w + K[hook(8, 26)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 3)].x + K[hook(8, 27)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 3)].y + K[hook(8, 28)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 3)].z + K[hook(8, 29)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 3)].w + K[hook(8, 30)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 0)].x + K[hook(8, 31)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 0)].y + K[hook(8, 32)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 0)].z + K[hook(8, 33)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 0)].w + K[hook(8, 34)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 1)].x + K[hook(8, 35)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 1)].y + K[hook(8, 36)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 1)].z + K[hook(8, 37)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 1)].w + K[hook(8, 38)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 2)].x + K[hook(8, 39)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 2)].y + K[hook(8, 40)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 2)].z + K[hook(8, 41)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 2)].w + K[hook(8, 42)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 3)].x + K[hook(8, 43)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 3)].y + K[hook(8, 44)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 3)].z + K[hook(8, 45)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 3)].w + K[hook(8, 46)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 0)].x + K[hook(8, 47)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 0)].y + K[hook(8, 48)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 0)].z + K[hook(8, 49)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 0)].w + K[hook(8, 50)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 1)].x + K[hook(8, 51)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 1)].y + K[hook(8, 52)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 1)].z + K[hook(8, 53)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 1)].w + K[hook(8, 54)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(7, 2)].x + K[hook(8, 55)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(7, 2)].y + K[hook(8, 56)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(7, 2)].z + K[hook(8, 57)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(7, 2)].w + K[hook(8, 58)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(7, 3)].x + K[hook(8, 59)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(7, 3)].y + K[hook(8, 60)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(7, 3)].z + K[hook(8, 61)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(7, 3)].w + K[hook(8, 62)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  *state0 += S0;
  *state1 += S1;
}

void SHA256_fresh(uint4* restrict state0, uint4* restrict state1, const uint4 block0, const uint4 block1, const uint4 block2, const uint4 block3) {
  uint4 W[4] = {block0, block1, block2, block3};

  (*state0).w = K[hook(8, 63)] + W[hook(7, 0)].x;
  (*state1).w = K[hook(8, 64)] + W[hook(7, 0)].x;

  (*state0).z = K[hook(8, 65)] + (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect(K[hook(8, 67)], K[hook(8, 66)], (*state0).w) + W[hook(7, 0)].y;
  (*state1).z = K[hook(8, 68)] + (*state0).z + (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect(K[hook(8, 70)], K[hook(8, 69)], (*state1).w);

  (*state0).y = K[hook(8, 71)] + (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect(K[hook(8, 66)], (*state0).w, (*state0).z) + W[hook(7, 0)].z;
  (*state1).y = K[hook(8, 72)] + (*state0).y + (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect(K[hook(8, 73)], (*state1).w, ((*state1).z ^ K[hook(8, 73)]));

  (*state0).x = K[hook(8, 74)] + (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 0)].w;
  (*state1).x = K[hook(8, 75)] + (*state0).x + (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));

  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 1)].x + K[hook(8, 4)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 1)].y + K[hook(8, 5)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 1)].z + K[hook(8, 6)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 1)].w + K[hook(8, 7)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 2)].x + K[hook(8, 8)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 2)].y + K[hook(8, 9)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 2)].z + K[hook(8, 10)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 2)].w + K[hook(8, 11)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 3)].x + K[hook(8, 12)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 3)].y + K[hook(8, 13)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 3)].z + K[hook(8, 14)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 3)].w + K[hook(8, 76)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 0)].x + K[hook(8, 15)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 0)].y + K[hook(8, 16)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 0)].z + K[hook(8, 17)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 0)].w + K[hook(8, 18)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 1)].x + K[hook(8, 19)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 1)].y + K[hook(8, 20)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 1)].z + K[hook(8, 21)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 1)].w + K[hook(8, 22)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 2)].x + K[hook(8, 23)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 2)].y + K[hook(8, 24)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 2)].z + K[hook(8, 25)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 2)].w + K[hook(8, 26)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 3)].x + K[hook(8, 27)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 3)].y + K[hook(8, 28)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 3)].z + K[hook(8, 29)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 3)].w + K[hook(8, 30)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 0)].x + K[hook(8, 31)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 0)].y + K[hook(8, 32)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 0)].z + K[hook(8, 33)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 0)].w + K[hook(8, 34)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 1)].x + K[hook(8, 35)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 1)].y + K[hook(8, 36)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 1)].z + K[hook(8, 37)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 1)].w + K[hook(8, 38)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 2)].x + K[hook(8, 39)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 2)].y + K[hook(8, 40)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 2)].z + K[hook(8, 41)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 2)].w + K[hook(8, 42)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 3)].x + K[hook(8, 43)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 3)].y + K[hook(8, 44)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 3)].z + K[hook(8, 45)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 3)].w + K[hook(8, 46)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (0 & 3))].y, W[hook(7, (0 & 3))].z, W[hook(7, (0 & 3))].w, W[hook(7, (0 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (0 + 2 & 3))].y, W[hook(7, (0 + 2 & 3))].z, W[hook(7, (0 + 2 & 3))].w, W[hook(7, (0 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (0 + 3 & 3))].z, W[hook(7, (0 + 3 & 3))].w, 0, 0);
    W[hook(7, (0 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (0 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (0 & 3))].x, W[hook(7, (0 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 0)].x + K[hook(8, 47)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 0)].y + K[hook(8, 48)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 0)].z + K[hook(8, 49)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 0)].w + K[hook(8, 50)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (1 & 3))].y, W[hook(7, (1 & 3))].z, W[hook(7, (1 & 3))].w, W[hook(7, (1 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (1 + 2 & 3))].y, W[hook(7, (1 + 2 & 3))].z, W[hook(7, (1 + 2 & 3))].w, W[hook(7, (1 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (1 + 3 & 3))].z, W[hook(7, (1 + 3 & 3))].w, 0, 0);
    W[hook(7, (1 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (1 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (1 & 3))].x, W[hook(7, (1 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 1)].x + K[hook(8, 51)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 1)].y + K[hook(8, 52)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 1)].z + K[hook(8, 53)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 1)].w + K[hook(8, 54)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (2 & 3))].y, W[hook(7, (2 & 3))].z, W[hook(7, (2 & 3))].w, W[hook(7, (2 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (2 + 2 & 3))].y, W[hook(7, (2 + 2 & 3))].z, W[hook(7, (2 + 2 & 3))].w, W[hook(7, (2 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (2 + 3 & 3))].z, W[hook(7, (2 + 3 & 3))].w, 0, 0);
    W[hook(7, (2 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (2 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (2 & 3))].x, W[hook(7, (2 & 3))].y) >> 10U));
  };
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(7, 2)].x + K[hook(8, 55)];
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(7, 2)].y + K[hook(8, 56)];
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(7, 2)].z + K[hook(8, 57)];
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(7, 2)].w + K[hook(8, 58)];
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  {
    uint4 tmp1 = (uint4)(W[hook(7, (3 & 3))].y, W[hook(7, (3 & 3))].z, W[hook(7, (3 & 3))].w, W[hook(7, (3 + 1 & 3))].x);
    uint4 tmp2 = (uint4)(W[hook(7, (3 + 2 & 3))].y, W[hook(7, (3 + 2 & 3))].z, W[hook(7, (3 + 2 & 3))].w, W[hook(7, (3 + 3 & 3))].x);
    uint4 tmp3 = (uint4)(W[hook(7, (3 + 3 & 3))].z, W[hook(7, (3 + 3 & 3))].w, 0, 0);
    W[hook(7, (3 & 3))] += tmp2 + (rotate(tmp1, 25U) ^ rotate(tmp1, 14U) ^ (tmp1 >> 3U)) + (rotate(tmp3, 15U) ^ rotate(tmp3, 13U) ^ (tmp3 >> 10U));
    W[hook(7, (3 & 3))] += (rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 15U) ^ rotate((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y), 13U) ^ ((uint4)(0, 0, W[hook(7, (3 & 3))].x, W[hook(7, (3 & 3))].y) >> 10U));
  };
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(7, 3)].x + K[hook(8, 59)];
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(7, 3)].y + K[hook(8, 60)];
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(7, 3)].z + K[hook(8, 61)];
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(7, 3)].w + K[hook(8, 62)];
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;
  *state0 += (uint4)(K[hook(8, 73)], K[hook(8, 77)], K[hook(8, 78)], K[hook(8, 79)]);
  *state1 += (uint4)(K[hook(8, 66)], K[hook(8, 67)], K[hook(8, 80)], K[hook(8, 81)]);
}

constant unsigned int fixedW[64] = {
    0x428a2f99, 0xf1374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf794, 0xf59b89c2, 0x73924787, 0x23c6886e, 0xa42ca65c, 0x15ed3627, 0x4d6edcbf, 0xe28217fc, 0xef02488f, 0xb707775c, 0x0468c23f, 0xe7e72b4c, 0x49e1f1a2, 0x4b99c816, 0x926d1570, 0xaa0fc072, 0xadb36e2c, 0xad87a3ea, 0xbcb1d3a3, 0x7b993186, 0x562b9420, 0xbff3ca0c, 0xda4b0c23, 0x6cd8711a, 0x8f337caa, 0xc91b1417, 0xc359dce1, 0xa83253a7, 0x3b13c12d, 0x9d3d725d, 0xd9031a84, 0xb1a03340, 0x16f58012, 0xe64fb6a2, 0xe84d923a, 0xe93a5730, 0x09837686, 0x078ff753, 0x29833341, 0xd5de0b7e, 0x6948ccf4, 0xe0a1adbe, 0x7c728e11, 0x511c78e4, 0x315b45bd, 0xfca71413, 0xea28f96a, 0x79703128, 0x4e1ef848,
};

void SHA256_fixed(uint4* restrict state0, uint4* restrict state1) {
  uint4 S0 = *state0;
  uint4 S1 = *state1;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 0)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 1)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 2)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 3)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 4)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 5)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 6)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 7)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 8)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 9)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 10)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 11)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 12)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 13)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 14)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 15)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 16)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 17)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 18)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 19)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 20)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 21)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 22)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 23)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 24)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 25)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 26)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 27)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 28)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 29)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 30)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 31)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 32)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 33)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 34)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 35)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 36)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 37)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 38)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 39)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 40)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 41)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 42)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 43)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 44)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 45)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 46)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 47)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 48)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 49)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 50)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 51)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 52)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 53)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 54)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 55)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(9, 56)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(9, 57)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(9, 58)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(9, 59)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(9, 60)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(9, 61)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(9, 62)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(9, 63)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  *state0 += S0;
  *state1 += S1;
}

void shittify(uint4 B[8]) {
  uint4 tmp[8];
  tmp[hook(10, 0)] = (uint4)(B[hook(11, 1)].x, B[hook(11, 2)].y, B[hook(11, 3)].z, B[hook(11, 0)].w);
  tmp[hook(10, 1)] = (uint4)(B[hook(11, 2)].x, B[hook(11, 3)].y, B[hook(11, 0)].z, B[hook(11, 1)].w);
  tmp[hook(10, 2)] = (uint4)(B[hook(11, 3)].x, B[hook(11, 0)].y, B[hook(11, 1)].z, B[hook(11, 2)].w);
  tmp[hook(10, 3)] = (uint4)(B[hook(11, 0)].x, B[hook(11, 1)].y, B[hook(11, 2)].z, B[hook(11, 3)].w);
  tmp[hook(10, 4)] = (uint4)(B[hook(11, 5)].x, B[hook(11, 6)].y, B[hook(11, 7)].z, B[hook(11, 4)].w);
  tmp[hook(10, 5)] = (uint4)(B[hook(11, 6)].x, B[hook(11, 7)].y, B[hook(11, 4)].z, B[hook(11, 5)].w);
  tmp[hook(10, 6)] = (uint4)(B[hook(11, 7)].x, B[hook(11, 4)].y, B[hook(11, 5)].z, B[hook(11, 6)].w);
  tmp[hook(10, 7)] = (uint4)(B[hook(11, 4)].x, B[hook(11, 5)].y, B[hook(11, 6)].z, B[hook(11, 7)].w);

  for (unsigned int i = 0; i < 8; ++i)
    B[hook(11, i)] = (rotate(tmp[hook(10, i)] & 0x00FF00FF, 24U) | rotate(tmp[hook(10, i)] & 0xFF00FF00, 8U));
}

void unshittify(uint4 B[8]) {
  uint4 tmp[8];
  tmp[hook(10, 0)] = (uint4)(B[hook(11, 3)].x, B[hook(11, 2)].y, B[hook(11, 1)].z, B[hook(11, 0)].w);
  tmp[hook(10, 1)] = (uint4)(B[hook(11, 0)].x, B[hook(11, 3)].y, B[hook(11, 2)].z, B[hook(11, 1)].w);
  tmp[hook(10, 2)] = (uint4)(B[hook(11, 1)].x, B[hook(11, 0)].y, B[hook(11, 3)].z, B[hook(11, 2)].w);
  tmp[hook(10, 3)] = (uint4)(B[hook(11, 2)].x, B[hook(11, 1)].y, B[hook(11, 0)].z, B[hook(11, 3)].w);
  tmp[hook(10, 4)] = (uint4)(B[hook(11, 7)].x, B[hook(11, 6)].y, B[hook(11, 5)].z, B[hook(11, 4)].w);
  tmp[hook(10, 5)] = (uint4)(B[hook(11, 4)].x, B[hook(11, 7)].y, B[hook(11, 6)].z, B[hook(11, 5)].w);
  tmp[hook(10, 6)] = (uint4)(B[hook(11, 5)].x, B[hook(11, 4)].y, B[hook(11, 7)].z, B[hook(11, 6)].w);
  tmp[hook(10, 7)] = (uint4)(B[hook(11, 6)].x, B[hook(11, 5)].y, B[hook(11, 4)].z, B[hook(11, 7)].w);

  for (unsigned int i = 0; i < 8; ++i)
    B[hook(11, i)] = (rotate(tmp[hook(10, i)] & 0x00FF00FF, 24U) | rotate(tmp[hook(10, i)] & 0xFF00FF00, 8U));
}

void salsa(uint4 B[8]) {
  unsigned int i;
  uint4 w[4];

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i)] ^= B[hook(11, i + 4)]);

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i + 4)] ^= (B[hook(11, i)] += w[hook(12, i)]));

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    B[hook(11, i + 4)] += w[hook(12, i)];
}

void salsa_double(uint4 B[8]) {
  unsigned int i;
  uint4 w[4];

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i)] ^= B[hook(11, i + 4)]);

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i + 4)] ^= (B[hook(11, i)] += w[hook(12, i)]));

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    B[hook(11, i + 4)] += w[hook(12, i)];

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i)] ^= B[hook(11, i + 4)]);

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    w[hook(12, i)] = (B[hook(11, i + 4)] ^= (B[hook(11, i)] += w[hook(12, i)]));

  for (i = 0; i < 4; ++i) {
    w[hook(12, 0)] ^= rotate(w[hook(12, 3)] + w[hook(12, 2)], 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 0)] + w[hook(12, 3)], 9U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 1)] + w[hook(12, 0)], 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 2)] + w[hook(12, 1)], 18U);
    w[hook(12, 2)] ^= rotate(w[hook(12, 3)].wxyz + w[hook(12, 0)].zwxy, 7U);
    w[hook(12, 1)] ^= rotate(w[hook(12, 2)].wxyz + w[hook(12, 3)].zwxy, 9U);
    w[hook(12, 0)] ^= rotate(w[hook(12, 1)].wxyz + w[hook(12, 2)].zwxy, 13U);
    w[hook(12, 3)] ^= rotate(w[hook(12, 0)].wxyz + w[hook(12, 1)].zwxy, 18U);
  }

  for (i = 0; i < 4; ++i)
    B[hook(11, i + 4)] += w[hook(12, i)];
}
void scrypt_core(const unsigned int gid, uint4 X[8], global uint4* restrict lookup, const unsigned int n) {
  const uint4 coorSIZE = (uint4)(128, ((N[hook(13, n)] + 1) / 16 + ((N[hook(13, n)] + 1) % 16 > 0)), 3, (gid % 128));
  uint4 V[8];
  unsigned int i = 0, y = 0, z = 0;
  unsigned int COx = coorSIZE.w << 3U;
  unsigned int COy = coorSIZE.x << 3U;
  unsigned int COz = 0;

  unsigned int j = 0;

  shittify(X);

  do {
    COz = COx;
    for (z = 0; z < (1 << coorSIZE.z); ++z, ++COz)
      lookup[hook(14, COz)] = X[hook(15, z)];

    i = 0;

    do {
      salsa(&X);
    } while (++i < 16);

    COx += COy;
  } while (++y < coorSIZE.y);

  COy = coorSIZE.w << 3U;

  {
    y = ((N[hook(13, n)] + 1) / 16);
    COx = COy + (coorSIZE.w * y) << 3U;
    for (z = 0; z < (1 << coorSIZE.z); ++z, ++COx)
      lookup[hook(14, COx)] = X[hook(15, z)];
    for (i = 0; i < (N[hook(13, n)] + 1) % 16; ++i)
      salsa(X);
  }

  i = 0;
  do {
    y = ((X[hook(15, 7)].x & N[hook(13, n)]) / 16);

    COz = COy + ((coorSIZE.x * y) << 3U);

    for (z = 0; z < (1 << coorSIZE.z); ++z, ++COz)
      V[hook(16, z)] = lookup[hook(14, COz)];
    j = 0;
    while (j++ < (X[hook(15, 7)].x & N[hook(13, n)]) % 16) {
      salsa(V);
    }

    for (z = 0; z < (1 << coorSIZE.z); ++z)
      X[hook(15, z)] ^= V[hook(16, z)];

    salsa(X);
  } while (++i <= N[hook(13, n)]);

  unshittify(X);
}

__attribute__((reqd_work_group_size(128, 1, 1))) kernel void search(global const uint4* restrict input, volatile global unsigned int* restrict output, global uint4* restrict padcache, const uint4 midstate0, const uint4 midstate16, const unsigned int target, const unsigned int nFactor) {
  unsigned int gid = get_global_id(0);
  uint4 X[8];
  uint4 tstate0, tstate1, ostate0, ostate1, tmp0, tmp1;
  uint4 data = (uint4)(input[hook(0, 4)].x, input[hook(0, 4)].y, input[hook(0, 4)].z, gid);
  uint4 pad0 = midstate0, pad1 = midstate16;

  SHA256(&pad0, &pad1, data, (uint4)(K[hook(8, 84)], 0, 0, 0), (uint4)(0, 0, 0, 0), (uint4)(0, 0, 0, K[hook(8, 86)]));
  SHA256_fresh(&ostate0, &ostate1, pad0 ^ K[hook(8, 82)], pad1 ^ K[hook(8, 82)], K[hook(8, 82)], K[hook(8, 82)]);
  SHA256_fresh(&tstate0, &tstate1, pad0 ^ K[hook(8, 83)], pad1 ^ K[hook(8, 83)], K[hook(8, 83)], K[hook(8, 83)]);

  tmp0 = tstate0;
  tmp1 = tstate1;
  SHA256(&tstate0, &tstate1, input[hook(0, 0)], input[hook(0, 1)], input[hook(0, 2)], input[hook(0, 3)]);

  for (unsigned int i = 0; i < 4; i++) {
    pad0 = tstate0;
    pad1 = tstate1;
    X[hook(15, (i << 1))] = ostate0;
    X[hook(15, (i << 1) + 1)] = ostate1;

    SHA256(&pad0, &pad1, data, (uint4)(i + 1, K[hook(8, 84)], 0, 0), (uint4)(0, 0, 0, 0), (uint4)(0, 0, 0, K[hook(8, 87)]));
    SHA256(X + (i << 1), X + (i << 1) + 1, pad0, pad1, (uint4)(K[hook(8, 84)], 0U, 0U, 0U), (uint4)(0U, 0U, 0U, K[hook(8, 88)]));
  }

  switch (nFactor) {
    case 10:
      scrypt_core(gid, X, padcache, 10);
      break;
    case 11:
      scrypt_core(gid, X, padcache, 11);
      break;
    case 12:
      scrypt_core(gid, X, padcache, 12);
      break;
  }

  SHA256(&tmp0, &tmp1, X[hook(15, 0)], X[hook(15, 1)], X[hook(15, 2)], X[hook(15, 3)]);
  SHA256(&tmp0, &tmp1, X[hook(15, 4)], X[hook(15, 5)], X[hook(15, 6)], X[hook(15, 7)]);
  SHA256_fixed(&tmp0, &tmp1);
  SHA256(&ostate0, &ostate1, tmp0, tmp1, (uint4)(K[hook(8, 84)], 0U, 0U, 0U), (uint4)(0U, 0U, 0U, K[hook(8, 88)]));

  bool result = ((rotate(ostate1.w & 0x00FF00FF, 24U) | rotate(ostate1.w & 0xFF00FF00, 8U)) <= target);
  if ((rotate(ostate1.w & 0x00FF00FF, 24U) | rotate(ostate1.w & 0xFF00FF00, 8U)) <= target)
    output[hook(1, output[hook(1, (255))++)] = gid;
}