return {
    Uv_Rolling_Sprite_Shader = {
        desc = "UV动画-无限滚动Shader",
        vertexShader = nil,
        fragmentShader = 
        [[
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
                vec2 texOffset = vec2(_speedX * CC_Time.x,_speedY*CC_Time.x);                       
                vec2 texcoord = texOffset+v_texCoord;                               
                texcoord.x = mod(texcoord.x - _uRange.x,_uRange.y-_uRange.x) + _uRange.x;   
                texcoord.y = mod(texcoord.y - _vRange.x,_vRange.y-_vRange.x) + _vRange.x;   
                gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, texcoord);			
            }
        ]]
    },
    Uv_Wave_Sprite_Shader = {
        desc = "UV动画-波动Shader",
        vertexShader = nil,
        fragmentShader = 
        [[
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
        ]]
    },
    Uv_Ripple_Sprite_Shader = {
        link = "https://blog.csdn.net/puppet_master/article/details/52975666",
        desc = "UV动画-水波纹Shader",
        vertexShader = nil,
        fragmentShader = 
        [[
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
        ]]
    },
    Grey_Sprite_Shader = {
        desc = "置灰",
        vertexShader = nil,
        fragmentShader = 
        [[
            #ifdef GL_ES
            precision lowp float;
            #endif

            uniform vec4 u_color;
            varying vec2 v_texCoord;

            void main()
            {
                vec4 c = texture2D(CC_Texture0, v_texCoord);
                float gray = dot(c.rgb, vec3(0.299, 0.587, 0.114));
                gl_FragColor = vec4(gray,gray,gray,c.a);
            }

        ]]
    },
}