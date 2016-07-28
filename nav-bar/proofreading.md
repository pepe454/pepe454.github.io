---
layout: page
title: Send us your paper to proofread!
permalink: /proofreading/
---
<html>
<body>

<form action="{{ "/email.html" | prepend: site.baseurl }}">
  <fieldset>
    <legend>Your Essay:</legend>
    First name:<br>
    <input type="text" name="firstname">
    <br>
    Last name:<br>
    <input type="text" name="lastname">
    <br>
    Essay:<br>
    <textarea name="Text1" 
              cols="35" 
              rows="10"
              style="width:600px; height:350px;">
    </textarea> 
    <br><br>
    <input type="submit" value="Submit">
  </fieldset>
</form>
<table>
 <tr>
   <td>
   Hopefully this email thing will work
   </td>
 </tr>
</table>
</body>
</html>
