Shader "Custom/PaletteTexture"
{
	Properties
	{
		_MainTex ("Sprite Texture", 2D) = "white" {}
		_Palette ("Palette Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend One OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Tint;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord;
				// Removed the tinting here, since it would tint the palette map
				OUT.color = IN.color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _Palette;

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 paletteMapColor = tex2D(_MainTex, IN.texcoord) * IN.color;
				
				// The alpha channel of the palette map points to UVs in the palette key.
				float paletteIndex = paletteMapColor.a;
				float2 paletteUV = float2(paletteIndex, 0);
				
				// Get the color from the palette key
				fixed4 outColor = tex2D(_Palette, paletteUV);
				
				// Why do we need to do this? This is in the default shader, and without it, our alpha'ed out areas
				// are hazy. But why?
				//outColor.rgb *= paletteMapColor.a;
				//outColor.a = paletteMapColor.a;
				
				// Apply the tint to the final color
				outColor *= _Tint;
				return outColor;
			}
		ENDCG
		}
	}
}