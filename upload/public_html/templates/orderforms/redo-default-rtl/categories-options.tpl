<!-- Modal For Options -->
	<div class="modal fade" id="cat-opt" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times"></i></button>
					<h4 class="modal-title" id="myModalLabel">{$LANG.cartproductchooseoptions}</h4>
				</div>
				<div class="modal-body">
				
					<div class="categories-collapsed clearfix hidden-xs">

						<div class="pull-left form-inline">
							<form method="get" action="{$smarty.server.PHP_SELF}">
								<select name="gid" onchange="submit()" class="form-control">
									<optgroup label="Product Categories">
										{foreach key=num item=productgroup from=$productgroups}
											<option value="{$productgroup.gid}"{if $gid eq $productgroup.gid} selected="selected"{/if}>{$productgroup.name}</option>
										{/foreach}
									</optgroup>
									<optgroup label="Actions">
										{if $loggedin}
											<option value="addons"{if $gid eq "addons"} selected{/if}>{$LANG.cartproductaddons}</option>
											{if $renewalsenabled}
												<option value="renewals"{if $gid eq "renewals"} selected{/if}>{$LANG.domainrenewals}</option>
											{/if}
										{/if}
										{if $registerdomainenabled}
											<option value="registerdomain"{if $domain eq "register"} selected{/if}>{$LANG.navregisterdomain}</option>
										{/if}
										{if $transferdomainenabled}
											<option value="transferdomain"{if $domain eq "transfer"} selected{/if}>{$LANG.transferinadomain}</option>
										{/if}
										<option value="viewcart"{if $action eq "view"} selected{/if}>{$LANG.viewcart}</option>
									</optgroup>
								</select>
							</form>
						</div>

						{if !$loggedin && $currencies}
							<div class="pull-right form-inline">
								<form method="post" action="cart.php{if $action}?a={$action}{elseif $gid}?gid={$gid}{/if}">
									<select name="currency" onchange="submit()" class="form-control">
										<option value="">{$LANG.choosecurrency}</option>
										{foreach from=$currencies item=curr}
											<option value="{$curr.id}">{$curr.code}</option>
										{/foreach}
									</select>
								</form>
							</div>
						{/if}

					</div>

					<div class="categories-collapsed visible-xs">

						<div class="form-inline">
							<form method="get" action="{$smarty.server.PHP_SELF}">
								<select name="gid" onchange="submit()" class="form-control">
									<optgroup label="Product Categories">
										{foreach key=num item=productgroup from=$productgroups}
											<option value="{$productgroup.gid}"{if $gid eq $productgroup.gid} selected="selected"{/if}>{$productgroup.name}</option>
										{/foreach}
									</optgroup>
									<optgroup label="Actions">
										{if $loggedin}
											<option value="addons"{if $gid eq "addons"} selected{/if}>{$LANG.cartproductaddons}</option>
											{if $renewalsenabled}
												<option value="renewals"{if $gid eq "renewals"} selected{/if}>{$LANG.domainrenewals}</option>
											{/if}
										{/if}
										{if $registerdomainenabled}
											<option value="registerdomain"{if $domain eq "register"} selected{/if}>{$LANG.navregisterdomain}</option>
										{/if}
										{if $transferdomainenabled}
											<option value="transferdomain"{if $domain eq "transfer"} selected{/if}>{$LANG.transferinadomain}</option>
										{/if}
										<option value="viewcart"{if $action eq "view"} selected{/if}>{$LANG.viewcart}</option>
									</optgroup>
								</select>
							</form>
						</div>
						
						<hr class="separator" />
						
						{if !$loggedin && $currencies}
							<div class="form-inline">
								<form method="post" action="cart.php{if $action}?a={$action}{elseif $gid}?gid={$gid}{/if}">
									<select name="currency" onchange="submit()" class="form-control">
										<option value="">{$LANG.choosecurrency}</option>
										{foreach from=$currencies item=curr}
											<option value="{$curr.id}">{$curr.code}</option>
										{/foreach}
									</select>
								</form>
							</div>
						{/if}

					</div>
					
				</div>

			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
<!-- Modal For Options -->