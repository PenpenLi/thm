#ifdef GL_ES                                                            
precision lowp float;                                                   
#endif                                                                  

varying vec4 v_fragmentColor;                                           
varying vec2 v_texCoord;       
                                            
uniform float _speedX;
uniform float _speedY;                                                                                      
uniform vec2 _uRange;                                                    
uniform vec2 _vRange;                                                    
void main()                                                             
{                               
    vec2 texOffset = vec2(_speedX * CC_Time.x,_speedY * CC_Time.x);                       
    vec2 texcoord = texOffset+v_texCoord;                               
    texcoord.x = mod(texcoord.x - _uRange.x,_uRange.y-_uRange.x) + _uRange.x;   
    texcoord.y = mod(texcoord.y - _vRange.x,_vRange.y-_vRange.x) + _vRange.x;   
    gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, texcoord);			
}