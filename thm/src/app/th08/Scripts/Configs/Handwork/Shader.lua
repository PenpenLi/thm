return {
    Uv_Sprite_Shader = {
        desc = "UV动画Shader",
        vertexShader = nil,
        fragmentShader = 
        [[
            #ifdef GL_ES                                                            
            precision lowp float;                                                   
            #endif                                                                  
            
            varying vec4 v_fragmentColor;                                           
            varying vec2 v_texCoord;       
                                                     
            uniform vec2 texOffset;                                                                                      
            uniform vec2 uRange;                                                    
            uniform vec2 vRange;                                                    
            void main()                                                             
            {                                                                       
                vec2 texcoord = texOffset+v_texCoord;                               
                texcoord.x = mod(texcoord.x - uRange.x,uRange.y-uRange.x) + uRange.x;   
                texcoord.y = mod(texcoord.y - vRange.x,vRange.y-vRange.x) + vRange.x;   
                gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, texcoord);			
            }
        ]]
    },
}