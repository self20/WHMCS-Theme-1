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
				<h1>{$LANG.orderconfigure}</h1>
				<p>{$LANG.orderForm.configureDesiredOptions}</p>
			</div>					
		</div>
	</div>
</div>


<div class="block-s3">
	<div class="container-fluid">
		<div id="order-standard_cart">

			<div class="row" style="position:relative; z-index:1;">

				<div class="col-md-12">
					
					{include file="orderforms/{$carttpl}/sidebar-categories-collapsed.tpl"}

				</div>

				<div class="col-md-12">

					<form id="frmConfigureProduct">
						<input type="hidden" name="configure" value="true" />
						<input type="hidden" name="i" value="{$i}" />

						<div class="row">
							<div class="col-md-9">

								<h3>{$LANG.orderForm.configureDesiredOptions}</h3>

								<div class="well">
									<h4 class="product-title"><b>{$productinfo.groupname} - {$productinfo.name}</b></h4>													
									<p>{$productinfo.description}</p>
								</div>

								<div class="alert alert-danger hidden" role="alert" id="containerProductValidationErrors">
									<p>{$LANG.orderForm.correctErrors}:</p>
									<ul id="containerProductValidationErrorsList"></ul>
								</div>

								{if $pricing.type eq "recurring"}
									<div class="field-container">
										<div class="form-group">
											<label for="inputBillingcycle">{$LANG.cartchoosecycle}</label>
											<select name="billingcycle" id="inputBillingcycle" class="form-control select-inline" onchange="{if $configurableoptions}updateConfigurableOptions({$i}, this.value);{else}recalctotals();{/if}">
												{if $pricing.monthly}
													<option value="monthly"{if $billingcycle eq "monthly"} selected{/if}>
														{$pricing.monthly}
													</option>
												{/if}
												{if $pricing.quarterly}
													<option value="quarterly"{if $billingcycle eq "quarterly"} selected{/if}>
														{$pricing.quarterly}
													</option>
												{/if}
												{if $pricing.semiannually}
													<option value="semiannually"{if $billingcycle eq "semiannually"} selected{/if}>
														{$pricing.semiannually}
													</option>
												{/if}
												{if $pricing.annually}
													<option value="annually"{if $billingcycle eq "annually"} selected{/if}>
														{$pricing.annually}
													</option>
												{/if}
												{if $pricing.biennially}
													<option value="biennially"{if $billingcycle eq "biennially"} selected{/if}>
														{$pricing.biennially}
													</option>
												{/if}
												{if $pricing.triennially}
													<option value="triennially"{if $billingcycle eq "triennially"} selected{/if}>
														{$pricing.triennially}
													</option>
												{/if}
											</select>
										</div>
									</div>
								{/if}

								{if $productinfo.type eq "server"}
									<div class="sub-heading">
										<span>{$LANG.cartconfigserver}</span>
									</div>

									<div class="field-container">

										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label for="inputHostname">{$LANG.serverhostname}</label>
													<input type="text" name="hostname" class="form-control" id="inputHostname" value="{$server.hostname}" placeholder="servername.yourdomain.com">
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group">
													<label for="inputRootpw">{$LANG.serverrootpw}</label>
													<input type="password" name="rootpw" class="form-control" id="inputRootpw" value="{$server.rootpw}">
												</div>
											</div>
										</div>

										<div class="row">
											<div class="col-sm-6">
												<div class="form-group">
													<label for="inputNs1prefix">{$LANG.serverns1prefix}</label>
													<input type="text" name="ns1prefix" class="form-control" id="inputNs1prefix" value="{$server.ns1prefix}" placeholder="ns1">
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group">
													<label for="inputNs2prefix">{$LANG.serverns2prefix}</label>
													<input type="text" name="ns2prefix" class="form-control" id="inputNs2prefix" value="{$server.ns2prefix}" placeholder="ns2">
												</div>
											</div>
										</div>

									</div>
								{/if}

								{if $configurableoptions}
									<div class="sub-heading">
										<span>{$LANG.orderconfigpackage}</span>
									</div>
									<div class="product-configurable-options" id="productConfigurableOptions">
										<div class="row">
											{foreach $configurableoptions as $num => $configoption}
												{if $configoption.optiontype eq 1}
													<div class="col-sm-12">
														<div class="form-group">
															<label for="inputConfigOption{$configoption.id}">{$configoption.optionname}</label>
															<select name="configoption[{$configoption.id}]" id="inputConfigOption{$configoption.id}" class="form-control">
																{foreach key=num2 item=options from=$configoption.options}
																	<option value="{$options.id}"{if $configoption.selectedvalue eq $options.id} selected="selected"{/if}>
																		{$options.name}
																	</option>
																{/foreach}
															</select>
														</div>
													</div>
												{elseif $configoption.optiontype eq 2}
													<div class="col-sm-12">
														<div class="form-group">
															<label for="inputConfigOption{$configoption.id}">{$configoption.optionname}</label>
															{foreach key=num2 item=options from=$configoption.options}
																<br />
																<label>
																	<input type="radio" name="configoption[{$configoption.id}]" value="{$options.id}"{if $configoption.selectedvalue eq $options.id} checked="checked"{/if} />
																	{if $options.name}
																		{$options.name}
																	{else}
																		{$LANG.enable}
																	{/if}
																</label>
															{/foreach}
														</div>
													</div>
												{elseif $configoption.optiontype eq 3}
													<div class="col-sm-12">
														<div class="form-group">
															<label for="inputConfigOption{$configoption.id}">{$configoption.optionname}</label>
															<br />
															<label>
																<input type="checkbox" name="configoption[{$configoption.id}]" id="inputConfigOption{$configoption.id}" value="1"{if $configoption.selectedqty} checked{/if} />
																{if $configoption.options.0.name}
																	{$configoption.options.0.name}
																{else}
																	{$LANG.enable}
																{/if}
															</label>
														</div>
													</div>
												{elseif $configoption.optiontype eq 4}
													<div class="col-sm-12">
														<div class="form-group">
															<label for="inputConfigOption{$configoption.id}">{$configoption.optionname}</label>
															{if $configoption.qtymaximum}
																{if !$rangesliderincluded}
																	<script type="text/javascript" src="{$BASE_PATH_JS}/ion.rangeSlider.min.js"></script>
																	<link href="{$BASE_PATH_CSS}/ion.rangeSlider.css" rel="stylesheet">
																	<link href="{$BASE_PATH_CSS}/ion.rangeSlider.skinModern.css" rel="stylesheet">
																	{assign var='rangesliderincluded' value=true}
																{/if}
																<input type="text" name="configoption[{$configoption.id}]" value="{if $configoption.selectedqty}{$configoption.selectedqty}{else}{$configoption.qtyminimum}{/if}" id="inputConfigOption{$configoption.id}" class="form-control" />
																<script>
																	var sliderTimeoutId = null;
																	var sliderRangeDifference = {$configoption.qtymaximum} - {$configoption.qtyminimum};
																	// The largest size that looks nice on most screens.
																	var sliderStepThreshold = 25;
																	// Check if there are too many to display individually.
																	var setLargerMarkers = sliderRangeDifference > sliderStepThreshold;

																	jQuery("#inputConfigOption{$configoption.id}").ionRangeSlider({
																		min: {$configoption.qtyminimum},
																		max: {$configoption.qtymaximum},
																		grid: true,
																		grid_snap: setLargerMarkers ? false : true,
																		onChange: function() {
																			if (sliderTimeoutId) {
																				clearTimeout(sliderTimeoutId);
																			}

																			sliderTimeoutId = setTimeout(function() {
																				sliderTimeoutId = null;
																				recalctotals();
																			}, 250);
																		}
																	});
																</script>
															{else}
																<div>
																	<input type="number" name="configoption[{$configoption.id}]" value="{if $configoption.selectedqty}{$configoption.selectedqty}{else}{$configoption.qtyminimum}{/if}" id="inputConfigOption{$configoption.id}" min="{$configoption.qtyminimum}" onchange="recalctotals()" onkeyup="recalctotals()" class="form-control form-control-qty" />
																	<span class="form-control-static form-control-static-inline">
																		x {$configoption.options.0.name}
																	</span>
																</div>
															{/if}
														</div>
													</div>
												{/if}
												{if $num % 2 != 0}
													</div>
													<div class="row">
												{/if}
											{/foreach}
										</div>
									</div>

								{/if}

								{if $customfields}

									<div class="sub-heading">
										<span>{$LANG.orderadditionalrequiredinfo}</span>
									</div>

									<div class="field-container">
										{foreach $customfields as $customfield}
											<div class="form-group">
												<label for="customfield{$customfield.id}">{$customfield.name}</label>
												{$customfield.input}
												{if $customfield.description}
													<span class="field-help-text">
														{$customfield.description}
													</span>
												{/if}
											</div>
										{/foreach}
									</div>

								{/if}

								{if $addons || count($addonsPromoOutput) > 0}

									<div class="sub-heading">
										<span>{$LANG.cartavailableaddons}</span>
									</div>

									{foreach $addonsPromoOutput as $output}
										<div>
											{$output}
										</div>
									{/foreach}
									
									
									<div class="row addon-products">
										{foreach $addons as $addon}
											<div class="col-sm-12">
												<div class="panel panel-default effect3 panel-addon{if $addon.status} panel-addon-selected{/if}">
													<div class="panel-body">
														<label>
															<input type="checkbox" name="addons[{$addon.id}]"{if $addon.status} checked{/if} />
															{$addon.name}
														</label><br />
														{$addon.description}
													</div>
													<div class="panel-price">
														{$addon.pricing}
													</div>
													<div class="panel-add">
														<i class="fa fa-plus"></i>
														{$LANG.addtocart}
													</div>
												</div>
											</div>
										{/foreach}
									</div>

								{/if}

								<div class="alert alert-warning text-center">
									<i class="fa fa-question-circle"></i>
									{$LANG.orderForm.haveQuestionsContact} <a href="contact.php" target="_blank" class="alert-link">{$LANG.orderForm.haveQuestionsClickHere}</a>
								</div>

							</div>
							<div class="col-md-3" id="scrollingPanelContainer">

								<div id="orderSummary">
									<div class="order-summary">
										<div class="loader" id="orderSummaryLoader">
											<i class="fa fa-fw fa-refresh fa-spin"></i>
										</div>
										<h2>{$LANG.ordersummary}</h2>
										<div class="summary-container" id="producttotal"></div>
									</div>
									<div class="text-center">
										 <button type="submit" id="btnCompleteProductConfig" class="btn btn-primary btn-lg">
											{$LANG.continue}
											<i class="fa fa-arrow-circle-right"></i>
										</button>
									</div>
								</div>

							</div>

						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</div>


<script language="javascript">
	recalctotals();
</script>