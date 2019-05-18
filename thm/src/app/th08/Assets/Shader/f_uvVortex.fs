#ifdef GL_ES                                                            
precision lowp float;                                                   
#endif

const float PI = 3.14159265;

uniform float _uD; //80.0旋转角度                                                
uniform float _uR; //0.5旋转半径

varying vec4 v_fragmentColor;                                           
varying vec2 v_texCoord;

void main()
{
    ivec2 ires = ivec2(512, 512);
    float Res = float(ires.s);

    vec2 st = v_texCoord;
    float Radius = Res * _uR;

    vec2 xy = Res * st;
    vec2 dxy = xy - vec2(Res/2., Res/2.);
    float r = length(dxy);
    float beta = atan(dxy.y, dxy.x) + radians(_uD) * 2.0 * (-(r/Radius)*(r/Radius) + 1.0);//(1.0 - r/Radius);
    vec2 xy1 = xy;

    if(r <= Radius)
    {
        xy1 = Res/2. + r * vec2(cos(beta), sin(beta));
    }
    st = xy1/Res;
    vec3 irgb = texture2D(CC_Texture0, st).rgb;
    gl_FragColor = vec4( irgb, 1.0 );
}