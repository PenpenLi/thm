module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
   
    -------View-------
    local node = THSTG.UI.newNode()

    local testSprite = THSTG.UI.newSprite({
        x = display.cx,
        y = 0,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "HelloWorld.png"
    })
    testSprite:setPositionY(display.height - (testSprite:getContentSize().height * (1-testSprite:getAnchorPoint().y)))
    node:addChild(testSprite)

    -------Controller-------
    local function setGray(node)
        --顶点着色器
        local vertDefaultSource = 
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
    --片段着色器
        local pszFragSource = 
        [[
            #ifdef GL_ES 
                precision mediump float; 
            #endif 
                varying vec4 v_fragmentColor; 
                varying vec2 v_texCoord; 
            void main(void) 
            { 
                vec4 c = texture2D(CC_Texture0, v_texCoord); 
                float gray = dot(c.rgb, vec3(0.299, 0.587, 0.114));
                gl_FragColor = vec4(gray,gray,gray,c.a);
            }
        ]]
    
        local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
            
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
        pProgram:link()
        pProgram:updateUniforms()
        node:setGLProgram(pProgram)
    end

    function removeGray(node)

        --顶点着色器
        local vertDefaultSource = 
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
    --片段着色器
        local pszRemoveGrayShader = "#ifdef GL_ES \n" ..
        "precision mediump float; \n" ..
        "#endif \n" ..
        "varying vec4 v_fragmentColor; \n" ..
        "varying vec2 v_texCoord; \n" ..
        "void main(void) \n" ..
        "{ \n" ..
        "gl_FragColor = texture2D(CC_Texture0, v_texCoord); \n" ..
        "}"
    
        -- local glProgramCache = cc.GLProgramCache:getInstance()
        -- local glProgram = glProgramCache:getGLProgram(SHADER_KEY)
        -- if not glProgram then
            local glProgram = nil
            glProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, pszRemoveGrayShader)
            -- glProgramCache:addGLProgram(glProgram, SHADER_KEY)
        -- end
        


        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
        pProgram:link()
        pProgram:updateUniforms()
        -- local glProgramState = cc.GLProgramState:create(glProgram)
        -- glProgramState:setUniformVec4("u_color", changedColor)
        -- if glProgramState then
            node:setGLProgram(pProgram)
        -- end

        
    end




    --颜色
    local function setColor(r,g,b)
        testSprite:setColor(cc.c3b(r,g,b))
    end
    --明暗度
    local function setIntensity(val)
        local int = 255 * val
        setColor(int, int, int)
    end
    --透明度
    local function setOpacity(val)
        local int = 255 * val
        testSprite:setOpacity(int)
    end
    
    --
    local function initTintTo()
        local ac1 = cc.TintTo:create(3, 0, 0, 0)
        local ac2 = cc.TintTo:create(3, 255, 255, 255)
        local ac = cc.Sequence:create({ac1, ac2})
        testSprite:runAction(ac)

    end

    initTintTo()
    -----

    node:onNodeEvent("enter", function ()
        local oldProgram = testSprite:getGLProgram()
        setGray(testSprite)--自定义着色器导致行为失效:使用一张置灰纹理解决
        
        -- removeGray(testSprite)
        testSprite:setGLProgram(oldProgram) 
        -- setColor(250,250,250) --RGB * 1/rgb
        -- setIntensity(125)
        -- setOpacity(0.5)
        initTintTo()
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M