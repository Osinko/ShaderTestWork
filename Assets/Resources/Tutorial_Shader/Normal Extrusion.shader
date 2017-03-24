//サーフェイスシェーダーとしてコーディングされている
//マテリアルで指定した量だけ法線に沿って頂点を動かすシェーダー

Shader "tutorial/Normal Extrusion" {

	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_Amount("Extrusion Amount", Range(-1,1)) = 0.5
	}

	SubShader{
		//不透明オブジェクトとしてレンダリング
		Tags{ "RenderType" = "Opaque" }
		
		CGPROGRAM
		//サーフェイスシェーダーとして「surf」関数をコンパイル。光源処理はランバート。頂点処理は「vert」関数を利用する
		#pragma surface surf Lambert vertex:vert
		
		struct Input {
			float2 uv_MainTex;
		};

		//unityのプロパティから受け取る
		float _Amount;
		sampler2D _MainTex;

		void vert(inout appdata_full v) {
			v.vertex.xyz += v.normal * _Amount;
		}
	
		void surf(Input IN, inout SurfaceOutput o) {		//SurfaceOutput型というものがある
			//tex2D (DirectX HLSL)
			//https://msdn.microsoft.com/ja-jp/library/bb509677(v=vs.85).aspx
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;	//uvに従いテクスチャを貼り付けている
		}

		ENDCG
	}

	Fallback "Diffuse"
}
