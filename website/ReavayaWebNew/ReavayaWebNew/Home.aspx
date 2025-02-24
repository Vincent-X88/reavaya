﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="ReavayaWebNew.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
  .btn {
    margin-right: 20px; 
   
  }
  
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
     <header>
<div class="header-area header-transparent">
<div class="main-header header-sticky">
<div class="container">
<div class="menu-wrapper d-flex align-items-center justify-content-between">
<div class="left-content d-flex align-items-center">
<div class="logo mr-45">
<a href="Home.aspx"><img src="assets/img/Rea_Vaya_logo.svg" alt=""></a>
</div>

<div class="main-menu d-none d-lg-block">
<nav>
<ul id="navigation">
<li><a href="Home.aspx">Home</a></li>
<!--li><a href="borwse_job.html">About us</a></!--li>
<li><a href="contact.html">Contact</a></li-->
<li><a href="editProfile.aspx" id="edit" runat="server">Profile</a></li>

</ul>
</nav>
</div>
</div>

<div class="buttons">
<ul>
    <li class="button-header">
        <a href="Logout.aspx" id="logout" runat="server" class="btn header-btn2"><i class="fas fa-phone-alt"></i>Logout</a>
    </li>
</ul>
</div>
</div>

<div class="col-12">
<div class="mobile_menu d-block d-lg-none"></div>
</div>
</div>
</div>
</div>
</header>
    <main>

<div class="slider-area position-relative" >

<div class="single-sliders slider-height  gray-bg d-flex align-items-center">
<div class="container" style="margin-top: -10px;">
<div class="row align-items-center">
<div class="col-xl-6 col-lg-7"> 
<div class="hero-caption">
<span>Easiest way to catch a ride</span>
<h1>Ride with us, arrive with ease</h1>

<div class="slider-btns">
<a href="Buypoint.aspx" id="buy" runat="server" class="btn hero-btn" style="margin-top:20px">Buy Points</a>
<a href="TripPlanner.aspx" id="plan" runat="server" class="btn hero-btn" style="margin-top:20px">Plan A Trip</a>
<a href="scanQR.aspx" id="scan" runat="server" class="btn hero-btn" style="margin-top:20px">Start A Ride</a>
 <a href="BusRoutes.aspx" id="route" runat="server" class="btn hero-btn" style="margin-top:20px">Bus Routes</a>

</div>
</div>
</div>
</div>
</div>
</div>

<div class="hero-tittle">

</div>

<div class="hero-img"  >
<img src="assets/img/ReaVaya3.jpg" alt="" style="margin-top: 1000px;">
</div>

<div class="hero-shape bounce-animate">

</div>

<div class="hero-shape2">

</div>
</div>


<section class="top-jobs fix ">
<div class="container">
<div class="row justify-content-center">
                    <div class="col-xl-10 col-lg-11 col-md-14">

<div class="section-tittle section-tittle3 text-center mb-10">
<span>50+</span>
<h2>stations available</h2>
<p>Our company has developed a map that displays all of our available locations throughout the area, making it easy for potential customers to find us. With detailed information and accurate location markers, users can quickly navigate to any of our establishments</p>
</div>
</div>
</div>
</div>
<div class="container-fluid p-0" style="display: flex; justify-content: center; align-items: center;">
<img src="assets/img/Official_Rea_Vaya_Route_Map.jpg">
</div>
</section>


</main>
</asp:Content>
