Shader "Unlit/UnlitShader4"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
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
            }

            fixed4 frag (v2f i) : SV_Target
            {
             fixed len = distance(i.uv, fixed2(0.5, 0.5)) + _Time;

             fixed wave = sin(len * 50);

             fixed waveIndex = floor(len * 50 / (2 * UNITY_PI)); // 波のインデックスを取得



             fixed4 color;

             if (step(0.9, wave))

             {

               // 波ごとにランダムな色を割り当てる

               fixed randomSeed = sin(waveIndex * 123.456 + 789.012);

               color = fixed4(abs(sin(randomSeed * 10)), abs(sin(randomSeed * 20)), abs(sin(randomSeed * 30)), 1);

               }

              else

              {

                 color = fixed4(0, 0, 0, 1); // 波がない部分は黒

               }



               return color;

            }
            
            ENDCG
        }
    }
}
