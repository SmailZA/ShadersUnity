Shader "Custom/SS_ShaderNormi"
{
    Properties
    {
		
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_NormalTex("Normal Map", 2D) = "bump"{}
		
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
	   #pragma surface surf Lambert
		// Link the property to the CG program
		sampler2D _NormalTex;
		float4 _MainTint;
        struct Input
        {
            float2 uv_NormalTex;

        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
			o.Albedo = tex2D(_NormalTex, IN.uv_NormalTex).rgb;
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = normalMap.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
