<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.net.URLEncoder" %>
<%
  // Read submitted form values as UTF-8, including non-English text.
  request.setCharacterEncoding("UTF-8");
  String name = request.getParameter("name");
  String email = request.getParameter("email");
  String summary = request.getParameter("summary");

  // Validate required fields and the requested name and email rules.
  boolean namePresent = name != null && !name.isEmpty();
  boolean emailPresent = email != null && !email.isEmpty();
  boolean summaryPresent = summary != null && !summary.isEmpty();
  boolean nameLengthValid = namePresent && name.length() < 10;
  boolean nameStartsWithCapital = namePresent && name.charAt(0) >= 'A' && name.charAt(0) <= 'Z';
  boolean emailValid = emailPresent && email.endsWith("@gmail.com");

  boolean formValid = namePresent && nameLengthValid && nameStartsWithCapital
      && emailPresent && emailValid && summaryPresent;

  String resultUrl = null;
  String refreshUrl = null;
  if (formValid) {
    // Encode every value before adding it to the result page's query string.
    resultUrl = "result.html?name=" + URLEncoder.encode(name, "UTF-8")
        + "&email=" + URLEncoder.encode(email, "UTF-8")
        + "&summary=" + URLEncoder.encode(summary, "UTF-8");
    refreshUrl = resultUrl.replace("&", "&amp;");
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify Details</title>
  <style>
    /* Match the simple centered layout used by the other pages. */
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      padding: 24px;
      background: #eef3f8;
      color: #1f2937;
      font-family: Arial, sans-serif;
    }
    .card {
      width: min(100%, 560px);
      padding: 36px;
      background: #ffffff;
      border: 1px solid #d9e2ec;
      border-radius: 12px;
      box-shadow: 0 12px 32px rgba(31, 41, 55, 0.08);
    }
    h1 { margin-top: 0; color: #174a6e; }
    .success { color: #17613b; line-height: 1.7; }
    .error { color: #a12d2d; line-height: 1.7; }
    a { color: #176b87; }
    @media (max-width: 480px) { .card { padding: 26px; } }
  </style>
<% if (formValid) { %>
  <meta http-equiv="refresh" content="2; url=<%= refreshUrl %>">
<% } %>
</head>
<body>
  <main class="card">
<% if (formValid) {
%>
    <h1>Details Verified</h1>
    <p class="success">Name Verified</p>
    <p class="success">Email Verified</p>
    <!-- Show the verification messages before continuing to the result page. -->
    <p>You will continue to your result shortly. <a href="<%= refreshUrl %>">Continue now</a>.</p>
    <script>
      // JavaScript redirects promptly; the meta refresh above is a fallback.
      window.setTimeout(function () {
        window.location.replace("<%= resultUrl %>");
      }, 2000);
    </script>
<% } else { %>
    <h1>Please Check Your Details</h1>
    <ul class="error">
<%   if (!namePresent) { %>
      <li>Name is required.</li>
<%   } else {
       if (!nameLengthValid) { %>
      <li>Name must contain fewer than 10 characters.</li>
<%     }
       if (!nameStartsWithCapital) { %>
      <li>Name must start with an uppercase letter from A to Z.</li>
<%     }
     }
     if (!emailPresent) { %>
      <li>Email ID is required.</li>
<%   } else if (!emailValid) { %>
      <li>Email ID must end with @gmail.com.</li>
<%   }
     if (!summaryPresent) { %>
      <li>Summary is required.</li>
<%   } %>
    </ul>
    <!-- Let the user correct the form without losing the page flow. -->
    <a href="test.html">Go Back</a>
<% } %>
  </main>
</body>
</html>
