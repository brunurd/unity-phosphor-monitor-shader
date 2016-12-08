Shader "Hidden/PhosphorMonitor" {
	
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Scanline ("Scanline", Int) = 100010
		_Vignette ("Vignette", Range(0.0,1.0)) = 0.35
		_Green ("Green",Range(0.0,1.0)) = 0.5
		_White("White",Range(0.0,1.0)) = 0.8
	}
	
	SubShader {
		
		Cull Off
		ZWrite Off
		ZTest Always

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			uniform sampler2D _MainTex;
			int _Scanline;
			fixed _Vignette;
			fixed _Green;
			fixed _White;
			
			fixed4 frag (v2f i) : SV_Target {

				// SCANLINES
				int y = (i.uv.y * _Scanline) % 2;
				float scanline = 0.15f * y;

				// VIGNETTE
				float2 rectangle = float2(0.5f - i.uv.x, 0.5f - i.uv.y);
				float vignette = (sqrt(pow(rectangle.x, 2) + pow(rectangle.y, 2))) - _Vignette;

				// UV MAPPING
				fixed4 col = tex2D(_MainTex, i.uv);

				// GRAYSCALE
				float grayscale = (col.r + col.g + col.b) / 3;
				float finalCol = ((grayscale / _White) - scanline) - vignette;
				
				col.r = finalCol;
				col.g = (finalCol / _Green);
				col.b = finalCol;
				return col;
			}
			ENDCG
		}
	}
}
