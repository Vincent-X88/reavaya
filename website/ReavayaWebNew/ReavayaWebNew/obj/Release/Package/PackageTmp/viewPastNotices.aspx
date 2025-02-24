<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="viewPastNotices.aspx.cs" Inherits="ReavayaWebNew.viewPastNotices" Async="true"%>
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
<a href="Dashboard.aspx"><img src="assets/img/Rea_Vaya_logo.svg" alt=""></a>
</div>

<div class="main-menu d-none d-lg-block">
<nav>
<ul id="navigation">
<li><a href="Dashboard.aspx">Dashboard</a></li>
<li><a href="addNotices.aspx">Add Notices</a></li>
<li><a href="viewPastNotices.aspx">Past Notices</a></li>
<li><a href="Transactions.aspx">Transactions</a></li>
<li><a href="traffic.aspx">Statistics</a></li>
<!--li><a href="borwse_job.html">About us</a></!--li>
<li><a href="contact.html">Contact</a></li-->
<li><a href="editManagerProfile.aspx" id="edit" runat="server">Profile</a></li>

</ul>
</nav>
</div>
</div>

<div class="buttons">
<ul>
    <li class="button-header">
        <a href="Logout.aspx" id="logout" runat="server" class="btn header-btn2"><i class="fas fa-logout-alt"></i>Logout</a>
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
     <div class="login-form-area section-padding">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-xl-9 col-lg-9 col-md-10">
                    <div class="login-form">
<form runat="server">
 <div class="login-heading">
<span>Past Notices</span>
</div>

<div class="input-box">
                            <div class="single-input-fields">
                                <label> Start Date</label>
                                <asp:TextBox ID="startDate" type="date" runat="server"  placeholder="" Height="31px" Width="170px"></asp:TextBox>
                            </div>
                            <div class="single-input-fields">
                                <label>End Date</label>
                                <asp:TextBox ID="endDate" type="date" runat="server" placeholder="" Height="31px" Width="170px"></asp:TextBox>
                            </div>
                            <div class="login-footer">
                                 <asp:Button ID="btnPastNotices" runat="server" type="submit" class="btn login-btn" Text="View Past Notice" OnClick="btnPastNotices_Click" />
                            </div>
                            <div> 
                                
                            </div>
                            <asp:GridView ID="gridPastNotices" runat="server" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:BoundField DataField="TimeSent" HeaderText="Date & Time" />
                                    <asp:BoundField DataField="Title" HeaderText="Title" />
                                    <asp:BoundField DataField="Notice" HeaderText="Notice" />
                                </Columns>
                            </asp:GridView>

                        <div class="single-input-fields">
                            <asp:Label ID="StatusLabel" runat="server" style="color:green" Text="" CssClass="success-message" Visible="false"></asp:Label>
                        </div>
                    </div>
                        </form>
                    </div>
                       
                </div>
            </div>     
            </div>
    </div>
</asp:Content>
