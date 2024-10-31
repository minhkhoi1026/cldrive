

#ifndef __RENDER_PARTICLES__
    #define __RENDER_PARTICLES__

    class ParticleRenderer
    {
        public:
            ParticleRenderer();
            ~ParticleRenderer();

            void setPositions(float *pos, int numParticles);
            void setColors(float *color, int numParticles);
            void setPBO(size_t pbo, int numParticles);

            enum DisplayMode
            {
                PARTICLE_POINTS,
                PARTICLE_SPRITES,
                PARTICLE_SPRITES_COLOR,
                PARTICLE_NUM_MODES
            };

            void display(DisplayMode mode = PARTICLE_POINTS);

            void setPointSize(float size)  { m_pointSize = size; }
            void setSpriteSize(float size) { m_spriteSize = size; }

        protected: 
            void _initGL();
            void _createTexture(int resolution);
            void _drawPoints(bool color = false);

        protected: 
            float *m_pos;
            int m_numParticles;

            float m_pointSize;
            float m_spriteSize;

            unsigned int m_vertexShader;
            unsigned int m_pixelShader;
            unsigned int m_program;
            unsigned int m_texture;
            size_t m_pbo;
            unsigned int m_vboColor;
    };

#endif 
