Shader "Unlit/US_ShaderNoiseColor"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

          /*  struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }*/
			fixed2 hash(fixed2 p) {
				p = fixed2(dot(p, fixed2(127.1, 311.7)), dot(p, fixed2(269.5, 183.3)));
				return -1.0 + 2.0 * frac(sin(p) * 43758.5453123);
			}

			float noise(in fixed2 p)
			{
				static const float K1 = 0.366025404;
				static const float K2 = 0.211324865;

				fixed2 i = floor(p + (p.x + p.y) * K1);

				fixed2 a = p - i + (i.x + i.y) * K2;
				fixed2 o = (a.x > a.y) ? fixed2(1.0, 0.0) : fixed2(0.0, 1.0);
				fixed2 b = a - o + K2;
				fixed2 c = a - 1.0 + 2.0 * K2;

				fixed3 h = max(0.5 - fixed3(dot(a, a), dot(b, b), dot(c, c)), 0.0);

				fixed3 n = h * h * h * h * fixed3(dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));
				return dot(n, fixed3(70.0, 70.0, 70.0));
			}

			static const float2x2 m = float2x2(0.80, -0.60, 0.60, 0.80);


			float fbm4(in fixed2 p)
			{
				float f = 0.0;
				f += 0.5000 * noise(p);
				p = mul(p, m) * 2.02;
				f += 0.2500 * noise(p);
				p = mul(p, m) * 2.03;
				f += 0.1250 * noise(p);
				p = mul(p, m) * 2.01;
				f += 0.0625 * noise(p);
				return f;
			}


			float fbm6(in fixed2 p)
			{
				float f = 0.0;
				f += 0.5000 * noise(p);
				p = mul(p, m) * 2.02;
				f += 0.2500 * noise(p);
				p = mul(p, m) * 2.03;
				f += 0.1250 * noise(p);
				p = mul(p, m) * 2.01;
				f += 0.0625 * noise(p);
				p = mul(p, m) * 2.04;
				f += 0.031250 * noise(p);
				p = mul(p, m) * 2.01;
				f += 0.015625 * noise(p);
				return f;
			}

			float turb4(in fixed2 p)
			{
				float f = 0.0;
				f += 0.5000 * abs(noise(p)); p = mul(p, m) * 2.02;
				f += 0.2500 * abs(noise(p)); p = mul(p, m) * 2.03;
				f += 0.1250 * abs(noise(p)); p = mul(p, m) * 2.01;
				f += 0.0625 * abs(noise(p));
				return f;
			}

			float turb6(in fixed2 p)
			{
				float f = 0.0;
				f += 0.5000 * abs(noise(p)); p = mul(p, m) * 2.02;
				f += 0.2500 * abs(noise(p)); p = mul(p, m) * 2.03;
				f += 0.1250 * abs(noise(p)); p = mul(p, m) * 2.01;
				f += 0.0625 * abs(noise(p)); p = mul(p, m) * 2.04;
				f += 0.031250 * abs(noise(p)); p = mul(p, m) * 2.01;
				f += 0.015625 * abs(noise(p));
				return f;
			}

			float marble(in fixed2 p)
			{
				return cos(p.x + fbm4(p));
			}

			float wood(in fixed2 p)
			{
				float n = noise(p);
				return n - floor(n);
			}

			float dowarp(in float2 q, out fixed2 a, out fixed2 b)
			{
				float ang = 0;
				ang = 1.2345 * sin(0.015 * _Time.y);
				float2x2 m1 = float2x2(cos(ang), sin(ang), -sin(ang), cos(ang));
				ang = 0.2345 * sin(0.021 * _Time.y);
				float2x2 m2 = float2x2(cos(ang), sin(ang), -sin(ang), cos(ang));

				a = fixed2(marble(mul(q, m1)), marble(mul(q, m2) + fixed2(1.12, 0.654)));

				ang = 0.543 * cos(0.011 * _Time.y);
				m1 = float2x2(cos(ang), sin(ang), -sin(ang), cos(ang));
				ang = 1.128 * cos(0.018 * _Time.y);
				m2 = float2x2(cos(ang), sin(ang), -sin(ang), cos(ang));


				b = fixed2(marble(mul((q + a), m2)), marble((mul((q + a), m1))));

				return marble(q + b + fixed2(0.32, 1.654));
			}

			fixed4 frag(v2f_img i) : SV_Target
			{
				//Position relative to screen
				fixed2 uv = (i.uv * _ScreenParams.xy) / _ScreenParams.xy;
				fixed2 q = 2. * uv - 1.;
				
				q.y = mul(q.y, (_ScreenParams.y / _ScreenParams.x));
				float Time = .1 * _Time.y;
				q += fixed2(4.0 * sin(Time), 0);

				q = mul(q, 3.4562);

				fixed2 a = fixed2(0., 0.);
				fixed2 b = fixed2(0., 0.);
				float f = dowarp(q, a, b);
				f = .5 + .5 * f;
				//Position relative to screen here
				//Color creation
				fixed3 col = fixed3(f, f, f);
				float c = 0.;
				c = f;
				//Defining the different colors to right order
				col = fixed3(c * c, c * c * c, c );
				c = abs(a.x);
				col -= fixed3(c * c * c, c, c * c);
				c = abs(b.x);
				col += fixed3(c, c * c, c * c * c);


				col = mul(col, .7);
				col.x = pow(col.x, 2.18);
				col.z = pow(col.z, 1.88);
				col = smoothstep(0, 1, col);
				col = .5 - (1.4 * col - .7) * (1.4 * col - .7);
				col = 1.25 * sqrt(col);
				col = clamp(col, 0, 1);

				return fixed4(col.x, col.y, col.z, 1);
            }
            ENDCG
        }
    }
}
