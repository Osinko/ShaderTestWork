//非常にシンプルなランバートシェーダ
Shader "tutorial/surfaceshader001" {
	Properties{
		_Tex("Base (RGB)",2D) = "red" {}		//変数名の前に「_」アンダーバーを付ける事には意味がある
	}

		SubShader{

			Tags{ "RenderType" = "Opaque" }		//描画順指定

			CGPROGRAM

			#pragma surface surf Lambert		//コンパイル指定

			struct Input {
				float2 uv_Tex;
				//サンプラー変数名の前に「uv」というキーワードを付けると自動的にテクスチャのuv座標を拾う
				//つまり変数名によりunityのMeshRenderやSpriteRenderのマテリアル経由でデーターを受け取ることもできる
			};

			sampler2D _Tex;

			void surf(Input IN, inout SurfaceOutput o) {
				o.Albedo = tex2D(_Tex, IN.uv_Tex);
			}
		
			ENDCG
	}

	FallBack "Diffuse"
}