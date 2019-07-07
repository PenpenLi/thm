module("UI", package.seeall)

local DEFAULT_SHADER_KEY = "THSTG_DEFAULT_SHADER"
local DEFAULT_VERTEX_SHADER = 
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
local DEFAULT_FRAGMENT_SHADER = 
[[
	#ifdef GL_ES
	precision lowp float;
	#endif
	
	uniform vec4 u_color;
	varying vec2 v_texCoord;
	
	void main()
	{
		gl_FragColor = texture2D(CC_Texture0, v_texCoord);
	}
	
]]

function newShader(params)
    local M = {}
    M.params = params or {}

	function M:effect(node)
        if node then
            local shaderKey = M.params.shaderKey
            if not shaderKey then
                if not (M.params.vsSrc or M.params.vsStr or M.params.fsSrc or M.params.fsStr) then
                    shaderKey = DEFAULT_SHADER_KEY
                end
            end
            
            local glProgramCache = cc.GLProgramCache:getInstance()
            local glProgram = false
            if shaderKey then glProgram = glProgramCache:getGLProgram(shaderKey) end
        
            if not glProgram then
                if not (M.params.vsSrc or M.params.vsStr or M.params.fsSrc or M.params.fsStr) then
                    shaderKey = DEFAULT_SHADER_KEY
                end
                local vertShaderStr = DEFAULT_VERTEX_SHADER
                local fragShaderStr = DEFAULT_FRAGMENT_SHADER
                if M.params.vsSrc then vertShaderStr = FileUtil.readFile(M.params.vsSrc)
                elseif M.params.vsStr then vertShaderStr = M.params.vsStr end
                
    
                if M.params.fsSrc then fragShaderStr = FileUtil.readFile(M.params.fsSrc)
                elseif M.params.fsStr then fragShaderStr = M.params.fsStr end
                
                glProgram = cc.GLProgram:createWithByteArrays(vertShaderStr, fragShaderStr)
                if shaderKey then
                    glProgramCache:addGLProgram(glProgram, shaderKey)
                end
            end
    
            if glProgram then
                local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    
                if type(M.params.onState) == "function" then
                    M.params.onState(node,glProgramState,glProgram)
                elseif type(M.params.uniform) == "table" then
                    for k,v in pairs(M.params.uniform) do
                        if tolua.type(v) == "cc.Texture2D" then
                            --Tex需要retain()或从Cache中取
                            glProgramState:setUniformTexture(k,v)
                        elseif type(v) == "number" then
                            glProgramState:setUniformFloat(k,v)
                        elseif type(v) == "table" then
                            glProgramState:setUniformVec2(k,cc.vec3(v.x or 0,v.y or 0,v.z or 0))
                        end
                    end
                elseif type(M.params.uniform) == "function" then
                    M.params.uniform(node,glProgramState,glProgram)
                end
    
                node:setGLProgramState(glProgramState)
                return glProgram
            end
        end
    end
    
    return M
end