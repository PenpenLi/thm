module("THSTG.UIPublic", package.seeall)

 -- 顶点shader
 --Author : zlb
 local DEFAULT_VERTEX = 
 [[
    attribute vec4 a_position; 
    attribute vec2 a_texCoord; 
    attribute vec4 a_color; 
    #ifdef GL_ES  
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else                      
    varying vec4 v_fragmentColor; 
    varying vec2 v_texCoord;  
    #endif    
    void main() 
    {
        gl_Position = CC_PMatrix * a_position; 
        v_fragmentColor = a_color;
        v_texCoord = a_texCoord;
    }
]]

-- 片段shader
local DEFAULT_FRAGMENT = 
[[
    #ifdef GL_ES 
    precision mediump float;
    #endif 
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;

    uniform float stateFlags;
    uniform vec2 midPoint;
    uniform float eachAngle;
    uniform vec3 offsetAxis;
    uniform int isDrawMask;
    uniform sampler2D maskTexture;

    const float PI = 3.1415926;

    bool getBit(float flags,int bit)
    {
        for (int i = 0;i<bit;++i)flags/=2.0;
        return mod(flags,2.0) >= 1.0 ? true : false;
    }

    void main(void) 
    {
        //求出角度
        vec3 op = vec3(v_texCoord.x - midPoint.x,v_texCoord.y - midPoint.y,0.0);
        vec3 ox = offsetAxis;
        vec3 direction = cross(op,ox);
        float angle = acos(-dot(op,ox)/(length(op) * length(ox))); //两夹角
        if (direction.z < 0.0) angle = 2.0 * PI - angle;
        float consult = angle / eachAngle;
        //求出所在扇区
        int section = int(consult);
        //扇区状态
        bool state = getBit(stateFlags,section);

        vec4 tx1 = texture2D(CC_Texture0, v_texCoord);
        
        if( state )
        {
            if (isDrawMask >= 1)
            {
                vec4 tx2 = texture2D(maskTexture, v_texCoord);
                gl_FragColor = vec4(tx2.rgb,tx2.a);
            }
            else
            {
                float gray = dot(tx1.rgb, vec3(0.299, 0.587, 0.114));
                gl_FragColor = vec4(gray,gray,gray,tx1.a);
            }
        }
        else
        {
            gl_FragColor.xyz = vec3(tx1.rgb);
            gl_FragColor.a = tx1.a;
        }
    }
]]

TURNTABLE_DEFAULT_PARAMS = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    anchorPoint = clone(UI.POINT_CENTER),
    value = 1,
    sectors = 4,
    midPoint = cc.p(0.5,0.5),
    offset = 0,
    fgSrc = ResManager.getUIRes(UIType.PROGRESS_BAR, "prog_radial_hp"),
    bgSrc = false,
}

--去色轮盘
--@param x				#number			x坐标
--@param y				#number			x坐标
--@param width 		    #number     	进度条需要拉伸宽度
--@param height			#number	        进度条需要拉伸高度
--@param anchorPoint	#cc.p		    锚点，默认UI.PONIT_CENTER
--@param value          #number         起始值
--@param sectors        #number         扇区数
--@param offset         #number         起始角度偏移
--@param midPoint	    #cc.p		    中心点坐标(纹理坐标)

--@param fgSrc          #str            前景图片
--@param bgSrc          #str            背景图片    --为false时采取去色策略
function newTurntable(params)
    assert(type(params) == "table", "[UI] newTurntable() invalid params")
	local paramsStyle = params.style or {}
	local finalParams = clone(TURNTABLE_DEFAULT_PARAMS)
	TableUtil.mergeA2B(params, finalParams)
    local function getInitStates()
        local ret = {}
        for i = 1,finalParams.sectors do
            if i<=finalParams.value then
                ret[i] = 1
            else
                ret[i] = 0
            end
            
        end
        return ret
    end

    local node = UI.newNode(finalParams)
    local fgSprite = UI.newSprite({
		src = finalParams.fgSrc,
		anchorPoint = UI.POINT_CENTER,
    })
    node:addChild(fgSprite)

    local bgSprite = nil
    if finalParams.bgSrc then
        bgSprite= UI.newSprite({
            src = finalParams.bgSrc,
            anchorPoint = UI.POINT_CENTER,
        })
    end


    local vertex =  DEFAULT_VERTEX
    local fragment = DEFAULT_FRAGMENT

    local pProgram = cc.GLProgram:createWithByteArrays(vertex , fragment)
    local stateTb = getInitStates()

    if pProgram then
        local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(pProgram)
        glProgramState:setUniformVec2("midPoint",cc.vec3(finalParams.midPoint.x,finalParams.midPoint.y,0))
        glProgramState:setUniformFloat("eachAngle",2 * math.pi / finalParams.sectors)
        local initPos = cc.p(0.5,1.0)
        local offsetAngle = (math.pi * finalParams.offset)/180
        local startPos = cc.p(
            (initPos.x - finalParams.midPoint.x) * math.cos(offsetAngle) - (initPos.y - finalParams.midPoint.y) * math.sin(offsetAngle) + finalParams.midPoint.x,
            (initPos.x - finalParams.midPoint.x) * math.sin(offsetAngle) + (initPos.y - finalParams.midPoint.y) * math.cos(offsetAngle) + finalParams.midPoint.y
        )
        glProgramState:setUniformVec3("offsetAxis",cc.vec3(startPos.x - finalParams.midPoint.x,startPos.y - finalParams.midPoint.y,0))
        --error是误报的,实际上运转正常
        if bgSprite then
            glProgramState:setUniformInt("isDrawMask",1)
            glProgramState:setUniformTexture("maskTexture",bgSprite:getTexture())
        else
            glProgramState:setUniformInt("isDrawMask",0)
            glProgramState:setUniformTexture("maskTexture",fgSprite:getTexture())
        end
    end

    --
    -- 1-去色(底色)  ,0-原色
    function node:setStates(t)
        TableUtil.mergeA2B(t, stateTb)
		if pProgram then
			local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(pProgram)
			local retFlags = 0
            for i = #stateTb,1,-1 do
                retFlags = retFlags + (stateTb[i] == 1 and math.pow(2,i-1) or 0)
            end
            glProgramState:setUniformFloat("stateFlags",retFlags)
			fgSprite:setGLProgram(pProgram)
		end
    end
    
    function node:getStates()
        return stateTb
    end

    function node:setPosState(pos,state)
        stateTb[pos] = state and 1 or 0
        node:setStates(stateTb)
    end

    function node:getPosState(pos)
        return stateTb[pos]
    end

    function node:setStateNum(num,isReverse)
        for i = 1,#stateTb do
            if i <= num then
                stateTb[i] = isReverse and 0 or 1
            else
                stateTb[i] = isReverse and 1 or 0
            end
        end
        node:setStates(stateTb)
    end

    function node:getStateNum(isReverse)
        local num = 0
        for i = 1,#stateTb do
            if stateTb[i] == (isReverse and 0 or 1) then
                num = num + 1
            end
        end
    end

    function node:turnOn()
        for i = 1,#stateTb do
            stateTb[i] = 0
        end
        node:setStates(stateTb)
    end

    function node:turnOff()
        for i = 1,#stateTb do
            stateTb[i] = 1
        end
        node:setStates(stateTb)
    end
    function node:turn(state)
        if state then 
            node:turnOff()
        else 
            node:turnOn()
        end
    end

    node:setStates(stateTb)
	return node
end