ThemeMetro Redo
==============================================================================
Release Version:  v1.0.3
Release Date: 10th January, 2018
Copyright (c) ThmesMetro.cm All Rights Reserved.                     


The following steps will guide you through the installation process:
=============================================================================
1- Unzip the contents of the zip file to a folder on your computer
2- Replace logo /assets/images/logo-dark.png
3- Upload the files in the 'upload' folder to your whmcs installation folder
4- Log in to WHMCS admin for activation of the new theme as per your choice and new order form.
(If you experience any problems, try uploading in binary mode.)

5- To edit Home page SEO Title and Tags - lang/overrides/english.php
For other languages just copying english.php in same folder and rename it like turkey.php etc.. and edit contents.

Modifications:
=============================================================================
Option 1 - To edit navigation menu please use /includes/hooks/TMPrimaryNavbar.php
for more information about whmcs 6.x client area navigation menu please visit http://docs.whmcs.com/Client_Area_Navigation_Menus_Cheatsheet 

Options 2 - If you want to use Simple navigation menu without any hooks like whmcs 5.x

To use this navigation menu you need to replace below line in header.tpl -
[line number - 171]

From 
{include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}

To
{include file="$template/includes/simple-navbar.tpl"}

Then edit file /includes/simple-navbar.tpl as per your choice.

Content Modifications:
=============================================================================
For contents modification - Edit following below .tpl files by using any text editor (recommended NotePad ++).
For help the Comments are given in files itself.

header.tpl
footer.tpl

Additional Pages
------------------------
homepage.tpl
about-us.tpl
web-hosting.tpl
web-hosting-windows.tpl
reseller-hosting.tpl
vps-hosting.tpl
dedicated-servers.tpl
ssl-certificates.tpl
------------------------

If you still need any assistance please open a support ticket for free installation Or Custom quote for content integration or modifications.

Contact Information
E-mail (sales/Support): https://thememetro.com/submitticket.php
Web site: https://www.thememetro.com

Thank you very for choosing our themes.
