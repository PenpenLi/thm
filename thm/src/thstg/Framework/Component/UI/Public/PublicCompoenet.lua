module("UIPublic", package.seeall)

function newUVSprite(params)
    params = params or {}

    params.uRange = params.uRange or cc.p(0,1)
    params.vRange = params.vRange or cc.p(0,1)
    params.speed = params.speed or cc.p(1,1)

    local sprite = newSprite(params)

    NodeUtil.applyShader(sprite,{
        shaderKey = "THSTG_UV_SPRITE_SHADER",
		fsStr = 
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
		]],
        onState = function (node,state)
            state:setUniformVec2("uRange",cc.vec3(params.uRange.x,params.uRange.y,0))
            state:setUniformVec2("vRange",cc.vec3(params.vRange.x,params.vRange.y,0))
            local count = cc.p(0,0)
            node:runAction(cc.RepeatForever:create(cc.Sequence:create({
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(function ()
                    count.x = count.x + params.speed.x/1000
                    count.y = count.y + params.speed.y/1000
                    state:setUniformVec2("texOffset",cc.vec3(count.x,count.y,0))
                end)
            })))
        end,
    })
    --
    function sprite:setSpeed(val)
        params.speed = val
    end
    function sprite:getSpeed(val)
        return params.speed
    end

    return sprite
end
