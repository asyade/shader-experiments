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
