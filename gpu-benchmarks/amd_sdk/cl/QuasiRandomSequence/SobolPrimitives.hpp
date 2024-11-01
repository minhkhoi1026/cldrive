

#ifndef SOBOL_PRIMITIVES_H
#define SOBOL_PRIMITIVES_H

#define max_m 17


struct primitive
{
    unsigned int dimension;
    unsigned int degree;
    unsigned int a;
    unsigned int m[max_m];
};

extern const struct primitive sobolPrimitives[];

#endif
