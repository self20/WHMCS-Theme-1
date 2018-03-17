{include file="orderforms/{$carttpl}/common.tpl"}

<div class="mass-head">
	<div class="block-s5 no-padding-top hero-bg-wrap style-2 bg-opacity">
		<div class="container-fluid">		
			<div class="page-title">
				<h1><i class="fa fa-globe"></i> {$LANG.navdomainsearch}</h1>
				<p>{$LANG.orderForm.findNewDomain}</p>
				<div class="space-32 visible-xs"></div>
			</div>
		</div>
	</div>
</div>


<!--Domain Section-->
<div class="block-s3 margin-up light no-padding-bottom">
	<div class="container-fluid">	
		<div class="Redo-pricing-container">
					
			<div class="pricing-box">
				<div class="slide-item">
					<div class="Redo-pricing-table no-animation no-margin-bottom">
						<div class="domain-hero block-s3">
							<!--Domain Search Input Box-->
							<form method="post" action="cart.php" id="frmDomainChecker">
								<input type="hidden" name="a" value="checkDomain">
								<div class="input-group">
									<input type="hidden" name="direct" value="true" />
									<input type="text" name="domain" class="form-control search-query input-lg" placeholder="{$LANG.findyourdomain}" value="{$lookupTerm}" id="inputDomain" data-toggle="tooltip" data-placement="left" data-trigger="manual" title="{lang key='orderForm.domainOrKeyword'}" />
									<span class="input-group-btn">
										<button type="submit"  id="btnCheckAvailability" class="btn btn-lg btn-secondary no-margin domain-check-availability" style="width: auto;">
											<span class="visible-xs"><i class="fa fa-search icon-only"></i></span> <span class="hidden-xs">{$LANG.search}</span>
										</button>
									</span>
								</div>
								
								
								{if $captcha}
									<div id="order-standard_cart" class="no-padding-bottom">
										<div class="captcha-container" id="captchaContainer">
											{if $captcha == "recaptcha"}
												<script src="https://www.google.com/recaptcha/api.js" async defer></script>
												<div id="google-recaptcha" class="g-recaptcha center-block" data-sitekey="{$reCaptchaPublicKey}" data-toggle="tooltip" data-placement="left" data-trigger="manual" title="{lang key='orderForm.required'}" /></div>
											{else}
												<div class="default-captcha default-captcha-register-margin">
													<p>{lang key="cartSimpleCaptcha"}</p>
													<div>
														<img id="inputCaptchaImage" src="includes/verifyimage.php" align="middle" />
														<input id="inputCaptcha" type="text" name="code" maxlength="5" class="form-control input-sm" data-toggle="tooltip" data-placement="right" data-trigger="manual" title="{lang key='orderForm.required'}" />
													</div>
												</div>
											{/if}
										</div>
									</div>
								{/if}
								
								
							</form>
							<!--End Domain Search Input Box-->
						</div>
						
						<div id="order-standard_cart">
							<div class="">
								<div class="row">	
									<div class="col-md-12">  
										<div id="DomainSearchResults" class="hidden">
											<div class="container">
												<div id="searchDomainInfo" class="domain-checker-result-headline">
													<p id="primaryLookupSearching" class="domain-lookup-loader domain-lookup-primary-loader domain-searching"><i class="fa fa-spinner fa-spin"></i> {lang key='orderForm.searching'}...</p>
													<div id="primaryLookupResult" class="domain-lookup-result hidden">
														<p class="domain-invalid domain-checker-invalid">{lang key='orderForm.domainLetterOrNumber'}<span class="domain-length-restrictions">{lang key='orderForm.domainLengthRequirements'}</span></p>
														<p class="domain-unavailable domain-checker-unavailable">{lang key='orderForm.domainIsUnavailable'}</p>
														<p class="domain-available domain-checker-available">{$LANG.domainavailable1} <strong></strong> {$LANG.domainavailable2}</p>
														<a class="domain-contact-support btn btn-primary">{$LANG.domainContactUs}</a>
														<p class="domain-price">
															<span class="price"></span>
															<button class="btn btn-primary btn-add-to-cart no-margin-top" data-whois="0" data-domain="">
																<span class="to-add">{$LANG.addtocart}</span>
																<span class="added"><i class="glyphicon glyphicon-shopping-cart"></i> {lang key='checkout'}</span>
																<span class="unavailable">{$LANG.domaincheckertaken}</span>
															</button>
														</p>
													</div>
												</div>

												{if $spotlightTlds}
													<div id="spotlightTlds" class="spotlight-tlds clearfix">
														<div class="spotlight-tlds-container">
															{foreach $spotlightTlds as $key => $data}
																<div class="spotlight-tld-container spotlight-tld-container-{$spotlightTlds|count}">
																	<div id="spotlight{$data.tldNoDots}" class="spotlight-tld">
																		{if $data.group}
																			<div class="spotlight-tld-{$data.group}">{$data.groupDisplayName}</div>
																		{/if}
																		{$data.tld}
																		<span class="domain-lookup-loader domain-lookup-spotlight-loader">
																			<i class="fa fa-spinner fa-spin"></i>
																		</span>
																		<div class="domain-lookup-result">
																			<button type="button" class="btn unavailable hidden" disabled="disabled">
																				{lang key='domainunavailable'}
																			</button>
																			<button type="button" class="btn invalid hidden" disabled="disabled">
																				{lang key='domainunavailable'}
																			</button>
																			<span class="available price hidden">{$data.register}</span>
																			<button type="button" class="btn hidden btn-add-to-cart no-margin-top" data-whois="0" data-domain="">
																				<span class="to-add">{lang key='orderForm.add'}</span>
																				<span class="added"><i class="glyphicon glyphicon-shopping-cart"></i> {lang key='checkout'}</span>
																				<span class="unavailable">{$LANG.domaincheckertaken}</span>
																			</button>
																			<button type="button" class="btn btn-primary domain-contact-support hidden">
																				{lang key='domainChecker.contactSupport'}
																			</button>
																		</div>
																	</div>
																</div>
															{/foreach}
														</div>
													</div>
												{/if}
											
											</div>
											
											
											<div class="suggested-domains{if !$showSuggestionsContainer} hidden{/if}">
												<div class="panel-heading">
													{lang key='orderForm.suggestedDomains'}
												</div>
												<div id="suggestionsLoader" class="panel-body domain-lookup-loader domain-lookup-suggestions-loader">
													<i class="fa fa-spinner fa-spin"></i> {lang key='orderForm.generatingSuggestions'}
												</div>
												<ul id="domainSuggestions" class="domain-lookup-result hidden">
													<li class="domain-suggestion hidden">
														<div class="resulted-domains">
															<span class="domain"></span><span class="extension"></span> 
															<span class="promo hidden">
																<span class="sales-group-hot hidden">{lang key='domainCheckerSalesGroup.hot'}</span>
																<span class="sales-group-new hidden">{lang key='domainCheckerSalesGroup.new'}</span>
																<span class="sales-group-sale hidden">{lang key='domainCheckerSalesGroup.sale'}</span>
															</span>
														</div>														
														<div class="resulted-domain-actions">
																
															<button type="button" class="btn btn-add-to-cart" data-whois="1" data-domain="">
																<span class="to-add">{$LANG.addtocart}</span>
																<span class="added"><i class="glyphicon glyphicon-shopping-cart"></i> {lang key='checkout'}</span>
																<span class="unavailable">{$LANG.domaincheckertaken}</span>
															</button>
															
															<button type="button" class="btn btn-primary domain-contact-support hidden">
																{lang key='domainChecker.contactSupport'}
															</button>
															
															<span class="price"></span>
														</div>
														
														<div class="clearfix"></div>
													</li>
												</ul>
												<div class="panel-footer more-suggestions hidden text-center">
													<a id="moreSuggestions" href="#" onclick="loadMoreSuggestions();return false;">{lang key='domainsmoresuggestions'}</a>
													<span id="noMoreSuggestions" class="no-more small hidden">{lang key='domaincheckernomoresuggestions'}</span>
												</div>
												<div class="text-center text-muted domain-suggestions-warning">
													<p>{lang key='domainssuggestionswarnings'}</p>
												</div>
											</div>

										</div>
									</div>			
								</div>		
							</div>
							
							<div class="domain-pricing">

								{if $featuredTlds}
									<div class="featured-tlds-container">
										<div class="row">
											{foreach $featuredTlds as $num => $tldinfo}
												{if $num % 3 == 0 && (count($featuredTlds) - $num < 3)}
													{if count($featuredTlds) - $num == 2}
														<div class="col-sm-2"></div>
													{else}
														<div class="col-sm-4"></div>
													{/if}
												{/if}
												<div class="col-sm-4 col-xs-6">
													<div class="featured-tld">
														<div class="img-container">
															<img src="{$BASE_PATH_IMG}/tld_logos/{$tldinfo.tldNoDots}.png">
														</div>
														<div class="price {$tldinfo.tldNoDots}">
															{if is_object($tldinfo.register)}
																{$tldinfo.register->toPrefixed()}{if $tldinfo.period > 1}{lang key="orderForm.shortPerYears" years={$tldinfo.period}}{else}{lang key="orderForm.shortPerYear" years=''}{/if}
															{else}
																N/A
															{/if}</div>
													</div>
												</div>
											{/foreach}
										</div>
									</div>
								{/if}

								<h4>{lang key='pricing.browseExtByCategory'}</h4>

								<div class="tld-filters">
									{foreach $categoriesWithCounts as $category => $count}
										<a href="#" data-category="{$category}" class="label label-default">{$category} ({$count})</a>
									{/foreach}
								</div>

								<div class="row tld-pricing-header text-center">
									<div class="col-sm-4 no-bg">{lang key='orderdomain'}</div>
									<div class="col-sm-8">
										<div class="row">
											<div class="col-xs-4">{lang key='pricing.register'}</div>
											<div class="col-xs-4">{lang key='pricing.transfer'}</div>
											<div class="col-xs-4">{lang key='pricing.renewal'}</div>
										</div>
									</div>
								</div>
								{foreach $pricing['pricing'] as $tld => $price}
									<div class="row tld-row" data-category="{foreach $price.categories as $category}|{$category}|{/foreach}">
										<div class="col-sm-4 two-row-center">
											<strong>.{$tld}</strong>
											{if $price.group}
												<span class="tld-sale-group tld-sale-group-{$price.group}">{$price.group}!</span>
											{/if}
										</div>
										<div class="col-sm-8">
											<div class="row">
												<div class="col-xs-4 text-center">
													{if current($price.register) >= 0}
														{current($price.register)}<br>
														<small>{key($price.register)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
													{else}
														<small>N/A</small>
													{/if}
												</div>
												<div class="col-xs-4 text-center">
													{if current($price.transfer) > 0}
														{current($price.transfer)}<br>
														<small>{key($price.transfer)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
													{else}
														<small>N/A</small>
													{/if}
												</div>
												<div class="col-xs-4 text-center">
													{if current($price.renew) > 0}
														{current($price.renew)}<br>
														<small>{key($price.renew)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
													{else}
														<small>N/A</small>
													{/if}
												</div>
											</div>
										</div>
									</div>
								{/foreach}
								<div class="row tld-row no-tlds">
									<div class="col-xs-12 text-center">
										<br>
										{lang key='pricing.selectExtCategory'}
										<br><br>
									</div>
								</div>

							</div>
						</div>
						
							
						<div class="clearfix padding-all no-padding-bottom">												
							{if !$loggedin && $currencies}
							<div class=" pull-right form-inline">
								<form method="post" action="domainchecker.php" class="form-horizontal">
									{$LANG.choosecurrency}: <select class="input-sm" name="currency" onchange="submit()" style="width:76px;">
									{foreach from=$currencies item=curr}
										<option value="{$curr.id}"{if $curr.id eq $currency.id} selected="selected"{/if}>{$curr.code}</option>
									{/foreach}
									</select>
								</form>
							</div>
							{/if}					
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>			
</div>
			
			
<div class="block-s3 padding4x sec-img-bg bg-opacity margin-up-80" style="background-image: url({$WEB_ROOT}/templates/{$template}/assets/images/sec-bg2.jpg);">
	<div class="container-fluid">
	
		<div class="space-36"></div>
		
		<div class="row">
			<div class="{if $domainTransferEnabled}col-md-6{else}col-md-8 col-md-offset-2{/if}">
				
				<div class="domain-promo-box no-border no-padding no-margin" style="background-color: transparent;">
				<div class="Redo-dark-box block text-white">

					<div class="clearfix">
						<i class="fa fa-server fa-5x"></i>
						<h3>{lang key='orderForm.addHosting'}</h3>
						<p class="font-bold text-secondary">{lang key='orderForm.chooseFromRange'}</p>
					</div>

					<p>{lang key='orderForm.packagesForBudget'}</p>

					<a href="cart.php" class="btn btn-secondary">
						{lang key='orderForm.exploreNow'}
					</a>
				</div>
				</div>
			</div>
			{if $domainTransferEnabled}
				<div class="col-md-6">
					<div class="domain-promo-box no-border no-padding no-margin" style="background-color: transparent;">
					<div class="Redo-dark-box block text-white">

						<div class="clearfix">
							<i class="fa fa-globe fa-5x"></i>
							<h3>{lang key='orderForm.transferToUs'}</h3>
							<p class="font-bold text-primary">{lang key='orderForm.transferExtend'}*</p>
						</div>

						<a href="cart.php?a=add&domain=transfer" class="btn btn-primary">
							{lang key='orderForm.transferDomain'}
						</a>

						<p class="small">* {lang key='orderForm.extendExclusions'}</p>
					</div>
					</div>
				</div>
			{/if}
		</div>
		

	</div>
</div>

<script>
	jQuery(document).ready(function() {
		jQuery('.tld-filters a:first-child').click();
	{if $lookupTerm && !$captchaError}
		jQuery('#btnCheckAvailability').click();
	{/if}
	});
</script>
