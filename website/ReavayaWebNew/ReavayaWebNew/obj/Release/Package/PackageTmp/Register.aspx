﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ReavayaWebNew.Register" %>
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
<a href="Register.aspx"><img src="assets/img/Rea_Vaya_logo.svg" alt=""></a>
</div>

<div class="main-menu d-none d-lg-block">
<nav>
<ul id="navigation">
<li><a href="Register.aspx">Register</a></li>
<!--li><a href="borwse_job.html">About us</a></!--li>
<li><a href="contact.html">Contact</a></li-->
</ul>
</nav>
</div>
</div>

<div class="buttons">
<ul>
    <li class="button-header">
        <a href="Login.aspx" id="log" runat="server" class="btn header-btn2"><i class="fas fa-phone-alt"></i>Login</a>
    </li>
</ul>
</div>
</div>
</div>
</div>
</div>
</header>
    <div class="register-form-area section-padding">
<div class="container">
<div class="row justify-content-center">
<div class="col-xl-9 col-lg-9 col-md-10">
<div class="register-form text-center">
<form runat="server">
<div class="register-heading">
<span>Register as a Passenger</span>
<p>Scroll down to register as a Rea Vaya Manager</p>
</div>

<div class="input-box">
    <div class="single-input-fields">
        <label>Name</label>
        <asp:TextBox ID="FirstName" type="text" runat="server" required="required" placeholder="Enter Your Name"></asp:TextBox>
    </div>
        <p id="nameErr" visible="false" runat="server" style="color:red">Name can only be alphabets.</p>
    <div class="single-input-fields">
        <label>Surname</label>
        <asp:TextBox ID="Surname" type="text" runat="server" required="required" placeholder="Enter Your Surname"></asp:TextBox>
    </div>
        <p id="surErr" visible="false" runat="server" style="color:red">Surname can only be alphabets.</p>
    <div class="single-input-fields">
        <label>Email</label>
        <asp:TextBox ID="Email" type="email" runat="server" required="required" placeholder="Enter Your Email Address"></asp:TextBox>
    </div>
        <p id="ErrorEmail" visible="false" runat="server" style="color:red">The email you entered is already used.</p>
    
    <div class="single-input-fields">
        <label>Phone Number</label>
        <asp:TextBox ID="PhoneNumbers" type="text" runat="server" required="required" placeholder="Enter Your Phone Number"></asp:TextBox>
    </div>
        <p id="phoneErr" visible="false" runat="server" style="color:red">Phone number can only be numbers of 10 digits.</p>
    <div class="single-input-fields">
        <label>Age</label>
        <asp:TextBox ID="Age" type="text" runat="server" required="required" placeholder="Enter Your Age"></asp:TextBox>
    </div>
        <p id="ageErr" visible="false" runat="server" style="color:red">Age can only be numbers.</p>
    <div class="single-input-fields">
        <label>Password</label>
        <asp:TextBox ID="Password" type="password" runat="server" required="required" placeholder="Enter Password"></asp:TextBox>
    </div>
    <div class="single-input-fields">
        <label>Confirm Password</label>
        <asp:TextBox ID="CPassword" type="password" runat="server" required="required" placeholder="Confirm Password"></asp:TextBox>
    </div>
        <p id="ErrorPW" visible="false" runat="server" style="color:red">Passwords don't match.</p>

</div>

<div class="register-footer">
    <asp:Button ID="btnRegister" runat="server" type="submit" class="btn login-btn" Text="Register" OnClick="btnRegister_Click"/>
    <p id="regError" visible="false" runat="server" style="color:red">Please check if you entered your correct credentials.</p>
    <p> Already have an account? <a href="Login.aspx">Click here</a></p><br />
    <p>Are you the Manager? <a href="RegisterManager.aspx">Register here</a></p>
</div>
</form>
</div>
</div>
</div>
</div>
</div>

</asp:Content>
