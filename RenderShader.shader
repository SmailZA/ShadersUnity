Shader "Unlit/RenderShader"
{
    Properties
    {
		_Color ("Color", Color) = (1,1,1,1)
		_WaterShallow ("WaterShallow", Color) = (1,1,1,1)
		_WaterDeep ("WaterDeep", Color) = (1,1,1,1)
		_WaveColor ("WaveColor", Color) = (1,1,1,1)
		_Gloss ("Gloss", Float) = 1 
        _ShorelineTex ("Shoreline", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

			//MeshData
            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 colors : COLOR;
                float2 uv0 : TEXCOORD0;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD1;
            };

            struct VertexOutput
            {
                UNITY_FOG_COORDS(1)
                float4 ClipSpacePos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
				float3 normal : NORMAL;
				float3 worldPos : TEXCOORD2;

            };

			sampler2D _ShorelineTex;
            
			float4 _Color;
			float _Gloss;
			uniform float3 _MousePos;
			float3 _WaterShallow;
			float3 _WaterDeep;
			float3 _WaveColor;

			VertexOutput vert (VertexInput v)
            {
				VertexOutput o;
				o.uv0 = v.uv0;
				o.normal = v.normal;
				o.worldPos = mul( unity_ObjectToWorld, v.vertex);
                o.ClipSpacePos = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			//value = lerp(a, b, t)
			//t = inverslerp(a, b, value)

			float InvLerp(float a, float b, float value)
			{

				return (value - a) / (b - a);
			}

			float3 MyLerp(float3 a, float3 b, float3 t)
			{
				

				return t * b + (1.0 - t) * a;
			}


			float Posterize(float steps, float value)
			{
				
				return floor(value * steps) / steps;
			}

			float4 frag(VertexOutput o) : SV_Target
			{
				
				float shoreline = tex2D(_ShorelineTex, o.uv0).x;
				float waveSize = 0.02;
				//-float shape = o.uv0.y;
				float shape = shoreline;
				float waveAmp = (sin(shape / waveSize + _Time.y * 4) + 1) * 0.5;
				waveAmp *= shoreline;
				float3 waterColor = lerp(_WaterDeep, _WaterShallow, shoreline);
				float3 waterWithWaves = lerp(waterColor, _WaveColor, waveAmp);
			
				return float4 (waterWithWaves, 0);
				return frac(_Time.y);
				return shoreline;

				float dist = distance(_MousePos, o.worldPos);
				
				float glow = saturate(1 - dist);

				//-return dist;

				float2 uv = o.uv0;
				


				float3 colorA = float3(0.1,0.8,1);
				float3 colorB = float3(1,0.1,0.8);
				//float t = step(uv.y, 0.5);
				float t = uv.y;

				t = Posterize(16, t);


				//return t;
				float3 blend = MyLerp(colorA, colorB, t);



				//return float4(blend, 0);
				float3 normal = normalize(o.normal);//Interpolated

				//Lightning
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;

				//Direct Diffuse Lightning
				float lightFalloff = max(0, dot(lightDir, normal));
				float3 directDiffuseLight = lightFalloff * lightColor;
				//-lightFalloff = Posterize(3, lightFalloff);

				//Ambient Light
				float3 ambientLight = float3(0.1, 0.1, 0.1);

				//Direct Specular Light
				float3 CamPos = _WorldSpaceCameraPos;
				float3 fragToCam = CamPos - o.worldPos;
				float3 viewDir = normalize(fragToCam);
				float3 viewReflect = reflect(-viewDir, normal);
				float specularFalloff = max(0, dot(viewReflect, lightDir));

				//Modify Gloss
				specularFalloff = pow(specularFalloff, _Gloss);
				//-specularFalloff = Posterize(8, specularFalloff);
				float3 directSpecular = specularFalloff * lightColor;
				
				//-return float4(specularFalloff.xxx , 0);

				//Specular Lightning = Phong & Bliin-Phong
				 
				 

				//Composite
				float3 diffuseLight = ambientLight + directDiffuseLight;
				float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecular + glow;

                return float4(finalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}
