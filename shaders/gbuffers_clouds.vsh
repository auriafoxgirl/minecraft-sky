#version 120

varying vec2 texcoord;
varying vec4 glcolor;

varying float vertexDistance;

uniform mat4 ModelViewMat;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
	vertexDistance = length(gl_Vertex.xz) * 0.005;
}