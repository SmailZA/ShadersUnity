Shader "Unlit/ShaderSomething"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TintColor ("Albedo", Color) = (1,1,1,1)
		_Transparency ("Transparency", Range(0.0, 1.0)) = 0.3
		_Speed("Speed", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
				float4 vertex : POSITION;
				float4 colors : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
            };

            struct v2f
            {
				float4 vertex : SV_POSITION;
				float2 uv0 : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _TintColor;
			float _Transparency;
			float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
				o.vertex.x = sin(_Time.y * _Speed * _TintColor.xyz);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			    fixed4 col = _TintColor;
				col.a = _Transparency;
				clip(col.r - _Transparency);
                return col;
            }
            ENDCG
        }
    }
}
