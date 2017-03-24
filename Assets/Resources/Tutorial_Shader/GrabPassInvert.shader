//半透明のマテリアルと仕組み的によく似ている。応用するとこんなことができるという例
Shader "tutorial/GrabPassInvert"
{
    SubShader
    {
		//描画タイミングをタグで指示する
        //この場合、すべての不透明なジオメトリの後に自分自身を描く
        Tags { "Queue" = "Transparent" }

        // オブジェクトの背後のスクリーンを　_BackgroundTexture　にグラブ
        GrabPass
        {
            "_BackgroundTexture"
        }

        //上記で生成されたテクスチャでオブジェクトをレンダリングし、色を反転させる
		Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
			struct v2f
            {
                float4 grabPos : TEXCOORD0;		//TEXCOORD0 は、第 1 の UV 座標
                float4 pos : SV_POSITION;		//相同座標
            };

            v2f vert(appdata_base v) {
                v2f o;
				//UnityCG.cgincのUnityObjectToClipPos関数を使用してクリップ空間の頂点位置を計算する
                o.pos = UnityObjectToClipPos(v.vertex);
				//UnityCG.cgincのComputeGrabScreenPos関数を使用してテクスチャ座標を取得する
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;

            half4 frag(v2f i) : SV_Target
            {
				//tex2Dproj (DirectX HLSL)  HLSLの組み込み関数を利用している
				//https://msdn.microsoft.com/ja-jp/library/bb509681(v=vs.85).aspx
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                return 1.0 - bgcolor;
            }
            ENDCG
        }
    }
}