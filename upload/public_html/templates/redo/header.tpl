{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


<!DOCTYPE html>
<html lang="en">
	
	<head>
		<meta charset="{$charset}" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		{if $templatefile == 'homepage'}
		
		<title>{$LANG.title_homepage}</title>
		<meta name="keywords" content="{$LANG.meta_keywords_homepage}" />
		<meta name="description" content="{$LANG.meta_description_homepage}" />
		
		{else}
		
		<title>{if $kbarticle.title}{$kbarticle.title} - {/if}{$pagetitle} - {$companyname}</title>
		{/if}
		
		{include file="$template/includes/head.tpl"}
		

		{$headoutput}
	</head>
	
	<body class="Redo header-2 menu-in-right {if $showingLoginPage}login{/if}" data-phone-cc-input="{$phoneNumberInputStyle}">	
	{if !$showingLoginPage}
	
	{$headeroutput}

    <nav class="navbar top-navbar navbar-fixed-top" role="navigation">
		
		<div class="pre-header">
			<div class="container-fluid">
				<div class="row">
					<!-- BEGIN TOP BAR LEFT PART -->
					<div class="col-xs-5 col-sm-6">
						<ul class="list-unstyled list-inline hidden-xs">
 							<li><i class="fa fa-envelope-o"></i><span>contact@miownsite.com</span></li>
{* 							<li><i class="fa fa-envelope-o"></i><span>contact@miownsite.com</span></li> *}
						</ul>
						<ul class="list-unstyled list-inline visible-xs">
							<li>
								<span  class="tooltip-primary" data-placement="right" data-rel="tooltip" title="contact@miownsite.com">
									<i class="fa fa-envelope-o"></i>	

								</span>
							</li>
							<li>
{*fa-phone icon tooltip
								<span  class="tooltip-primary" data-placement="right" data-rel="tooltip" title="contact@miownsite.com">
									<i class="fa fa-phone"></i>
*}
								</span>
							</li>
						</ul>
					</div>
					<!-- END TOP BAR LEFT PART -->
					<!-- BEGIN TOP BAR MENU -->
					<div class="col-xs-7 col-sm-6 additional-nav">
						<ul class="list-unstyled list-inline pull-right">
						
							<!-- Shopping Cart -->
							{if !$loggedin}
							<li class="dropdown">
								<a href="{$WEB_ROOT}/cart.php?a=view" class="quick-nav">
									<i class="fa fa-shopping-cart"></i> <span class="badge up badge-success" id="cartItemCount">{$cartitemcount}</span>
								</a>
							</li>						
							{/if}
							
							<!-- Login/Account Notifications -->
							{if $loggedin}
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">
									<i class="fa fa-bell-o"></i>  <span class="badge up badge-primary">{$clientAlerts|count}</span>
								</a>
								<ul class="dropdown-menu dropdown-scroll dropdown-tasks auto">
									<li class="dropdown-header">
										<i class="fa fa-info-circle"></i> ({$clientAlerts|count}) {$LANG.notifications}
									</li>
									<li id="taskScroll">
										<ul class="list-unstyled">
											{foreach $clientAlerts as $alert}
											<li>
												<a class="text-{$alert->getSeverity()}" href="{$alert->getLink()}">{$alert->getMessage()} {if $alert->getLinkText()} <button href="{$alert->getLink()}" class="btn btn-xs btn-{$alert->getSeverity()}">{$alert->getLinkText()}</button>{/if}</a>
											</li>
											{foreachelse}
											<li>
												<a href="javascript:;">{$LANG.notificationsnone}</a>
											</li>
											{/foreach}
										</ul>
									</li>
								</ul>
							</li>
							{/if}
							
							<!-- Language -->
							{if $languagechangeenabled && count($locales) > 1}
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">
									<i class="fa fa-language visibe-hidden"></i> <span class="hidden-xs">{$activeLocale.localisedName}</span>
								</a>
								<ul class="dropdown-menu dropdown-scroll dropdown-tasks auto auto-width">
									<li class="dropdown-header">
										<i class="fa fa-list"></i> {$LANG.chooselanguage}
									</li>
									<li id="langScroll">
										<ul class="list-unstyled">
											{foreach $locales as $locale}
												<li><a href="{$currentpagelinkback}language={$locale.language}">{$locale.localisedName}</a></li>
											{/foreach}
										</ul>
									</li>
								</ul>
							</li>
							{/if}
							
							{if $adminMasqueradingAsClient || $adminLoggedIn}
								<li class="dropdown">
									<a href="{$WEB_ROOT}/logout.php?returntoadmin=1" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{$LANG.adminmasqueradingasclient} {$LANG.logoutandreturntoadminarea}{else}{$LANG.adminloggedin} {$LANG.returntoadminarea}{/if}">
										<i class="fa fa-sign-out text-danger"></i>
									</a>
								</li>
							{/if}

						</ul>
					</div>
					<!-- END TOP BAR MENU -->
				</div>
			</div>        
		</div>

        <div id="navbar-container" class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
                    <i class="fa fa-bars"></i>
                </button>
               <a class="navbar-brand" href="{$WEB_ROOT}/">
                    <img src="{$WEB_ROOT}/templates/{$template}/assets/images/logo.png" alt="{$companyname}" class="img-responsive" />
                </a>
				
				 <!-- Top Menu Right-->
				<ul class="nav navbar-right">
				
					<!--Search Box-->
					<li class="dropdown search-bar">
						<a href="" data-toggle="modal" data-target="#Redo-search-box">
							<span class="glyphicon glyphicon-search text-primary"></span>
						</a>
					</li>
					<!--Search Box-->
					
					{include file="$template/includes/navbar.tpl" navbar=$secondaryNavbar}

				</ul>
				
            </div>		
            <!-- Top Menu Right-->
			<div class="nav-top">
			
				<!-- Top Menu Left-->
				<div class="top-menu collapse navbar-collapse navbar-main-collapse">
					<ul class="nav navbar-nav navbar-left">
					
						{include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}
						
					</ul>
				</div>
				<!-- Top Menu Left-->
				
			</div>
            <!-- /.Top Menu -->
		</div>
        <!-- /.container -->
		
		{include file="$template/includes/verifyemail.tpl"}
		
    </nav>



	<div class="page-container"><!-- /page container -->
		
		{if $templatefile eq 'homepage' or $pagetype eq 'redo' or $carttpl eq 'redo-default' or $skipMainBodyContainer}{else}
		<div class="mass-head">		
			<div class="hero-bg-wrap style-2 bg-opacity">
				<div class="container-fluid">
					<div class="page-title">
						<h1>
							{if $pagetitle eq $LANG.supportticketspagetitle || $pagetitle eq $LANG.supportticketsviewticket || $pagetitle eq $LANG.supportticketssubmitticket}
								<i class="fa fa-ticket"></i>
							{elseif $pagetitle eq $LANG.knowledgebasetitle}
								<i class="fa fa-question-circle"></i>
							{elseif $pagetitle eq $LANG.announcementstitle}
								<i class="fa fa-bullhorn"></i>
							{/if}
							{$pagetitle}
						</h1>
					</div>
				</div>
			</div>
		</div>
		{/if}
		
		{if $skipMainBodyContainer}{else}
		{if $templatefile eq 'homepage' or $pagetype eq 'redo' or $carttpl eq 'redo-default'}{else}
		<div class="container-fluid">
			<div class="block-s3">
			
			{if $templatefile eq 'homepage' or $carttpl eq 'redo-default'}{else}
			<div class="row">
				<div class="col-xs-12">
					{include file="$template/includes/pageheader.tpl" title=$displayTitle desc=$tagline showbreadcrumb=false}
				</div>
			</div>
			{/if}
			
		{if $templatefile == 'clientareahome'}	
		<div class="row">
			<div class="col-lg-3 col-sm-6">
				<a href="clientarea.php?action=services" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-cube text-primary"></i>
						<div class="tile-content text-primary">
							{$clientsstats.productsnumactive}
						</div>
						<small class="text-gray"">{$LANG.navservices}</small>
					</div>
				</a>
			</div>
			{if $registerdomainenabled || $transferdomainenabled}
			<div class="col-lg-3 col-sm-6">
				<a href="clientarea.php?action=domains" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-globe text-success"></i>
						<div class="tile-content text-success">
							{$clientsstats.numactivedomains}
						</div>
						<small class="text-gray"">{$LANG.navdomains}</small>
					</div>
				</a>
			</div>
			{elseif $condlinks.affiliates && $clientsstats.isAffiliate}
			<div class="col-lg-3 col-sm-6">
				<a href="affiliates.php" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-shopping-cart"></i>
						<div class="tile-content text-success">
							{$clientsstats.numaffiliatesignups}
						</div>
						<small class="text-gray"">{$LANG.affiliatessignups}</small>
					</div>
				</a>
			</div>
			{else}
			<div class="col-lg-3 col-sm-6">
				<a href="clientarea.php?action=quotes" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-file-text-o"></i>
						<div class="tile-content text-warning">
							{$clientsstats.numquotes}
						</div>
						<small class="text-gray"">{$LANG.quotes}</small>
					</div>
				</a>
			</div>
			{/if}
			<div class="col-lg-3 col-sm-6">
				<a href="supporttickets.php" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-comments text-danger"></i>
						<div class="tile-content text-danger">
							{$clientsstats.numactivetickets}
						</div>
						<small class="text-gray"">{$LANG.navtickets}</small>
					</div>  
				</a>
			</div>
			<div class="col-lg-3 col-sm-6">
				<a href="clientarea.php?action=invoices" class="tile-button btn">
					<div class="tile-content-wrapper">
						<i class="fa fa-credit-card text-warning"></i>
						<div class="tile-content text-warning">
							{$clientsstats.numunpaidinvoices}
						</div>
						<small class="text-gray"">{$LANG.navinvoices}</small>
					</div>
				</a>
			</div>
		</div>
	
		{/if}
			
		<div class="row">
			{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
				<div class="col-md-3 pull-md-left">
					{include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
				</div>
			{/if}
        
				<!-- Container for main page display content -->
				<div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}col-md-9 pull-md-right{else}col-xs-12{/if} main-content">

			
		{/if}
		{/if}
		{/if}
		