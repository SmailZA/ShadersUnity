// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/US_ShaderBubbles"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

           
			 struct v2f {
				float4 position : SV_POSITION;
			};

			v2f vert(float4 v:POSITION) : SV_POSITION {
				v2f o;
				o.position = UnityObjectToClipPos(v);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = -1.0 + 2.0 * i.position.xy / _ScreenParams.xy;
				uv.x *= _ScreenParams.x / _ScreenParams.y;

				fixed4 outColor = fixed4(0.8 + 0.2 * uv.y, 0.8 + 0.2 * uv.y, 0.8 + 0.2 * uv.y, 1);
				for (int i = 0; i < 40; i++)
				{
					float phase = sin(float(i) * 534.13 + 1.0) * 0.5 + 0.5;
					float size = pow(sin(float(i) * 651.5 + 5.0) * 0.5 + 0.5, 4.0);
					float pox = sin(float(i) * 300 + 4.1);
					float radius = 0.1 + 0.5 * size;
					float2 position = float2(pox, -1.0 - radius + (2.0 + 2.0 - radius) * fmod(phase + 0.1 * _Time.y * (0.2 + 0.8 * size), 1.0));
					float distance = length(uv - position);
					float3 columns = lerp(float3(1.0, 0.3, 0.0), float3(0.1, 0.4, 0.8), 0.5 + 0.2 * sin(float(i) * 1.2 + 1.9));

					columns += 8.0 * smoothstep(radius * 0.95, radius, distance);

					float f = length(uv - position) / radius;
					f = sqrt(clamp(1.0 - f * f, 0.0, 1.0));

					outColor.rgb -= columns.xzy * (1.0 - smoothstep(radius * 0.95, radius, distance)) * f;
				}

				outColor *= sqrt(1.5 - 0.5 * length(uv));

				return outColor;
            }
            ENDCG
        }
    }
}
