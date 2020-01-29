Shader "Custom/SS_ShaderNormi1"
{
		Properties{
	   _MainTex("Texture", 2D) = "white" {}
	   _BumpMap("Bumpmap", 2D) = "bump" {}
	   _NormalMapIntensity("Normal Intensity", Range(0, 5)) = 1
		}
			SubShader{
			  Tags { "RenderType" = "Opaque" }
			  CGPROGRAM
			  #pragma surface surf Lambert
			  struct Input {
				float2 uv_MainTex;
				float2 uv_BumpMap;
			  };
			  sampler2D _MainTex;
			  sampler2D _BumpMap;
			  fixed3 _NormalMapIntensity;
			  void surf(Input IN, inout SurfaceOutput o) {
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
				o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				/*n.x *= _NormalMapIntensity;
				n.y *= _NormalMapIntensity;
				o.Normal = normalize(n);*/
			  }
        ENDCG
    }
    FallBack "Diffuse"


		//	Properties
		//{
		//	_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		//	//_NormalTex("Normal Texture", 2D) = "bump"{}
		//	_MainTex("Base (RGB)", 2D) = "white" {}
		//	_BumpTex("Bumped Texture", 2D) = "Bump"{}
		//	_NormalMapIntensity("Normal Intensity", Range(0,1)) = 1

		//}
		//	SubShader
		//	{
		//		Tags { "RenderType" = "Opaque" }
		//		LOD 200

		//		CGPROGRAM
		//		// Physically based Standard lighting model, and enable shadows on all light types
		//		#pragma surface surf Standard fullforwardshadows

		//		// Use shader model 3.0 target, to get nicer looking lighting
		//		#pragma target 3.0

		//		//sampler2D _NormalTex;
		//		float4 _MainTint;
		//		fixed3 _NormalMapIntensity;
		//		sampler2D _MainTex;
		//		sampler2D _BumpTex;

		//		struct Input
		//		{
		//			//float2 uv_NormalTex;
		//			float2 uv_MainTex;
		//			float2 _BumpTex;


		//		};




		//		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		//		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		//		// #pragma instancing_options assumeuniformscaling
		//		UNITY_INSTANCING_BUFFER_START(Props)
		//			// put more per-instance properties here
		//		UNITY_INSTANCING_BUFFER_END(Props)

		//		void surf(Input IN, inout SurfaceOutputStandard o)
		//		{

		//			//float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
		//			fixed3 n = UnpackNormal(tex2D(_BumpTex, IN.uv_MainTex)).rgb;
		//			n.x *= _NormalMapIntensity;
		//			n.y *= _NormalMapIntensity;
		//			o.Normal = normalize(n);
		//			//o.Albedo = normalMap.rgb;

		//		}


		//	Properties{
	 //  _MainTex("Texture", 2D) = "white" {}
	 //  _BumpMap("Bumpmap", 2D) = "bump" {}
	 //  _NormalMapIntensity("Normal Intensity", Range(0, 5)) = 1
		//}
		//	SubShader{
		//	  Tags { "RenderType" = "Opaque" }
		//	  CGPROGRAM
		//	  #pragma surface surf Lambert
		//	  struct Input {
		//		float2 uv_MainTex;
		//		float2 uv_BumpMap;
		//	  };
		//	  sampler2D _MainTex;
		//	  sampler2D _BumpMap;
		//	  fixed3 _NormalMapIntensity;
		//	  void surf(Input IN, inout SurfaceOutput o) {
		//		o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		//		fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
		//		n.x *= _NormalMapIntensity;
		//		n.y *= _NormalMapIntensity;
		//		o.Normal = normalize(n);
		//	  }
}
