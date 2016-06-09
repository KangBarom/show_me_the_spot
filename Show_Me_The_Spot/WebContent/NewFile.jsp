<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Show Me The Spot</title>
<style type="text/css">
.seoul {
	stroke: rgb(255, 255, 255);
}

.gyeongin2 {
	stroke: rgb(237, 216, 166);
}

.gochang {
	stroke: rgb(242, 187, 153);
}

.gyeongbu {
	stroke: rgb(239, 176, 24);
}

.youngdong {
	stroke: rgb(156, 208, 163);
}

.joowang {
	stroke: rgb(11, 147, 86);
}

.pyeongtaek {
	stroke: rgb(48, 86, 44);
}

.gyeongin {
	stroke: rgb(232, 152, 163);
}

.joobu {
	stroke: rgb(228, 123, 106);
}

.donghae {
	stroke: rgb(231, 53, 137);
}

.honam {
	stroke: rgb(231, 44, 40);
}

.soahaeann {
	stroke: rgb(125, 184, 196);
}

.namhaeann {
	stroke: rgb(29, 158, 211);
}

.daegu {
	stroke: rgb(50, 64, 143);
}

.joobuinside {
	stroke: rgb(157, 107, 164);
}

.muann {
	stroke: rgb(96, 25, 134);
}

.dangzin {
	stroke: rgb(55, 29, 63);
}
#map {
	z-index: 0;
	position: fixed;
	top: 15px;
	left: 0px;
	margin-left:700px;
}
#explain{
	z-index: 0;
	position: fixed;
	top: 0px;
	left: 50px;
}
#road{
	z-index: 0;
	position: fixed;
	top: 0px;
	left: 1600px;
	
}

</style>

<link rel="stylesheet" type="text/css" href="d3.parcoords.css">
<script src="d3.min.js"></script>
<script src="sylvester.js"></script>
<script src="underscore.js"></script>
<script src="jquery-1.7.min.js"></script>
<script src="underscore.js"></script>
<script src="underscore.math.js"></script>
<script src="d3.parcoords.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body bgcolor="#000000">

	<!-- <script>
	 $("body").click(function(event){
		    var $x=event.screenX;
		    var $y=event.screenY;
		    alert("X좌표 : "+$x+":::::Y좌표 : " +$y);
		 });

	</script> -->

	<script src="http://d3js.org/d3.v3.min.js"></script>
	<script src="d3.parcoords.js"></script>

	<div id="map" style="position: fixed;">
		<img src="map2.png" width="503" height="665" />
	</div>
	<div id="road">
		<img src="reroad.jpg" width="250" height="630"/>
	</div> 
	<div id="explain">
		<img src="masterpiece.png" width="500" height="630"/>
	</div> 
	
	<div id="example-progressive" class="parcoords" style="width:2000px; height:300px;  margin-left: -700px; margin-top: 650px; margin-bottom: 10px; "></div>
	<script>
		var pc0;
		
		var svg = d3.select("body").append("svg").attr("width", "100%").attr(
				"height", "58%").style("position","fixed").style("top","0px").style("left","0px");
		var parcoords;//barom
		// load csv file and create the chart
		d3.csv('final.csv', function(data) {
			
			var colorgen = d3.scale.ordinal().range(
					[ "rgb(255, 255, 255)","rgb(237, 216, 166)" ,"rgb(242, 187, 153)","rgb(239, 176, 24)","rgb(107,80,35)"," rgb(156, 208, 163)","rgb(11, 147, 86)","rgb(48, 86, 44)","rgb(232, 152, 163)","rgb(228, 123, 106)","rgb(231, 53, 137)","rgb(231, 44, 40)","rgb(125, 184, 196)","rgb(29, 158, 211)","rgb(50, 64, 143)","rgb(157, 107, 164)","rgb(96, 25, 134)","rgb(55, 29, 63)"  ]);

			var color = function(d) {
				return colorgen(d.route);
			};

			 parcoords = d3.parcoords()("#example-progressive").data(data).bundlingStrength(0.2).smoothness(0.11).bundleDimension("route").showControlPoints(false)
					.hideAxis([ "location", "direction", "cause_L", "지점명", "car_standard" ,"pavment_condition","ambulance_arrive_time", "people_rescue_time", "towtruck_arrive_time","rescue_time"  ]).color(color).alpha(0.25).composite(
							"darker").margin({
						top : 24,
						left : 150,
						bottom : 12,
						right : 0
					}).mode("queue").render().brushMode("1D-axes").interactive(); // enable brushing
				
					// smoothness
					d3.select("#smoothness").on("change", function() {
						d3.select("#smooth").text(this.value);
						pc0.smoothness(this.value).render();
					});
					// bundling strength slider
					d3.select("#bundling").on("change", function() {
						d3.select("#strength").text(this.value);
						pc0.bundlingStrength(this.value).render();
					});
					var select = d3.select("#bundleDimension").append("select").on(
							"change", changeBundle);

					/* var options = select.selectAll('option').data(
							pc0.dimensions().concat(pc0.hideAxis()));

					options.enter().append("option").attr("value", function(d) {
						return d;
					}).text(function(d) {
						return d;
					});
*/
				///////외곽 순환 고속도로 circle찍기
					var outer_circles = svg.selectAll("outer_circles").data(data.slice(0, 809)).enter()
					.append("circle");
					var pi =Math.PI;
					var x;
					var y;
					var r=23;
					var beta;
					outer_circles.attr(
					"cx",
					function(d, i) {
						beta=2*pi*(d.distance/128);
						x=r*(Math.cos(beta));
						//x=x.toPrecision(1);
						//console.log("x value is-> "+d.distance);
						return parseInt(869+x*1.15);
					}).attr(
					"cy",
					function(d, i) {
						beta=2*pi*(d.distance/128);
						y=r*(Math.sin(beta));
						//y=y.toPrecision(1);
						return parseInt(174+y*1.15);
					}).attr("r", 3).attr("fill","white").attr("fill-opacity","0.4");
						
					
				///////경인2고속도로 찍기	하행
					var kengin_circle2 = svg.selectAll("kengin_circle2").data(data.slice(810,860))
					.enter().append("circle");
					kengin_circle2.attr(
					"cx",
					function(d, i) {

						return 849-(+d.distance);
					}).attr(
					"cy",
					function(d, i) {

						return 186;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");

			
			 ////////경인2 상행
		var kengin_circle2_up = svg.selectAll("kengin_circle2_up").data(data.slice(861,914))
					.enter().append("circle");
					kengin_circle2_up.attr(
					"cx",
					function(d, i) {

						return 822+(+d.distance);
					}).attr(
					"cy",
					function(d, i) {

						return 195;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
					
			/// 고창담양 하행
			var go_dam_circle_down = svg.selectAll("go_dam_circle_down").data(data.slice(915,933))
					.enter().append("circle");
			go_dam_circle_down.attr(
					"cx",
					function(d, i) {

						return 897-(+d.distance*63/38.8);
					}).attr(
					"cy",
					function(d, i) {

						return 462;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			//// 고창 담양 상행
			var go_dam_circle_up = svg.selectAll("go_dam_circle_up").data(data.slice(934,941))
					.enter().append("circle");
					go_dam_circle_up.attr(
					"cx",
					function(d, i) {

						return 834+(+d.distance*63/38);
					}).attr(
					"cy",
					function(d, i) {

						return 470;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
					
				///경부 하행 1
				var kengbu_circle_down1 = svg.selectAll("kengbu_circle_down1").data(data.slice(942,2000))
					.enter().append("circle");
				kengbu_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=121 ? 864 : null;
					}).attr(
					"cy",
					function(d, i) {

						return parseFloat(d.distance)<=121 ? 200+(parseFloat(d.distance)*137/121) : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			///경부 하행2
			var kengbu_circle_down2 = svg.selectAll("kengbu_circle_down2").data(data.slice(942,2000))
					.enter().append("circle");
			kengbu_circle_down2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>121)&&(parseFloat(d.distance)<=364)) ? 740+(parseFloat(d.distance)*(273/243)*Math.cos(Math.PI/8)) : null;
					}).attr(
					"cy",
					function(d, i) {

						return ((parseFloat(d.distance)>121)&&(parseFloat(d.distance)<=364)) ? 290+(parseFloat(d.distance)*(273/243)*Math.sin(Math.PI/8)) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			//경부하행3
			var kengbu_circle_down3 = svg.selectAll("kengbu_circle_down3").data(data.slice(942,2000))
					.enter().append("circle");
			kengbu_circle_down3.attr(
					"cx",
					function(d, i) {
						//console.log((parseFloat(d.distance)>364));
						return (parseFloat(d.distance)>364) ? 1116 : null;
						
					}).attr(
					"cy",
					function(d, i) {
						//console.log(parseFloat(d.distance)>364 ? (504+(parseFloat(d.distance)*58/52)) : null);
						return (parseFloat(d.distance)>364) ? (39+(parseFloat(d.distance)*(58/52))) : null;
					
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			/////경부 상행
			
			var kengbu_circle_up1 = svg.selectAll("kengbu_circle_up1").data(data.slice(2001,3139))
					.enter().append("circle");
				kengbu_circle_up1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)>341 ? 875 : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)>341 ? 920-(parseFloat(d.distance)*129/75) : null;
						
						}
						
					).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			///경부 상행2
			var kengbu_circle_up2 = svg.selectAll("kengbu_circle_up2").data(data.slice(2001,3139))
					.enter().append("circle");
			kengbu_circle_up2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>60)&&(parseFloat(d.distance)<=341)) ? 1185+(parseFloat(d.distance)*(270/273)*Math.cos(9*Math.PI/8)) : null;
					}).attr(
					"cy",
					function(d, i) {

						return ((parseFloat(d.distance)>60)&&(parseFloat(d.distance)<=341)) ? 461+(parseFloat(d.distance)*(270/273)*Math.sin(9*Math.PI/8)) : null;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			//경부상행3
			var kengbu_circle_up3 = svg.selectAll("kengbu_circle_up3").data(data.slice(2001,3139))
					.enter().append("circle");
			kengbu_circle_up3.attr(
					"cx",
					function(d, i) {
						//console.log((parseFloat(d.distance)>364));
						return (parseFloat(d.distance)<=60) ? 1130 : null;
						
					}).attr(
					"cy",
					function(d, i) {
						//console.log(parseFloat(d.distance)>364 ? (504+(parseFloat(d.distance)*58/52)) : null);
						return (parseFloat(d.distance)<=60) ? (508-(parseFloat(d.distance)*(68/60))) : null;
					
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			////영동 상행
			
			var engdong_circle_up1 = svg.selectAll("engdong_circle_up1").data(data.slice(3339,3776))
					.enter().append("circle");
				engdong_circle_up1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=104 ? 826+parseFloat(d.distance)*125/104 : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)<=104 ? 216 : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			///영부 상행2
			var engdong_circle_up2 = svg.selectAll("engdong_circle_up2").data(data.slice(3339,3776))
					.enter().append("circle");
			engdong_circle_up2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>104) ? 837+(parseFloat(d.distance)*(152/127)*Math.cos(-1*Math.PI/8)) : null );
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)>104) ? 265+(parseFloat(d.distance)*(152/127)*Math.sin(-1*Math.PI/8)) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			
			///영동 하행1
			var engdong_circle_down1 = svg.selectAll("engdong_circle_down1").data(data.slice(3777,4264))
					.enter().append("circle");
				engdong_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=105 ? 1092-parseFloat(d.distance)*(210/150)*Math.cos(Math.PI/8) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)<=105 ? 149+(parseFloat(d.distance)*(210/150)*Math.sin(Math.PI/8)) : null;
						
						}
						
					).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			///영동 하행2
			var engdong_circle_down2 = svg.selectAll("engdong_circle_down2").data(data.slice(3777,4264))
					.enter().append("circle");
			engdong_circle_down2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>105) ? 1055-(parseFloat(d.distance)*(126/125)) : null );
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)>105) ? 205 : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			//중앙 하행
			var jungang_circle_down1 = svg.selectAll("jungang_circle_down1").data(data.slice(4265,4516))
					.enter().append("circle");
			jungang_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return  1083+parseFloat(d.distance)*(304/385)*Math.cos(Math.PI+Math.PI/2.8) ;
					}).attr(
					"cy",
					function(d, i) {
						
						return 430+(parseFloat(d.distance)*(304/385)*Math.sin(Math.PI+Math.PI/2.8)) ;
						
						}
						
					).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			///중앙 상행
			var jungang_circle_up1 = svg.selectAll("jungang_circle_up1").data(data.slice(4517,4763))
					.enter().append("circle");
			jungang_circle_up1.attr(
					"cx",
					function(d, i) {
						
						return 936+(parseFloat(d.distance)*(304/385)*Math.cos(Math.PI/2.8)) ;
					}).attr(
					"cy",
					function(d, i) {

						return 161+(parseFloat(d.distance)*(304/385)*Math.sin(Math.PI/2.8));
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			///88 상행
			var palpal_circle_up1 = svg.selectAll("palpal_circle_up1").data(data.slice(3140,3252))
					.enter().append("circle");
			palpal_circle_up1.attr(
					"cx",
					function(d, i) {
						
						return 1083-parseFloat(d.distance)*(220/182)*Math.cos(-18*Math.PI/9.5) ;
					}).attr(
					"cy",
					function(d, i) {

						return 403+(parseFloat(d.distance)*(220/182)*Math.sin(-18*Math.PI/9.5));
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			//88하행
			
				var palpal_circle_down1 = svg.selectAll("palpal_circle_down1").data(data.slice(3253,3338))
					.enter().append("circle");
				palpal_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return  880+parseFloat(d.distance)*(220/183)*Math.cos(Math.PI/9.5) ;
					}).attr(
					"cy",
					function(d, i) {
						
						return 485-(parseFloat(d.distance)*(220/183)*Math.sin(Math.PI/9.5)) ;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
				
				//평택제천 상행 
				var pengje_circle_up1 = svg.selectAll("pengje_circle_up1").data(data.slice(4771,4773))
					.enter().append("circle");
				pengje_circle_up1.attr(
					"cx",
					function(d, i) {
						
						return 905- parseFloat(d.distance)*(71/26);
					}).attr(
					"cy",
					function(d, i) {

						return 248;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			//평택제천하행
			
				var pengje_circle_down1 = svg.selectAll("palpal_circle_down1").data(data.slice(4764,4770))
					.enter().append("circle");
				pengje_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return  834+parseFloat(d.distance)*(52/26) ;
					}).attr(
					"cy",
					function(d, i) {
						
						return 262 ;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
				
				
				
				//경인 고속도로 상행
				var kenginn_circle_up1 = svg.selectAll("kenginn_circle_up1").data(data.slice(4774,4825))
					.enter().append("circle");
				kenginn_circle_up1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=7.1 ? 836 : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)<=7.1 ? 180-parseFloat(d.distance)*(14/7) : null;
						
						}
						
					).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			///경인 상행2
			var kenginn_circle_up2 = svg.selectAll("kenginn_circle_up2").data(data.slice(4774,4825))
					.enter().append("circle");
			kenginn_circle_up2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>7.1) ? 836+(parseFloat(d.distance)*(31/17)) : null );
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)>7.1) ? 166 : null;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			
			///경인 하행1
			var kenginn_circle_down1 = svg.selectAll("kenginn_circle_down1").data(data.slice(4826,4884))
					.enter().append("circle");
			kenginn_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=15.6 ? 868-parseFloat(d.distance)*(43/15.6) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)<=15.6 ? 155 : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			///경인 하행2
			var kenginn_circle_down2 = svg.selectAll("kenginn_circle_down2").data(data.slice(4826,4884))
					.enter().append("circle");
			kenginn_circle_down2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>15.6) ? 825 : null );
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)>15.6) ? 107+(parseFloat(d.distance)*(23/7.4)) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			
			
			//////중부고속도로하행1
				var jungbu_circle_down1 = svg.selectAll("jungbu_circle_down1").data(data.slice(4885,5240))
					.enter().append("circle");
					jungbu_circle_down1.attr(
					"cx",
					function(d, i) {

						return (parseFloat(d.distance)<=166.2) ? 892 : null;
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)<=166.2) ? 205+parseFloat(d.distance)*(174/166.2) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
					
		    ///////중부고속도로 하행2
		    var jungbu_circle_down2 = svg.selectAll("jungbu_circle_down2").data(data.slice(4885,5240))
					.enter().append("circle");
		    	jungbu_circle_down2.attr(
					"cx",
					function(d, i) {

						return (parseFloat(d.distance)>166.2) ? 770+parseFloat(d.distance)*Math.cos(Math.PI/4)*207/198 : null;
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)>166.2) ? 260+(parseFloat(d.distance)*Math.sin(Math.PI/4)*207/198) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
		    		
		    		
		    /////중부고속도로 상행1
		     var jungbu_circle_up1 = svg.selectAll("jungbu_circle_up1").data(data.slice(5241,5591))
					.enter().append("circle");
		    		 jungbu_circle_up1.attr(
					"cx",
					function(d, i) {

						return (parseFloat(d.distance)<=198) ? 1049-(parseFloat(d.distance)*Math.cos(Math.PI/4)*207/198) : null;
					}).attr(
					"cy",
					function(d, i) {

						return (parseFloat(d.distance)<=198) ? 521-(parseFloat(d.distance)*Math.sin(Math.PI/3.8)*207/198) : null;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
		    		 
		    		   /////중부고속도로 상행2
			 var jungbu_circle_up2 = svg.selectAll("jungbu_circle_up2").data(data.slice(5241,5591))
							.enter().append("circle");
							 jungbu_circle_up2.attr(
							"cx",
							function(d, i) {

								return (parseFloat(d.distance)>198) ? 904 : null;
							}).attr(
							"cy",
							function(d, i) {

								return (parseFloat(d.distance)>198) ? 570-(parseFloat(d.distance)*168/166) : null;
								
							}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
							 
			//동해 고속도로
			
			//동해 상행 
				var donghae_circle_up1 = svg.selectAll("donghae_circle_up1").data(data.slice(5618,5648))
					.enter().append("circle");
				donghae_circle_up1.attr(
					"cx",
					function(d, i) {
						
						return 1105- parseFloat(d.distance)*(78.5/60)*Math.cos(Math.PI/3.1);
					}).attr(
					"cy",
					function(d, i) {

						return 185-parseFloat(d.distance)*(78.5/60)*Math.sin(Math.PI/3.1);
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			//동해하행
			
				var donghae_circle_down1 = svg.selectAll("donghae_circle_down1").data(data.slice(5592,5617))
					.enter().append("circle");
				donghae_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return  1050+parseFloat(d.distance)*(78.5/60)*Math.cos(Math.PI/3.1);
					}).attr(
					"cy",
					function(d, i) {
						
						return 122+parseFloat(d.distance)*(78.5/60)*Math.sin(Math.PI/3.1);
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
				
				//호남 하행
				var honam_circle_down1 = svg.selectAll("honam_circle_down1").data(data.slice(6184,6591))
					.enter().append("circle");
				honam_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return  (parseFloat(d.distance)<=45.4) ? 916+(parseFloat(d.distance)*(69/45.4)*Math.cos(Math.PI-(Math.PI/5))) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return (parseFloat(d.distance)<=45.4) ? 332+(parseFloat(d.distance)*(69/45.4)*Math.sin(Math.PI-(Math.PI/5))) : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");

				var honam_circle_down2 = svg.selectAll("honam_circle_down2").data(data.slice(6184,6591))
					.enter().append("circle");
				honam_circle_down2.attr(
					"cx",
					
					function(d, i) {
						
						return  (parseFloat(d.distance)>45.4)&&(parseFloat(d.distance)<=136.3) ? 861 : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return (parseFloat(d.distance)>45.4)&&(parseFloat(d.distance)<=136.3) ? 305+(parseFloat(d.distance)*(138/91)) : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");

				var honam_circle_down3 = svg.selectAll("honam_circle_down3").data(data.slice(6184,6591))
					.enter().append("circle");
				honam_circle_down3.attr(
					"cx",
					
					function(d, i) {
						
						return  (parseFloat(d.distance)>=136.3) ? 654+(parseFloat(d.distance)*(86/57)) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return (parseFloat(d.distance)>=136.3) ? 512 : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
				
				//호남상행
				var honam_circle_up1 = svg.selectAll("honam_circle_up1").data(data.slice(5649,6183))
				.enter().append("circle");
				honam_circle_up1.attr(
				"cx",
				
				function(d, i) {
					
					return  (parseFloat(d.distance)<=57.8) ? 947-(parseFloat(d.distance)*(75/57.8)) : null;
				}).attr(
				"cy",
				function(d, i) {
					
					return (parseFloat(d.distance)<=57.8) ? 498 : null;
					
					}
					
				).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
				
				var honam_circle_up2 = svg.selectAll("honam_circle_up2").data(data.slice(5649,6183))
				.enter().append("circle");
				honam_circle_up2.attr(
				"cx",
				
				function(d, i) {
					
					return  (parseFloat(d.distance)>57.8)&&(parseFloat(d.distance)<=151.8) ? 872 : null;
				}).attr(
				"cy",
				function(d, i) {
					
					return (parseFloat(d.distance)>57.8)&&(parseFloat(d.distance)<=151.8) ? 572-(parseFloat(d.distance)*(122/94)) : null;
					
					}
					
				).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
				
				var honam_circle_up3 = svg.selectAll("honam_circle_up3").data(data.slice(5649,6183))
				.enter().append("circle");
				honam_circle_up3.attr(
				"cx",
				
				function(d, i) {
					
					return  (parseFloat(d.distance)>151.8) ? 710+(parseFloat(d.distance)*(56/43.2)* Math.cos(-Math.PI/5)) : null;
				}).attr(
				"cy",
				function(d, i) {        
					
					return (parseFloat(d.distance)>151.8) ? 495+(parseFloat(d.distance)*(56/43.2)* Math.sin(-Math.PI/5)) : null;
					
					}
					
				).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
		//서해 상행		
				var seahae_circle_up1 = svg.selectAll("seahae_circle_up1").data(data.slice(7129,7730))
				.enter().append("circle");
				seahae_circle_up1.attr(
				"cx",
				function(d, i) {
					
					return 848;
				}).attr(
				"cy",
				function(d, i) {

					return 530- parseFloat(d.distance)*(328/338);
					
				}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
		
		//서해 하행
		
			var seahae_circle_down1 = svg.selectAll("seahae_circle_down1").data(data.slice(6592,7128))
				.enter().append("circle");
			seahae_circle_down1.attr(
				"cx",
				
				function(d, i) {
					
					return  836;
				}).attr(
				"cy",
				function(d, i) {
					
					return 202+ parseFloat(d.distance)*(328/340);
					
					}
					
				).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			//남해안 상행
			var namhae_circle_up1 = svg.selectAll("namhae_circle_up1").data(data.slice(8318,8778))
				.enter().append("circle");
				namhae_circle_up1.attr(
				"cx",
				function(d, i) {
					
					return (parseFloat(d.distance)<=95.5) ? 1114-(parseFloat(d.distance)*(107/95.5)) : null;
				}).attr(
				"cy",
				function(d, i) {

					return (parseFloat(d.distance)<=95.5) ? 470 : null;
					
				}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			var namhae_circle_up2 = svg.selectAll("namhae_circle_up2").data(data.slice(8318,8778))
				.enter().append("circle");
				namhae_circle_up2.attr(
				"cx",
				function(d, i) {
					
					return (parseFloat(d.distance)<=120.5)&&(parseFloat(d.distance)>95.5) ? 1005 : null;
				}).attr(
				"cy",
				function(d, i) {

					return (parseFloat(d.distance)<=120.5)&&(parseFloat(d.distance)>95.5) ? 355+(parseFloat(d.distance)*(30/25)) : null;
					
				}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			var namhae_circle_up3 = svg.selectAll("namhae_circle_up3").data(data.slice(8318,8778))
				.enter().append("circle");
				namhae_circle_up3.attr(
				"cx",
				function(d, i) {
					
					return (parseFloat(d.distance)>120.5) ? 1139-(parseFloat(d.distance)*(52/46.5)) : null;
				}).attr(
				"cy",
				function(d, i) {

					return (parseFloat(d.distance)>120.5) ? 497 : null;
					
				}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
				
			//남헤안 하행
			var namhae_circle_down1 = svg.selectAll("namhae_circle_down1").data(data.slice(7731,8317))
				.enter().append("circle");
			namhae_circle_down1.attr(
				"cx",
				
				function(d, i) {
					
					return  (parseFloat(d.distance)<60) ? 955+(parseFloat(d.distance)*(67/60)) : null;
				}).attr(
				"cy",
				function(d, i) {
					
					return (parseFloat(d.distance)<60) ? 512 : null;
					
					}
					
				).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			var namhae_circle_down2 = svg.selectAll("namhae_circle_down2").data(data.slice(7731,8317))
					.enter().append("circle");
					namhae_circle_down2.attr(
						"cx",
					
					function(d, i) {
						
						return  (parseFloat(d.distance)>=60)&&(parseFloat(d.distance)<=95.6) ? 1022 : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return (parseFloat(d.distance)>=60)&&(parseFloat(d.distance)<=95.6) ? 562-((parseFloat(d.distance)*30/35.6)) : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
				
				var namhae_circle_down3 = svg.selectAll("namhae_circle_down3").data(data.slice(7731,8317))
					.enter().append("circle");
					namhae_circle_down3.attr(
					"cx",
					
					function(d, i) {
						
						return (parseFloat(d.distance)>95.6) ? 900+parseFloat(d.distance)*(92/73.4) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return (parseFloat(d.distance)>95.6) ? 482 : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
					
			
			//대구-포항 고속도로 상행
				var deapo_circle_up1 = svg.selectAll("deapo_circle_up1").data(data.slice(8779,8803))
				.enter().append("circle");
				deapo_circle_up1.attr(
				"cx",
				function(d, i) {
					
					return 1127-parseFloat(d.distance)*88/64.5;
				}).attr(
				"cy",
				function(d, i) {

					return 412;
					
				}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
		
			//대구-포항 고속도로 하행
		
			var deapo_circle_down1 = svg.selectAll("deapo_circle_down1").data(data.slice(8804,8828))
				.enter().append("circle");
			deapo_circle_down1.attr(
				"cx",
				
				function(d, i) {
					
					return  1040+parseFloat(d.distance)*88/67.3;
				}).attr(
				"cy",
				function(d, i) {
					
					return 424;
					
					}
					
				).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
		//중부내륙 고속도로 상행
			var jungnae_circle_up1 = svg.selectAll("jungnae_circle_up1").data(data.slice(9158,9517))
			.enter().append("circle");
			jungnae_circle_up1.attr(
			"cx",
			function(d, i) {
				
				return 1077	+parseFloat(d.distance)*(344/266)*Math.cos(Math.PI+Math.PI/2.75);
			}).attr(
			"cy",
			function(d, i) {

				return 516+parseFloat(d.distance)*(344/266)*Math.sin(Math.PI+Math.PI/2.75);
				
			}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
	
		//중부내륙 고속도로 하행
	
		var jungnae_circle_down1 = svg.selectAll("jungnae_circle_down1").data(data.slice(8829,9157))
			.enter().append("circle");
		jungnae_circle_down1.attr(
			"cx",
			
			function(d, i) {
				
				return  920+parseFloat(d.distance)*(344/266)*Math.cos(Math.PI/2.75);
			}).attr(
			"cy",
			function(d, i) {
				
				return 202+parseFloat(d.distance)*344/266*Math.sin(Math.PI/2.75);
				
				}
				
			).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
		
		
		///당진상주하행1
		
			var dangjin_circle_down1 = svg.selectAll("dangjin_circle_down1").data(data.slice(9546,9564))
					.enter().append("circle");
			dangjin_circle_down1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=21.2 ? 837+parseFloat(d.distance)*69/21.2 : null;
					}).attr(
					"cy",
					function(d, i) {

						return parseFloat(d.distance)<=21.2 ? 350 : null;
						
						}
						
					).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			///당진상주 하행2
			var dangjin_circle_down2 = svg.selectAll("dangjin_circle_down2").data(data.slice(9546,9564))
					.enter().append("circle");
			dangjin_circle_down2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>21.2)&&(parseFloat(d.distance)<=28)) ? 902 : null;
					}).attr(
					"cy",
					function(d, i) {

						return ((parseFloat(d.distance)>21.2)&&(parseFloat(d.distance)<=28)) ? 422-(parseFloat(d.distance)*(22/6.8)) : null;
						
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			//당진상주하행3
			var dangjin_circle_down3 = svg.selectAll("dangjin_circle_down3").data(data.slice(9546,9564))
					.enter().append("circle");
			dangjin_circle_down3.attr(
					"cx",
					function(d, i) {
						//console.log((parseFloat(d.distance)>364));
						return (parseFloat(d.distance)>28) ? 802+parseFloat(d.distance)*(123/38)*Math.cos(Math.PI/12) : null;
						
					}).attr(
					"cy",
					function(d, i) {
						//console.log(parseFloat(d.distance)>364 ? (504+(parseFloat(d.distance)*58/52)) : null);
						return (parseFloat(d.distance)>28) ? 305+parseFloat(d.distance)*(123/38)*Math.sin(Math.PI/12) : null;
					
					}).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
			
			/////당진상주 상행
			
			var dangjin_circle_up1 = svg.selectAll("dangjin_circle_up1").data(data.slice(9530,9546))
					.enter().append("circle");
			dangjin_circle_up1.attr(
					"cx",
					
					function(d, i) {
						
						return parseFloat(d.distance)<=49.2 ? 1021+parseFloat(d.distance)*(130/49.2)*Math.cos(Math.PI+Math.PI/11.9) : null;
					}).attr(
					"cy",
					function(d, i) {
						
						return parseFloat(d.distance)<=49.2 ? 350+parseFloat(d.distance)*(130/49.2)*Math.sin(Math.PI+Math.PI/11.9) : null;
						
						}
						
					).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			///당진상주 상행2
			var dangjin_circle_up2 = svg.selectAll("dangjin_circle_up2").data(data.slice(9530,9546))
					.enter().append("circle");
			dangjin_circle_up2.attr(
					"cx",
					function(d, i) {
						
						return ((parseFloat(d.distance)>49.2)&&(parseFloat(d.distance)<=56.8)) ? 894 : null;
					}).attr(
					"cy",
					function(d, i) {

						return ((parseFloat(d.distance)>49.2)&&(parseFloat(d.distance)<=56.8)) ? 297+(parseFloat(d.distance)*(20/35.6)) : null;
						
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			//당진상주상행3
			var dangjin_circle_up3 = svg.selectAll("dangjin_circle_up3").data(data.slice(9530,9546))
					.enter().append("circle");
			dangjin_circle_up3.attr(
					"cx",
					function(d, i) {
						//console.log((parseFloat(d.distance)>364));
						return (parseFloat(d.distance)>56.8) ? 1050-parseFloat(d.distance)*(61/23.2) : null;
						
					}).attr(
					"cy",
					function(d, i) {
						//console.log(parseFloat(d.distance)>364 ? (504+(parseFloat(d.distance)*58/52)) : null);
						return (parseFloat(d.distance)>56.8) ? 340 : null;
					
					}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
			
			///무안광주 상행
			var muan_circle_up1 = svg.selectAll("muan_circle_up1").data(data.slice(9518,9527))
			.enter().append("circle");
			muan_circle_up1.attr(
			"cx",
			function(d, i) {
				
				return 897-parseFloat(d.distance)*(71/41);
			}).attr(
			"cy",
			function(d, i) {

				return 475;
				
			}).attr("r", 3).attr("fill", "white").attr("fill-opacity","0.4");
	
		//무안광주 고속도로 하행
	
		var muan_circle_down1 = svg.selectAll("muan_circle_down1").data(data.slice(9527,9529))
			.enter().append("circle");
		muan_circle_down1.attr(
			"cx",
			
			function(d, i) {
				console.log(d.distance);
				return  i*5+815+parseFloat(d.distance)*(71/41);
			}).attr(
			"cy",
			function(d, i) {
				
				return 485;
				
				}
				
			).attr("r", 3).attr("fill", "red").attr("fill-opacity","0.4");
		
		  
								
			//circle bind graph hover
          var click_idex = [] ;
					outer_circles.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
							
						},
						"dblclick" : parcoords.unhighlight
					});
					kengin_circle2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengin_circle2_up.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					go_dam_circle_down.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					go_dam_circle_up.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengbu_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengbu_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengbu_circle_down3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					kengbu_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengbu_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kengbu_circle_up3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					engdong_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					engdong_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					engdong_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					engdong_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					jungang_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungang_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					palpal_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					palpal_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					pengje_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					pengje_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					kenginn_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kenginn_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kenginn_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					kenginn_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					
					jungbu_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungbu_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungbu_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungbu_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					donghae_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					donghae_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_up3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					honam_circle_down3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					seahae_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					seahae_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					namhae_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					namhae_circle_up3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					namhae_circle_up3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					namhae_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					namhae_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					namhae_circle_down3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					deapo_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					deapo_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungnae_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					jungnae_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_down2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_down3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_up2.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					dangjin_circle_up3.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					
					muan_circle_up1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					muan_circle_down1.on({
						"click" : function(d) {
							parcoords.highlight([ d ])
						},
						"dblclick" : parcoords.unhighlight
					});
					

					
					parcoords.on("brush", function(d) {

					    var keys = Object.keys(d);
					   var verus;
					   
					   outer_circles.style("visibility", function(cd) {
					      
					        for(var i=0; i<keys.length;i++){
					             
					             if(cd==d[i]){
					                verus=d[i];
					                
					                break;
					             }
					          }
					          return cd == verus ? "visible" : "hidden";
					          });
					         
					   kengin_circle2.style("visibility", function(cd) {
					        for(var i=0; i<keys.length;i++){
					             
					             if(cd==d[i]){
					                verus=d[i];
					                
					                break;
					             }
					          }
					       return cd == verus ? "visible" : "hidden";
					          });
					         
					     
					
					kengin_circle2_up.style("visibility", function(cd) {
					        for(var i=0; i<keys.length;i++){
					             
					             if(cd==d[i]){
					                verus=d[i];
					                
					                break;
					             }
					          }
					       return cd == verus ? "visible" : "hidden";
					          });
					go_dam_circle_down.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					go_dam_circle_up.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kengbu_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kengbu_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kengbu_circle_down3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					kengbu_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kengbu_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kengbu_circle_up3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					engdong_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					engdong_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					engdong_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					engdong_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					jungang_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					jungang_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					palpal_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					palpal_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					pengje_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					pengje_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					kenginn_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kenginn_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					kenginn_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					kenginn_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					         
					         
					 
					jungbu_circle_down1.style("visibility", function(cd) {
					        for(var i=0; i<keys.length;i++){
					             
					             if(cd==d[i]){
					                verus=d[i];
					                
					                break;
					             }
					          }
					       return cd == verus ? "visible" : "hidden";
					          });
					
					jungbu_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					jungbu_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					jungbu_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					donghae_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					donghae_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					honam_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					honam_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					honam_circle_down3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					honam_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					honam_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					honam_circle_up3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					seahae_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					seahae_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					namhae_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					namhae_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					namhae_circle_up3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					namhae_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
				       
					namhae_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
							    });
				      
		
					namhae_circle_down3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					deapo_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					deapo_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					jungnae_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					jungnae_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_down2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_down3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_up2.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					dangjin_circle_up3.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					muan_circle_down1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					muan_circle_up1.style("visibility", function(cd) {
				        for(var i=0; i<keys.length;i++){
				             
				             if(cd==d[i]){
				                verus=d[i];
				                
				                break;
				             }
				          }
				       return cd == verus ? "visible" : "hidden";
				          });
					
					
				 
					
					
					
					
				
					
					
					
					
					
					     });
					function changeBundle() {
						pc0.bundleDimension(this.value);
					}
			parcoords.reorderable();
			parcoords.svg.selectAll("text").style("font", "10px sans-serif");
			parcoords.svg.selectAll("text").style("fill", '#ffffff');
			// svg.select("#click_btn").on("click",brushUpdated(parcoords.data()[0]));
				
		});
		function click_btn(){
		//	parcoords.data(function(d,i){console.log(d.distance)});
		//	console.log(parcoords.data()[0]["route"]);
			
		//	console.log(parcoords.data().length);
	//	var option_select = "서울외곽순환";
	//	var temp_length = parcoords.data().length;
	//	for(var i=0;i<temp_length;i++){
			
			//console.log(parcoords.data()[i])
		//	if(option_select==parcoords.data()[i]["route"]){
				
				
		//	}
		//}
			//var ttt = parcoords.data()[0];
		//	console.log("d3.parcoords의 무슨함수?-> "+parcoords.brushUpdated());
			
			//parcoords.events.brush.call(pc,ttt);
		//	parcoords.pc.render();
			//parcoords.data()[0].events.brush.call(pc,__.brushed);   brushUpdated(ttt)
		}
		
	</script>
	<button  id="click_btn">click</button>
</body>
</html>