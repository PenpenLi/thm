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
