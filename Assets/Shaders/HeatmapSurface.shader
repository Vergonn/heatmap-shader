Shader "Custom/Heatmap-Diffuse"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        
        _HeatTex ("Heatmap", 2D) = "white" { }
        _HeatTex2 ("Heatmap 2", 2D) = "white" { }
        _ColorSchemeTex ("Texture", 2D) = "white" { }
        
        _Intensity ("Intensity", Range(0, 5)) = 1
        _Distance ("Distance", Float) = 1
        _Interpolation ("Interpolation", Range(0, 1)) = 1
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        fixed4 _Color;
        
        sampler2D _HeatTex;
        sampler2D _HeatTex2;
        sampler2D _ColorSchemeTex;
        float _Intensity;
        float _Interpolation;
        float _Distance;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            float4 heat = lerp(tex2D(_HeatTex, IN.uv_MainTex), tex2D(_HeatTex2, IN.uv_MainTex), _Interpolation);
            
            float intensity = 1 - heat.r;
            
            col += saturate(_Distance * (tex2D(_ColorSchemeTex, float2(intensity, IN.uv_MainTex.y)) * _Intensity * saturate(_Distance)) - 0.5);
            
            o.Albedo = col.rgb;
            o.Alpha = col.a;
        }
        ENDCG
        
    }
    
    Fallback "Legacy Shaders/VertexLit"
}