 #ifdef GL_ES                                                            
precision lowp float;                                                   
#endif                                                                  

varying vec4 v_fragmentColor;                                           
varying vec2 v_texCoord;       
                                            
uniform float _speed;    //1.0                                                                
uniform float _scale;    //3.0
uniform float _identity; //80.0                                                                                                  
void main()                                                             
{                                                                       
    vec2 uv = v_texCoord;        
    float r = sqrt(uv.x*uv.x + uv.y*uv.y);                   
    float z = cos(_scale * r + CC_Time.x * _speed)/_identity;
    gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, uv + vec2(z,z));			
}