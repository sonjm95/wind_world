<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>wind-world</title>
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
   <script src="https://cdn.ckeditor.com/4.14.0/full/ckeditor.js"></script>

</head>

<body>




<div class="container">
   <%@ include file="./00.bs4_header.jsp" %>

   <!-- section start -->
   <section id="index_section">
            <div class="card col-sm-12 mt-1" style="min-height: 850px;">
               <div class="card-body">

<!-- here start -->
<script src="https://unpkg.com/@google/markerclustererplus@4.0.1/dist/markerclustererplus.min.js"></script>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDNoroJ6kO4Nbkjc2gSL8fEJ1nqSZZtmGQ&callback=initMap"></script>
<script>
let colorArr = ['table-primary','table-success','table-danger'];


$(document).ready(function(){
   //시도 삽입
   $.get("${pageContext.request.contextPath}/select/sido",function(data, status) {
         $.each(data, function(index, vo) {
            $("#sido").append("<option value='"+vo.sido_code+"'>"+ vo.sido_name + "</option>");
         });//each
      }//function
      , "json"
   );//get  

   //시도 선택    
   $("#sido").change(function() {
      $.get("${pageContext.request.contextPath}/select/gugun"
            ,{sido:$("#sido").val()}
            ,function(data, status){               
               $("#gugun").empty();
               $("#gugun").append('<option value="0">선택</option>');
               $.each(data, function(index, vo) {
                  $("#gugun").append("<option value='"+vo.gugun_code+"'>"+vo.gugun_name+"</option>");
               });//each
            }//function
            , "json"
      );//get
   });//change 

   //군선택
   $("#gugun").change(function() {
      $.get("${pageContext.request.contextPath}/select/dong"
            ,{gugun:$("#gugun").val()}
            ,function(data, status){
               $("#dong").empty();
               $("#dong").append('<option value="0">선택</option>');
               $.each(data, function(index, vo) {
                  $("#dong").append("<option value='"+vo.dong+"'>"+vo.dong+"</option>");
               });//each
            }//function
            , "json"
      );//get
   });//change

   //동선택(apt정보 표시)
   $("#dong").change(function() {
      $.get("${pageContext.request.contextPath}/select/apt"
            ,{ dong:$("#dong").val()}
            ,function(data, status){
               $("tbody").empty();
               $.each(data, function(index, vo) {   
                  let str = "<tr>"
                  + "<td>" + vo.no + "</td>"
                  + "<td>" + vo.dong + "</td>"
                  + "<td>" + vo.aptName + "</td>"
                  + "<td>" + vo.jibun + "</td>"
                  + "<td>" + vo.code + "</td>"
                  + "<td id='lat_"+index+"'></td>"
                  + "<td id='lng_"+index+"'></td></tr>";
                  $("tbody").append(str);                  
               });//each
               geocode(data);
            }//function
            , "json"
      );//get
   });//change   
   
   //동선택(element정보 표시)
   $("#dong").change(function() {
      $.get("${pageContext.request.contextPath}/element/dong"
            ,{ dong:$("#dong").val(), gugun:$("#gugun").val()}
            ,function(data, status){
               elementGeocode(data);
            }//function
            , "json"
      );//get
   });//change   
   
   
   $("#elementInfoBtn").click(function() {
      $("#elementInfo").hide();
   });
});//ready 
 
    //element표시
   function elementGeocode(jsonData) {
      let idx = 0;
      $.each(jsonData, function(index, vo) {
         let tmpLat;
         let tmpLng;
         $.get("https://maps.googleapis.com/maps/api/geocode/json", {
            key : 'AIzaSyDNoroJ6kO4Nbkjc2gSL8fEJ1nqSZZtmGQ',
            address : vo.jibun
         }, function(data, status) {
            tmpLat = data.results[0].geometry.location.lat;
            tmpLng = data.results[0].geometry.location.lng;   
            if(vo.isAccident == 'true'){
               addMarkerElementRed(tmpLat, tmpLng, vo.elementName, vo.jibun, vo.road, vo.buildForm, vo.occrrnc_cnt, vo.dth_dnv_cnt, vo.se_dnv_cnt, vo.sl_dnv_cnt);
            }
            else{
               addMarkerElement(tmpLat, tmpLng, vo.elementName, vo.jibun, vo.road, vo.buildForm);
            }
         }, "json");//get
      });//each
//      clearMarkers();
   }

   //apt표시
   function geocode(jsonData) {
      let idx = 0;
      //clearMarkers();
      $.each(jsonData, function(index, vo) {
         let tmpLat;
         let tmpLng;
         $.get("https://maps.googleapis.com/maps/api/geocode/json", {
            key : 'AIzaSyDNoroJ6kO4Nbkjc2gSL8fEJ1nqSZZtmGQ',
            address : vo.dong + "+" + vo.aptName + "+" + vo.jibun
         }, function(data, status) {
            tmpLat = data.results[0].geometry.location.lat;
            tmpLng = data.results[0].geometry.location.lng;
            $("#lat_" + index).text(tmpLat);
            $("#lng_" + index).text(tmpLng);
            addMarker(tmpLat, tmpLng, vo.aptName);
         }, "json");//get
      });//each
      clearMarkers();
   } 
   
</script>

   시도 : <select id="sido">
   <option value="0">선택</option>
   </select>
   구군 : <select id="gugun">
      <option value="0">선택</option>
   </select>
   읍면동 : <select id="dong">
      <option value="0">선택</option>
   </select>
<!-- here end -->

<!-- map start -->
<div id="map" style="width: 100%; height: 500px; margin: auto;"></div>
<script src="https://unpkg.com/@google/markerclustererplus@4.0.1/dist/markerclustererplus.min.js"></script>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDNoroJ6kO4Nbkjc2gSL8fEJ1nqSZZtmGQ&callback=initMap"></script>
<script>
   var multi = {lat: 37.5665734, lng: 126.978179};
   var map;
   var markers = [];
   
   //맵 생성
   function initMap() {
      map = new google.maps.Map(document.getElementById('map'), {
         center: multi, zoom: 12
      });
      var marker = new google.maps.Marker({position: multi, map: map});
   }
   
   //map의 모든 마커 제거
   function clearMarkers() {
        setMapOnAll(null);
    }
   
   function setMapOnAll(map){
      for (var i = 0; i < markers.length; i++) {
             markers[i].setMap(map);
       }
   }   
   function addMarker(tmpLat, tmpLng, name) {
      var myIcon = 'https://cdn.pixabay.com/photo/2013/07/12/12/56/home-146585_1280.png';
      var marker = new google.maps.Marker({
         position: new google.maps.LatLng(parseFloat(tmpLat),parseFloat(tmpLng)),
         label: name,
         title: name,
         icon: {            
             url : myIcon,
             scaledSize: new google.maps.Size(20, 20)
         },
      });
      marker.addListener('click', function() {
         
         map.setZoom(17);
         map.setCenter(marker.getPosition());
      
      });
      markers.push(marker);
      marker.setMap(map);
   }
   
   function addMarkerElement(tmpLat, tmpLng, name, jibun, road, buildForm) {
      var marker = new google.maps.Marker({
         position: new google.maps.LatLng(parseFloat(tmpLat),parseFloat(tmpLng)),
         label: name,
         title: name,
         icon: {            
             path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,           
               strokeColor: "green",             
             scale: 5
         },
      });
      marker.addListener('click', function() {
         $('#modal_name').html(name);
         $('#modal_buildForm').html("구분   : "+buildForm);
         $('#modal_jibun').html("지번    : "+jibun);
         $('#modal_road').html("도로명    : "+road);
         $('#modal_accident_header').html('');
         $('#modal_accident').html("");
         $('#modal_cnt').html("");
         $("#elementInfo").show();
         $("#elementInfo").show();
         map.setZoom(17);
         map.setCenter(marker.getPosition());

      });
      markers.push(marker);
      marker.setMap(map);
   }
   
   function addMarkerElementRed(tmpLat, tmpLng, name,jibun, road, buildForm, occrrnc_cnt, dth_dnv_cnt, se_dnv_cnt, sl_dnv_cnt) {
      var marker = new google.maps.Marker({
         position: new google.maps.LatLng(parseFloat(tmpLat),parseFloat(tmpLng)),
         label: name,
         title: name,
         icon: {            
             path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,           
               strokeColor: "red",             
             scale: 5
         },
      });
      marker.addListener('click', function() {
         $('#modal_name').html(name);
         $('#modal_buildForm').html("구분   : "+buildForm);
         $('#modal_jibun').html("지번    : "+jibun);
         $('#modal_road').html("도로명    : "+road);
         $('#modal_accident_header').html('<h4 class="modal-title">스쿨존 사고 정보</h4>');
         $('#modal_accident').html("발생건수 : "+occrrnc_cnt);
         $('#modal_cnt').html("사망자수 : "+occrrnc_cnt+", 중상자수 : "+se_dnv_cnt+", 경상자수 : "+sl_dnv_cnt);
         $("#elementInfo").show();
         map.setZoom(17);
         map.setCenter(marker.getPosition());
      });
      markers.push(marker);
      marker.setMap(map);
   }
   


      

</script>
<!-- map end -->
<table class="table table-bordered table-hover">
   <thead class="thead-dark">
      <tr>
         <th>번호</th>
         <th>법정동</th>
         <th>아파트이름</th>
         <th>지번</th>
         <th>지역코드</th>
         <th>위도</th>
         <th>경도</th>
      </tr>
   </thead>
   <tbody>
   </tbody>
</table>
            </div>
         </div>
         
      <!-- login modal start -->
      <div class="modal" id="elementInfo">
         <div class="modal-dialog modal-md" style="vertical-align: middle;">
            <div class="modal-content">
               <!-- ModalHeader -->
               <div class="modal-header">
                  <h4 class="modal-title">초등학교 정보</h4>
               </div>
               <!-- Modal body -->
               <div class="modal-body">
                  <div class="form-group">                   
                          <div id="modal_name"></div> 
                        <div id="modal_buildForm"></div>
                        <div id="modal_jibun"></div>  
                     <div id="modal_road"></div>
                     <div id="modal_accident_header"></div> 
                     <div id="modal_accident"></div>   
                     <div id="modal_cnt"></div>                 
                  </div>                             
               </div>
               <!-- Modal footer -->
               <div class="modal-footer">              
                  <button type="button" class="btn btn-danger" id="elementInfoBtn">Close</button>
               </div>
            </div>
         </div>
      </div>
      <!-- login modal end -->         
         
         
      </section>
<!-- section end -->   
</div>
   
</body>
</html>