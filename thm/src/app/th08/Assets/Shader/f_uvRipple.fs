//link = "https://blog.csdn.net/puppet_master/article/details/52975666",
//desc = "UV动画-水波纹Shader",
#ifdef GL_ES                                                            
precision lowp float;                                                   
#endif                                                                  

varying vec4 v_fragmentColor;                                           
varying vec2 v_texCoord;       
                                            
uniform float _speed;    //1.0                                                                
uniform float _ripple;   //60.0
uniform float _swing;    //1.0 
                                                                            
void main()                                                             
{                                         
    //计算uv到中间点的向量(向外扩，反过来就是向里缩)
    vec2 uv = v_texCoord; 
    vec2 dv = vec2(0.5, 0.5) - uv;
    float dis = sqrt(dv.x * dv.x + dv.y * dv.y);//计算像素点距中点的距离

    //用sin函数计算出波形的偏移值factor
    //dis在这里都是小于1的，所以我们需要乘以一个比较大的数，比如60，这样就有多个波峰波谷
    //sin函数是（-1，1）的值域，我们希望偏移值很小，所以这里我们缩小100倍，据说乘法比较快,so...
    float sinFactor = sin(dis * _ripple + CC_Time.x * _speed) * _swing * 0.01;

    vec2 dv1 = normalize(dv);           //归一化

    vec2 offset = dv1  * sinFactor ;     //计算每个像素uv的偏移值
    vec2 retUV = offset + uv;           //像素采样时偏移offset
    gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, retUV);
}