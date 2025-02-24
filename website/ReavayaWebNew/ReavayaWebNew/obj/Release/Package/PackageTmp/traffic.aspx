<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="traffic.aspx.cs" Inherits="ReavayaWebNew.traffic" %>
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
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      color: #333;
      margin: 0;
      padding: 0;
    }

    h1 {
      text-align: center;
      margin-top: 100px;
    }

    p {
      margin-bottom: 20px;
    }

    .stats ul {
      list-style-type: none;
      margin: 0;
      padding: 0;
    }

    .stats li {
      display: inline-block;
      width: calc(25% - 10px);
      margin-right: 30px;
      padding: 20px;
      text-align: center;
      background-color: #ffffff;
      border-radius: 5px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease-in-out;
      cursor: pointer;
    }

    .stats li:hover {
      transform: translateY(-5px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .stats li strong {
      display: block;
      font-size: 36px;
      margin-bottom: 10px;
      color: #333;
    }

    .stats li span {
      display: block;
      font-size: 18px;
      color: #aaa;
    }

    .stats li i {
      display: block;
      font-size: 24px;
      margin-bottom: 10px;
      color: #4285f4;
    }

    /* Add some styles for the filter buttons */
    button {
      background-color: #4285f4;
      color: #ffffff;
      border: none;
      padding: 10px;
      margin-right: 10px;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>

    <div class="login-form-area section-padding">
<div class="container">
<div class="row justify-content-center">
<div class="col-xl-9 col-lg-9 col-md-10">
<div class="login-form">
<form runat="server">
 <div class="login-heading">
<span>View Traffic Statistics</span>
</div>

<div class="input-box">

    <div class="filters">
      <asp:DropDownList ID="filterDropDown" runat="server">
            <asp:ListItem Text="Today" Value="day" />
            <asp:ListItem Text="This Week" Value="week" />
            <asp:ListItem Text="This Month" Value="month" />
            <asp:ListItem Text="Overall" Value="all" />
        </asp:DropDownList><br /><br />

        <asp:Button ID="filterButton" runat="server" class="btn login-btn" Text="Filter" OnClick="FilterTrafficData_Click" />
    </div><br /><br />

        <div class="stats">
            <ul>
                <li>
                    <i class="fas fa-sign-in-alt"></i>
                    <strong><asp:Literal ID="loginCountLiteral" runat="server">0</asp:Literal></strong>
                    <span>Number of Passenger Logins</span>
                </li>
        <li>
            <i class="fas fa-users"></i>
            <strong><asp:Literal ID="registeredPassengersLiteral" runat="server">0</asp:Literal></strong>
            <span>Number of Registered Passengers</span>
        </li>
        <li>
            <i class="fas fa-user"></i>
            <strong><asp:Literal ID="activeUsersLiteral" runat="server">0</asp:Literal></strong>
            <span>Number of currently Active Users</span>
        </li>
            </ul>
    <div id="trafficChartContainer">
    <canvas id="trafficChart"></canvas>
</div>
        <!--h2>Demographic Insights:</!--h2-->
        <div id="ageDistributionChart" runat="server"></div>
</div>
    </form>
</div>
</div>
</div>
</div>
    </div>

    <!-- Include Font Awesome icons -->

    <script src="https://kit.fontawesome.com/2c36e9b7b1.js" crossorigin="anonymous"></script>


    <script type="text/javascript">
        function createTrafficChart(data) {
            var chartContainer = document.getElementById('trafficChartContainer');
            var ctx = document.getElementById('trafficChart').getContext('2d');

            var trafficChart = new Chart(ctx, {
                type: 'bar', // Use 'bar' for bar chart or change to your preferred type
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Traffic Data',
                        data: data.values,
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

    </script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>

</asp:Content>
