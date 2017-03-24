//このシェーダーは法線に基づいてメッシュを着色します。頂点入力として、appdata_base を使用します
//出典：https://docs.unity3d.com/ja/current/Manual/SL-VertexProgramInputs.html

Shader "tutorial/VertexInputSimple" {
	SubShader{
		Pass{

			CGPROGRAM

			//頂点シェーダーとフラグメントシェーダーのプログラミング
			//フラグメントシェーダーは#pragmaステートメントでどのシェーダー関数を使ってコンパイルするかを示す
			//それぞれのスニペットには最低でも頂点プログラムとフラグメントプログラムが含まれている必要がある
			//https://docs.unity3d.com/ja/current/Manual/SL-ShaderPrograms.html

			//サーフェイスシェーダーコンパイルディレクティブ
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"	//unity専用の組み込み宣言や関数をインクルード

			//セマンティクスは、シェーダー入力またはシェーダー出力に付加されている文字列でパラメーターの使用目的に関する情報を伝達する
			//シェーダーステージ間で渡されるすべての変数に指定する必要がある
			//セマンティクスのリファレンスは下記のリンクにある
			//https://msdn.microsoft.com/ja-jp/library/bb509647(v=vs.85).aspx
			//
			//セマンティクスは、次のいずれかの位置に記述する
			//
			//- 構造体メンバーの後
			//- 関数の入力引数リスト内の引数の後
			//- 関数の入力引数リストの後

			struct v2f
			{
				float4 pos : SV_POSITION;	//SV_POSITIONは相同空間内（カメラを通して描画された後の画面空間）の頂点位置を示すセマンティクス、ラスタライザー
				fixed4 color : COLOR;		//4次の固定小数点型
			};

			//頂点データの流し込みは、1つずつデータを渡す代わりに、しばしば 1つの構造体として宣言される
			//一般的に使用される頂点構造体は、UnityCG.cginc の include ファイル で定義されている
			//構造体には以下のものがあります。
			//
			//appdata_base : 位置、法線および 1 つのテクスチャ座標で構成されます。
			//appdata_tan : 位置、接線、法線および 1 つのテクスチャ座標で構成されます。
			//appdata_full : 位置、接線、法線、4 つのテクスチャ座標および色で構成されています。
			//出典：https://docs.unity3d.com/ja/current/Manual/SL-VertexProgramInputs.html

			v2f vert(appdata_base v)
			{
				v2f o;

				//Tranforms position from object to homogenous space
				o.pos = UnityObjectToClipPos(v.vertex);
				//UnityCG.cginc内で定義されているappdata_baseを利用し頂点位置を入力として関数に渡している
				//UnityObjectToClipPos関数は オブジェクトの変換座標（Tranforms position）を相同空間（homogenous space）座標として返す

				o.color.xyz = v.normal * 0.5 + 0.5;
				o.color.w = 1.0;
				return o;
			}

			//頂点シェーダーの返値をiで受け取っているらしい
			//v2fのようなラスタライザーに渡す為の「形式」を入力にしておけば良いらしい
			//おそらくSV_POSITIONセマンティクスのデーターを拾ってきている
			fixed4 frag(v2f i) : SV_Target	//SV_Targetセマンティクスはこの関数がレンダーターゲットの配列（ラスタライザー）である事を指定している
			{
				return i.color;
			}

			ENDCG
		}
	}
}