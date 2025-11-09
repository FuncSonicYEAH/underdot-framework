shader_type canvas_item;

uniform float limit=0.3;//声明变量 limit,默认值是0.5

void fragment(){
    COLOR=texture(TEXTURE,UV);
    if(COLOR.a<limit){      //把0.5替换成 limit
        COLOR.a=0.0;
    }else{
        COLOR.a=1.0;
    }
}