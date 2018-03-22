{include file="orderforms/{$carttpl}/common.tpl"}

<script>
var _localLang = {
    'addToCart': '{$LANG.orderForm.addToCart|escape}',
    'addedToCartRemove': '{$LANG.orderForm.addedToCartRemove|escape}'
}
</script>


<div class="mass-head">
	<div class="hero-bg-wrap style-2 bg-opacity">
		<div class="container-fluid">		
			<div class="page-title">
				<h1>{$LANG.cartdomainsconfig}</h1>
			</div>					
		</div>
	</div>
</div>


<div class="block-s3">
	<div class="container-fluid">
		<div id="order-standard_cart">

			<div class="row">

				<div class="col-md-12">
					
					{include file="orderforms/{$carttpl}/sidebar-categories-collapsed.tpl"}

				</div>

				<div class="col-md-12">

					

					<form method="post" action="{$smarty.server.PHP_SELF}?a=confdomains" id="frmConfigureDomains">
						<input type="hidden" name="update" value="true" />

						
						<h4 class="hidden-xs">{$LANG.orderForm.reviewDomainAndAddons}</h4>
						<p class="visible-xs">{$LANG.orderForm.reviewDomainAndAddons}</p>
						

						{if $errormessage}
							<div class="alert alert-danger" role="alert">
								<p>{$LANG.orderForm.correctErrors}:</p>
								<ul>
									{$errormessage}
								</ul>
							</div>
						{/if}

						{foreach $domains as $num => $domain}

							<div class="sub-heading">
								<span>{$domain.domain}</span>
							</div>

							<div class="row">
								<div class="col-sm-12">
									<div class="form-group hidden-xs">
										<label>{$LANG.orderregperiod}:</label>
										{$domain.regperiod} {$LANG.orderyears} {if $domain.hosting}{else}<a href="cart.php" style="color:#cc0000;">[{$LANG.cartdomainsnohosting}]</a>{/if}
									</div>
									<div class="form-group visible-xs">
										<label>{$LANG.orderregperiod}:</label>
										{$domain.regperiod} {$LANG.orderyears}<br /> {if $domain.hosting}{else}<a href="cart.php" style="color:#cc0000;">[{$LANG.cartdomainsnohosting}]</a>{/if}
									</div>
								</div>
							</div>
							
							
							<div class="row">
								{if $domain.eppenabled}
									<div class="col-sm-12">
										<div class="form-group prepend-icon">
											<input type="text" name="epp[{$num}]" id="inputEppcode{$num}" value="{$domain.eppvalue}" class="field" placeholder="{$LANG.domaineppcode}" />
											<label for="inputEppcode{$num}" class="field-icon">
												<i class="fa fa-lock"></i>
											</label>
											<span class="field-help-text">
												{$LANG.domaineppcodedesc}
											</span>
										</div>
									</div>
								{/if}
							</div>
							
							{if $domain.dnsmanagement || $domain.emailforwarding || $domain.idprotection}
							
								<div class="row addon-products">
									<div class="col-md-10 col-md-offset-1">
										<div class="row">

											{if $domain.dnsmanagement}
												<div class="col-sm-{math equation="12 / numAddons" numAddons=$domain.addonsCount}">
													<div class="panel panel-default panel-addon{if $domain.dnsmanagementselected} panel-addon-selected{/if}">
														<div class="panel-body">
															<label>
																<input type="checkbox" name="dnsmanagement[{$num}]"{if $domain.dnsmanagementselected} checked{/if} />
																{$LANG.domaindnsmanagement}
															</label><br />
															{$LANG.domainaddonsdnsmanagementinfo}
														</div>
														<div class="panel-price">
															{$domain.dnsmanagementprice} / {$domain.regperiod} {$LANG.orderyears}
														</div>
														<div class="panel-add">
															<i class="fa fa-plus"></i>
															{$LANG.orderForm.addToCart}
														</div>
													</div>
												</div>
											{/if}

											{if $domain.idprotection}
												<div class="col-sm-{math equation="12 / numAddons" numAddons=$domain.addonsCount}">
													<div class="panel panel-default panel-addon{if $domain.idprotectionselected} panel-addon-selected{/if}">
														<div class="panel-body">
															<label>
																<input type="checkbox" name="idprotection[{$num}]"{if $domain.idprotectionselected} checked{/if} />
																{$LANG.domainidprotection}
																</label><br />
															{$LANG.domainaddonsidprotectioninfo}
														</div>
														<div class="panel-price">
															{$domain.idprotectionprice} / {$domain.regperiod} {$LANG.orderyears}
														</div>
														<div class="panel-add">
															<i class="fa fa-plus"></i>
															{$LANG.orderForm.addToCart}
														</div>
													</div>
												</div>
											{/if}

											{if $domain.emailforwarding}
												<div class="col-sm-{math equation="12 / numAddons" numAddons=$domain.addonsCount}">
													<div class="panel panel-default panel-addon{if $domain.emailforwardingselected} panel-addon-selected{/if}">
														<div class="panel-body">
															<label>
																<input type="checkbox" name="emailforwarding[{$num}]"{if $domain.emailforwardingselected} checked{/if} />
																{$LANG.domainemailforwarding}
															</label><br />
															{$LANG.domainaddonsemailforwardinginfo}
														</div>
														<div class="panel-price">
															{$domain.emailforwardingprice} / {$domain.regperiod} {$LANG.orderyears}
														</div>
														<div class="panel-add">
															<i class="fa fa-plus"></i>
															{$LANG.orderForm.addToCart}
														</div>
													</div>
												</div>
											{/if}

										</div>
									</div>
								</div>
							{/if}
							{foreach from=$domain.fields key=domainfieldname item=domainfield}
								<div class="row">
									<div class="col-sm-4">{$domainfieldname}:</div>
									<div class="col-sm-8">{$domainfield}</div>
								</div>
							{/foreach}

						{/foreach}

						{if $atleastonenohosting}

							<div class="sub-heading">
								<span>{$LANG.domainnameservers}</span>
							</div>

							<p>{$LANG.cartnameserversdesc}</p>
							
							<div class="well">
								<div class="row">
									<div class="col-sm-4">
										<div class="form-group">
											<label for="inputNs1">{$LANG.domainnameserver1}</label>
											<input type="text" class="form-control" id="inputNs1" name="domainns1" value="{$domainns1}" />
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="inputNs2">{$LANG.domainnameserver2}</label>
											<input type="text" class="form-control" id="inputNs2" name="domainns2" value="{$domainns2}" />
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="inputNs3">{$LANG.domainnameserver3}</label>
											<input type="text" class="form-control" id="inputNs3" name="domainns3" value="{$domainns3}" />
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="inputNs1">{$LANG.domainnameserver4}</label>
											<input type="text" class="form-control" id="inputNs4" name="domainns4" value="{$domainns4}" />
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="inputNs5">{$LANG.domainnameserver5}</label>
											<input type="text" class="form-control" id="inputNs5" name="domainns5" value="{$domainns5}" />
										</div>
									</div>
								</div>
							</div>

						{/if}

						<div class="text-center padding-all">
							<button type="submit" class="btn btn-primary btn-lg">
								{$LANG.continue}
								&nbsp;<i class="fa fa-arrow-circle-right"></i>
							</button>
						</div>

					</form>
				</div>
			</div>
		</div>
		
	</div>
</div>
