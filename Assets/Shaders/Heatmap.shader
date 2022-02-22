Shader "Unlit/Heatmap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("Color", Color) = (1, 1, 1, 1)
        
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
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            
            sampler2D _HeatTex;
            sampler2D _HeatTex2;
            sampler2D _ColorSchemeTex;
            float _Intensity;
            float _Interpolation;
            float _Distance;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                fixed4 heat = lerp(tex2D(_HeatTex, i.uv), tex2D(_HeatTex2, i.uv), _Interpolation);
                
                float intensity = 1 - heat.r;
                
                col += saturate(_Distance * (tex2D(_ColorSchemeTex, float2(intensity, i.uv.y)) * _Intensity * saturate(_Distance)) - 0.5);
                
                return col;
            }
            ENDCG
            
        }
    }
}
