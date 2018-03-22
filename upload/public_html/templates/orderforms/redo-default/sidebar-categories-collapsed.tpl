<div class="categories-collapsed clearfix">

    <div class="pull-left form-inline">
        <form method="get" action="{$smarty.server.PHP_SELF}">
			<div class="form-group">
				<select name="gid" onchange="submit()" class="form-control field">
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
				
			</div>
        </form>
    </div>

    {if !$loggedin && $currencies}
        <div class="pull-right form-inline">
            <form method="post" action="cart.php{if $action}?a={$action}{elseif $gid}?gid={$gid}{/if}">
				<div class="form-group">
					<select name="currency" onchange="submit()" class="form-control field">
						<option value="">{$LANG.choosecurrency}</option>
						{foreach from=$currencies item=listcurr}
							<option value="{$listcurr.id}"{if $listcurr.id == $currency.id} selected{/if}>{$listcurr.code}</option>
						{/foreach}
					</select>
				</div>
            </form>
        </div>
    {/if}

</div>
