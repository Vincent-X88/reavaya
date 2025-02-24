﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ReavayaWebNew.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
     <header>
<div class="header-area header-transparent">
<div class="main-header header-sticky">
<div class="container">
<div class="menu-wrapper d-flex align-items-center justify-content-between">
<div class="left-content d-flex align-items-center">
<div class="logo mr-45">
<a href="index.aspx"><img src="assets/img/Rea_Vaya_logo.svg" alt=""></a>
</div>

<div class="main-menu d-none d-lg-block">
<nav>
<ul id="navigation">
<li><a href="Login.aspx">Login</a></li>
<!--li><a href="borwse_job.html">About us</a></!--li>
<li><a href="contact.html">Contact</a></li-->
</ul>
</nav>
</div>
</div>

<div class="buttons">
<ul>
    <li class="button-header">
        <a href="Register.aspx" id="log" runat="server" class="btn header-btn2"><i class="fas fa-phone-alt"></i>Register</a>
    </li>
</ul>
</div>
</div>
</div>
</div>
</div>
</header>
    <div class="login-form-area section-padding">
<div class="container">
<div class="row justify-content-center">
<div class="col-xl-9 col-lg-9 col-md-10">
<div class="login-form">
<form runat="server">
 <div class="login-heading">
<span>Login as a Passenger</span>
<p>Scroll down to login as a Rea Vaya Manager</p>
</div>

<div class="input-box">

    <div class="single-input-fields">
        <label>Email Address</label>
        <asp:TextBox ID="Email" type="email" runat="server" required="required" placeholder="Enter Your Email Address"></asp:TextBox>
    </div>
    <div class="single-input-fields">
        <label>Password</label>
        <asp:TextBox ID="Password" type="password" runat="server" required="required" placeholder="Enter Your Password"></asp:TextBox>
    </div>
<!--div class="single-input-fields login-check">
    <asp:CheckBox ID="CheckBox" type="checkbox" name="keep-log" runat="server" CssClass="chkKeepLoggedIn" />
    <label for="CheckBox">Keep me logged in</label>
</!--div-->
</div>

<div class="login-footer">
    <asp:Button ID="btnLogin" runat="server" type="submit" class="btn login-btn" Text="Login" OnClick="btnLogin_Click"/>
    <p>Don’t have an account? <a href="Register.aspx">Click here</a></p><br />
    <p>Are you the Manager? <a href="LoginManager.aspx">Login here</a></p>
</div>
    <p id="logError" visible="false" runat="server" style="color:red">Incorrect Email or Password, Please click the link below to register if you haven't</p>
</form>
</div>
</div>
</div>
</div>
</div>
</asp:Content>
