// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GabroMedia/SnowLayered"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_BlendPower("BlendPower", Float) = 1
		_Contrast("Contrast", Float) = 5
		_Mesh_Basecolor("Mesh_Basecolor", 2D) = "white" {}
		[Normal]_Mesh_Normal("Mesh_Normal", 2D) = "bump" {}
		_Snow_BC("Snow_BC", 2D) = "white" {}
		_Mesh_MTS("Mesh_MTS", 2D) = "white" {}
		[Normal]_Snow_N("Snow_N", 2D) = "bump" {}
		_Snow_MTSA("Snow_MTS(A)", 2D) = "white" {}
		_Mesh_AO("Mesh_AO", 2D) = "white" {}
		_OcclusionContrast("OcclusionContrast", Float) = 0.2
		_Snow_AOR("Snow_AO(R)", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Mesh_Normal;
		uniform float4 _Mesh_Normal_ST;
		uniform sampler2D _Snow_N;
		uniform sampler2D _Mesh_AO;
		uniform float4 _Mesh_AO_ST;
		uniform float _OcclusionContrast;
		uniform float _Contrast;
		uniform float _BlendPower;
		uniform sampler2D _Mesh_Basecolor;
		uniform float4 _Mesh_Basecolor_ST;
		uniform sampler2D _Snow_BC;
		uniform sampler2D _Mesh_MTS;
		uniform float4 _Mesh_MTS_ST;
		uniform sampler2D _Snow_MTSA;
		uniform sampler2D _Snow_AOR;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Mesh_Normal = i.uv_texcoord * _Mesh_Normal_ST.xy + _Mesh_Normal_ST.zw;
			float2 uv_Mesh_AO = i.uv_texcoord * _Mesh_AO_ST.xy + _Mesh_AO_ST.zw;
			float4 tex2DNode23 = tex2D( _Mesh_AO, uv_Mesh_AO );
			float clampResult40 = clamp( ( tex2DNode23.r * _OcclusionContrast ) , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float lerpResult4 = lerp( 0.0 , _Contrast , pow( ase_worldPos.y , _BlendPower ));
			float clampResult5 = clamp( lerpResult4 , 0.0 , 1.0 );
			float temp_output_34_0 = ( clampResult40 * clampResult5 );
			float3 lerpResult20 = lerp( UnpackNormal( tex2D( _Mesh_Normal, uv_Mesh_Normal ) ) , UnpackNormal( tex2D( _Snow_N, i.uv_texcoord ) ) , temp_output_34_0);
			o.Normal = lerpResult20;
			float2 uv_Mesh_Basecolor = i.uv_texcoord * _Mesh_Basecolor_ST.xy + _Mesh_Basecolor_ST.zw;
			float4 lerpResult10 = lerp( tex2D( _Mesh_Basecolor, uv_Mesh_Basecolor ) , tex2D( _Snow_BC, i.uv_texcoord ) , temp_output_34_0);
			o.Albedo = lerpResult10.rgb;
			float2 uv_Mesh_MTS = i.uv_texcoord * _Mesh_MTS_ST.xy + _Mesh_MTS_ST.zw;
			float4 tex2DNode21 = tex2D( _Mesh_MTS, uv_Mesh_MTS );
			float lerpResult44 = lerp( tex2DNode21.r , 0.0 , temp_output_34_0);
			o.Metallic = lerpResult44;
			float lerpResult22 = lerp( tex2DNode21.a , tex2D( _Snow_MTSA, i.uv_texcoord ).a , temp_output_34_0);
			o.Smoothness = lerpResult22;
			float lerpResult24 = lerp( tex2DNode23.r , tex2D( _Snow_AOR, i.uv_texcoord ).r , temp_output_34_0);
			o.Occlusion = lerpResult24;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
1921;6;1906;1010;2429.628;1763.257;1.069398;True;True
Node;AmplifyShaderEditor.RangedFloatNode;11;-1851.642,597.3154;Float;False;Property;_BlendPower;BlendPower;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-1862.971,401.6251;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;3;-1538.642,485.3154;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1677.642,54.67035;Float;False;Property;_OcclusionContrast;OcclusionContrast;14;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1529.642,335.3153;Float;False;Property;_Contrast;Contrast;6;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1794.993,-266.0282;Float;True;Property;_Mesh_AO;Mesh_AO;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1396.642,126.6703;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-1344.642,401.3153;Float;False;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;5;-952.0659,373.2267;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-1622.509,-1395.597;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;40;-972.6419,135.1704;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-798.4335,182.2111;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-929.9456,-1010.45;Float;True;Property;_Snow_AOR;Snow_AO(R);15;0;Create;True;0;0;False;0;2554b6e249e036e49b717e6f4d0a8b60;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1799.034,-910.4675;Float;True;Property;_Mesh_Basecolor;Mesh_Basecolor;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1800.074,-466.7341;Float;True;Property;_Mesh_MTS;Mesh_MTS;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-940.1085,-1439.81;Float;True;Property;_Snow_N;Snow_N;11;1;[Normal];Create;True;0;0;False;0;d85df4e2db4b28f429d5c399147ab3c6;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-948.614,-1632.743;Float;True;Property;_Snow_BC;Snow_BC;9;0;Create;True;0;0;False;0;ac9564c2ef06553459f0b0df6f4c176b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1805.156,-695.3871;Float;True;Property;_Mesh_Normal;Mesh_Normal;8;1;[Normal];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-935.0265,-1211.157;Float;True;Property;_Snow_MTSA;Snow_MTS(A);12;0;Create;True;0;0;False;0;77ae8d8c124dc0e458596c32534e1702;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-201.134,-442.7758;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;22;-210.8714,-61.91824;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-204.8839,-260.506;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-202.1523,-600.6292;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;24;-226.1149,152.7608;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;196,-114;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;GabroMedia/SnowLayered;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;17;2
WireConnection;3;1;11;0
WireConnection;43;0;23;1
WireConnection;43;1;42;0
WireConnection;4;1;12;0
WireConnection;4;2;3;0
WireConnection;5;0;4;0
WireConnection;40;0;43;0
WireConnection;34;0;40;0
WireConnection;34;1;5;0
WireConnection;27;1;62;0
WireConnection;25;1;62;0
WireConnection;28;1;62;0
WireConnection;26;1;62;0
WireConnection;20;0;19;0
WireConnection;20;1;25;0
WireConnection;20;2;34;0
WireConnection;22;0;21;4
WireConnection;22;1;26;4
WireConnection;22;2;34;0
WireConnection;44;0;21;1
WireConnection;44;2;34;0
WireConnection;10;0;18;0
WireConnection;10;1;28;0
WireConnection;10;2;34;0
WireConnection;24;0;23;1
WireConnection;24;1;27;1
WireConnection;24;2;34;0
WireConnection;0;0;10;0
WireConnection;0;1;20;0
WireConnection;0;3;44;0
WireConnection;0;4;22;0
WireConnection;0;5;24;0
ASEEND*/
//CHKSM=EC5B080B7F66FBC2DD7C8C050A7F358CBF405EED