
 
 













 








#ifndef DC_IMPLEMENT
#define DC_IMPLEMENT

typedef unsigned int uint32_t;
#define UINT32_C(a) ((uint32_t)a)

typedef struct {
    uint32_t aaa;
    int mm,nn,rr,ww;
    uint32_t wmask,umask,lmask;
    int shift0, shift1, shiftB, shiftC;
    uint32_t maskB, maskC;
    int i;
    uint32_t *state;
}mt_struct;





#if defined(__cplusplus)
extern "C" 
#endif
void sgenrand_mt(uint32_t seed, mt_struct *mts);
#if defined(__cplusplus)
extern "C" 
#endif
uint32_t genrand_mt(mt_struct *mts);

#endif
