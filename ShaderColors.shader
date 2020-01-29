Shader "Unlit/ShaderColors"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0, 0.5)) = 0.25
		_CutoutThresh("Cutout Threshold", Range(0.0, 1.0)) = 0.2
		_Distance("Distance", Float) = 1
		_Amplitude("Amplitude", Float) = 1
		_Speed("Speed", Float) = 1
		_Amount("Amount", Range(0.0, 1.0)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
        

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
				float4 colors : COLOR;
                float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
				float2 uv0 : TEXCOORD0;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _TintColor;
			float _Transparency;
			float _CutoutThresh;
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;

			VertexOutput vert (VertexInput v)
            {
				VertexOutput o;
				v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);
                return o;
            }

			fixed4 frag(VertexOutput o) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, o.uv0) + _TintColor;
				col.a = _Transparency;
				clip(col.r - _CutoutThresh);
				return col;
            }
            ENDCG
        }
    }
}