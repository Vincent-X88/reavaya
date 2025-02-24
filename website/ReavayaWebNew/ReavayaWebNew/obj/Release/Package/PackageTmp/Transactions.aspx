<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="ReavayaWebNew.Transactions" Async="true" %>

<!DOCTYPE html>
<html>
<head runat="server">
  <title>Rea Vaya Website</title>
  
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">

<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="manifest" href="https://preview.colorlib.com/theme/jobsco/site.webmanifest">
<link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

<link rel="stylesheet" href="assets/css/bootstrap.min.css">
<link rel="stylesheet" href="assets/css/owl.carousel.min.css">
<link rel="stylesheet" href="assets/css/slicknav.css">
<link rel="stylesheet" href="assets/css/animate.min.css">
<link rel="stylesheet" href="assets/css/magnific-popup.css">
<link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
<link rel="stylesheet" href="assets/css/themify-icons.css">
<link rel="stylesheet" href="assets/css/slick.css">
<link rel="stylesheet" href="assets/css/nice-select.css">
<link rel="stylesheet" href="assets/css/style.css">
    <!-- Include Plotly JavaScript -->
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
    .containers {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 60vh;
        padding: 15px;
    }

        #TransactionsGridViewContainer {
            width: 98%;
            max-height: 500px;  
            overflow-y: auto;
            border: 1px solid #a6d4fa;
            background-color: #f5faff;
        }

        #TransactionsGridView {
            width: 100%; 
            font-size: 16px;
            border-collapse: collapse;  
        }

        #TransactionsGridView th {
            background-color: #a6d4fa; 
            padding: 10px;
        }

        #TransactionsGridView td {
            padding: 10px;
            border-bottom: 1px solid #d0e4f6; 
        }

        /* Additional styling for better spacing and the touch of blue */
        #selectedDateInput {
            margin-bottom: 10px;
            border: 2px solid #a6d4fa;
            padding: 5px 10px;
        }

        .blue-btn {
            background-color: #a6d4fa;
            border: none;
            padding: 5px 15px;
            margin-top: 10px;
            cursor: pointer;
        }

    </style>
</head>
<body>
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
</header><br />

    <div class="login-form-area section-padding">
<div class="container">
<div class="row justify-content-center">
<div class="col-xl-9 col-lg-9 col-md-10">
<div class="login-form">
<form id="form1" runat="server">
 <div class="login-heading">
<span>View Transactions</span>
</div>

<div class="input-box">
<asp:Label ID="SelectDateLabel" runat="server" Text="Select Date:"></asp:Label>
<asp:TextBox ID="selectedDateInput" runat="server" TextMode="Date"></asp:TextBox>
<asp:Button ID="FetchTransactionsButton" runat="server" Text="Fetch Transactions" OnClick="FetchTransactionsButton_Click" class="btn login-btn"/>
<br /><br />
<input type="button" id="DisplayHeatmapButton" value="Display Heatmap" onclick="updateHeatmap()" class="btn login-btn"/>
<asp:HiddenField ID="HiddenFieldForTransactions" runat="server" />
<div id="TransactionsGridViewContainer">
    <asp:GridView ID="TransactionsGridView" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="User_ID" HeaderText="User ID" />
            <asp:BoundField DataField="TotalPoints" HeaderText="Total Points" />
            <asp:BoundField DataField="TimeStamp" HeaderText="Time" />
            <asp:BoundField DataField="TimePeriod" HeaderText="Time Period" />
        </Columns>
    </asp:GridView>
</div>
</div>
<div id="heatmapContainer" class="containers"></div>
</form>
</div>
</div>
</div>
</div>
</div>

    <script type="text/javascript">

        // Function to display heatmap
        function displayHeatmap() {
            var data = [
                {
                    z: [[1, 20, 30],
                    [20, 1, 60],
                    [30, 60, 1]],
                    type: 'heatmap'
                }
            ];
            Plotly.newPlot('heatmapContainer', data);
        }

        // Function to update heatmap
        function updateHeatmap() {
            var transactions = JSON.parse(document.getElementById('<%= HiddenFieldForTransactions.ClientID %>').value);
            var heatmapData = [0, 0, 0]; // [morning, afternoon, evening]

            for (var i = 0; i < transactions.length; i++) {
                var transactionTime = new Date(transactions[i].TimeStamp);
                var transactionHour = transactionTime.getHours();

                if (transactionHour >= 6 && transactionHour < 12) {
                    // Morning (6 AM to 12 PM)
                    heatmapData[0] += 1;
                } else if (transactionHour >= 12 && transactionHour < 18) {
                    // Afternoon (12 PM to 6 PM)
                    heatmapData[1] += 1;
                } else {
                    // Evening (6 PM to 6 AM)
                    heatmapData[2] += 1;
                }
            }

            var data = [
                {
                    z: [heatmapData],
                    type: 'heatmap',
                    x: ['Morning', 'Afternoon', 'Evening'],
                    y: ['Transactions']
                }
            ];

            Plotly.newPlot('heatmapContainer', data);
        }

    </script>

    <script src="assets/js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="assets/js/popper.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>

    <script src="assets/js/owl.carousel.min.js"></script>
    <script src="assets/js/isotope.pkgd.min.js"></script>
    <script src="assets/js/ajax-form.js"></script>
    <script src="assets/js/waypoints.min.js"></script>
    <script src="assets/js/jquery.counterup.min.js"></script>
    <script src="assets/js/imagesloaded.pkgd.min.js"></script>
    <script src="assets/js/scrollIt.js"></script>
    <script src="assets/js/jquery.scrollUp.min.js"></script>
    <script src="assets/js/wow.min.js"></script>
    <script src="assets/js/nice-select.min.js"></script>
    <script src="assets/js/jquery.slicknav.min.js"></script>
    <script src="assets/js/jquery.magnific-popup.min.js"></script>
    <script src="assets/js/plugins.js"></script>
    <script src="assets/js/gijgo.min.js"></script>
    <script src="assets/js/slick.min.js"></script>

    <script src="assets/js/contact.js"></script>
    <script src="assets/js/jquery.ajaxchimp.min.js"></script>
    <script src="assets/js/jquery.form.js"></script>
    <script src="assets/js/jquery.validate.min.js"></script>
    <script src="assets/js/mail-script.js"></script>
    <script src="assets/js/main.js"></script>

</body>
</html>
