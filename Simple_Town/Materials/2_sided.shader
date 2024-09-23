Shader "Custom/NewSurfaceShader" {
	Properties {
	_ColorTint ("Tint", Color) = (1.0, 1.0, 1.0, 1.0)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType" = "Transparent" }
		Cull Off
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Standard alphatest:_Cutoff
       // #pragma surface surf Unlit alphatest:_Cutoff
	  // #pragma surface surf Lambert vertex:vert
		
		#pragma target 3.0

		struct Input 
{
float2 uv_MainTex;
};
sampler2D _MainTex;	
		

		half _Glossiness;
		half _Metallic;
		fixed4 _ColorTint;
		half4 LightingUnlit(SurfaceOutput s, half3 lightDir, half atten)
{
return half4(s.Albedo, s.Alpha);
}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _ColorTint;
			o.Albedo = c.rgb;
			
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
