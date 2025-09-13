// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GabroMedia/Godrays"
{
	Properties
	{
		_Ray_Color("Ray_Color", Color) = (1,0.9607844,0.8784314,1)
		_Ray_Intensity("Ray_Intensity", Float) = 1.2
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Noise_Intensity("Noise_Intensity", Float) = 0.5
		_Fade("Fade", Float) = 50
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Ray_Color;
		uniform float _Ray_Intensity;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float _Noise_Intensity;
		uniform float _Fade;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( _Ray_Color * _Ray_Intensity ).rgb;
			float2 panner10 = ( 1.0 * _Time.y * float2( 0.01,0 ) + i.uv_texcoord);
			float2 panner11 = ( 1.0 * _Time.y * float2( 0,0.01 ) + i.uv_texcoord);
			float clampResult19 = clamp( ( i.eyeDepth / _Fade ) , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV22 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode22 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV22, 0.5 ) );
			o.Alpha = ( ( ( ( tex2D( _TextureSample0, panner10 ).r * tex2D( _TextureSample1, panner11 ).r ) + _Noise_Intensity ) * clampResult19 ) * ( 1.0 - fresnelNode22 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
1927;1;1906;1010;1019.429;375.724;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3207.837,116.2326;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;27;-3028.837,-161.7674;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;False;0;0.01,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;28;-3050.837,315.2326;Float;False;Constant;_Vector1;Vector 1;7;0;Create;True;0;0;False;0;0,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-2754.553,-152.8117;Float;False;3;0;FLOAT2;-0.01,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-2761.553,156.1881;Float;False;3;0;FLOAT2;0,-0.01;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;-2435.554,131.1881;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;d2582041596c2d34eacc851e3f504e33;e22367f851a12c643a0434abf951ee30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-2436.554,-148.8117;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;e22367f851a12c643a0434abf951ee30;d2582041596c2d34eacc851e3f504e33;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SurfaceDepthNode;16;-2172.201,443.4888;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2101.202,552.4888;Float;False;Property;_Fade;Fade;5;0;Create;True;0;0;False;0;50;35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2024.556,38.18825;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-1878.203,511.4888;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2090.457,288.7843;Float;False;Property;_Noise_Intensity;Noise_Intensity;4;0;Create;True;0;0;False;0;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1853.753,155.145;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;19;-1717.203,512.4888;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;22;-1212.103,452.2859;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-400,-70.5;Float;False;Property;_Ray_Intensity;Ray_Intensity;1;0;Create;True;0;0;False;0;1.2;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1605.203,270.4889;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-439,-285.5;Float;False;Property;_Ray_Color;Ray_Color;0;0;Create;True;0;0;False;0;1,0.9607844,0.8784314,1;1,0.9607844,0.8784314,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;23;-920.0281,433.8501;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-647.9386,184.0895;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-112,-145.5;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;224.4493,-79.51276;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;GabroMedia/Godrays;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;26;0
WireConnection;10;2;27;0
WireConnection;11;0;26;0
WireConnection;11;2;28;0
WireConnection;8;1;11;0
WireConnection;7;1;10;0
WireConnection;9;0;7;1
WireConnection;9;1;8;1
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;12;0;9;0
WireConnection;12;1;13;0
WireConnection;19;0;18;0
WireConnection;14;0;12;0
WireConnection;14;1;19;0
WireConnection;23;0;22;0
WireConnection;21;0;14;0
WireConnection;21;1;23;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;0;2;4;0
WireConnection;0;9;21;0
ASEEND*/
//CHKSM=8FE82FC99B2C512EB559C240A678CCAD0A47D272