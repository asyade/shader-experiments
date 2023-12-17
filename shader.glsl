
#define RECURSION_LIMIT 200
#define PI 3.141592653589793238

// Method for the mathematical construction of the julia set
int juliaSet(vec2 c,vec2 constant){
    int recursionCount;
    vec2 z=c;
    for(recursionCount=0;recursionCount<RECURSION_LIMIT;recursionCount++){
        z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+constant;

        if(length(z)>2.){
            break;
        }
    }
    return recursionCount;
}

vec3 lerp(vec3 colorone, vec3 colortwo, float value){
        return (colorone + value*(colortwo-colorone));
}
PS C:\Users\corbe\Repos\shader> cat .\shader.glsl
#include "fractal.glsl"

vec3 palette(float t){
    vec3 a=vec3(0.5647, 0.2824, 0.2824);
    vec3 b=vec3(0.2196, 0.4118, 0.3647);
    vec3 c=vec3(0.5098, 0.549, 0.298);
    vec3 d=vec3(0.4784, 0.4941, 0.5176);
    return a+b*cos(6.28318*(c*t+d));
}

float wavyCircle(vec2 uv, float amplitude, float numWaves) {
    float theta = atan(uv.y, uv.x);
    float r = length(uv);

    float wavyRadius = 0.5 + amplitude * sin(numWaves * theta);

    return smoothstep(0.01, 0.0, abs(r - wavyRadius));
}

float julia(vec2 uv) {
    float a=PI+sin(iTime);
    vec2 U=vec2(cos(a),sin(a));// U basis vector (new x axis)
    vec2 V=vec2(-U.y,U.x);// V basis vector (new y axis)
    uv=vec2(dot(uv,U),dot(uv,V));// Rotationg the uv

    vec2 c=uv;
    int recursionCount=juliaSet(c,vec2(.2+.1*sin(.9*(10.*iTime)*.9),.1+.1*cos(.9*(10.*iTime)*.9)));
    float f=float(recursionCount)/float(RECURSION_LIMIT);

    return pow(f,1.-(f*1.));
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=(fragCoord*2.-iResolution.xy)/iResolution.y;

    vec3 fractalMul = vec3(0.0);
    fractalMul+=vec3(0.,smoothstep(0.,1.,julia(uv * 1.8 + (iTime * 0.00002)))*0.2,0.0+iTime*0.00002);

    vec2 uv0=uv;
    vec3 finalColor=vec3(0.);

    float glowFrequency=10.*iTime;
    float d=length(uv)*exp(-length(uv0));

    vec3 col=palette(length(uv0)/10.);


    d=fract(sin(d*9.+(.8*iTime)))/40.;


    float theta = atan(uv.y, uv.x);
    float r = length(uv);

    float A = 0.001+cos(iTime)*0.01;  // Amplitude
    float k = 4.;  // Number of waves
    float wavyRadius = d + A * sin(k * theta);

    d=abs(wavyRadius);
    d=pow(.001/d,.2);

    finalColor+=vec3(0.0,0.,col.r*d);

    for(float i=0.;i<.0197*iTime;i++){
        uv=fract(uv*1.5)-.5;
        d=length(uv)*exp(-length(uv0));
        col=palette(length(uv0));

        d=sin(d*9.+(.2*iTime))/10.;
        d=abs(d);
        d=pow(.02/d,1.+iTime*0.00002);

        finalColor+=(col*d);
    }

    fragColor=vec4(lerp(finalColor, vec3(fractalMul), 0.3) ,1.);
}
