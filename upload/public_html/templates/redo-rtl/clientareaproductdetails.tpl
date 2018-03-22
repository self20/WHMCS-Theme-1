{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}

{if $modulecustombuttonresult}
    {if $modulecustombuttonresult == "success"}
        {include file="$template/includes/alert.tpl" type="success" msg=$LANG.moduleactionsuccess textcenter=true idname="alertModuleCustomButtonSuccess"}
    {else}
         {include file="$template/includes/alert.tpl" type="error" msg=$LANG.moduleactionfailed|cat:' ':$modulecustombuttonresult textcenter=true idname="alertModuleCustomButtonFailed"}
    {/if}
{/if}

{if $pendingcancellation}
    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.cancellationrequestedexplanation textcenter=true idname="alertPendingCancellation"}
{/if}

<div class="tab-content margin-bottom">
    <div class="tab-pane fade in active" id="tabOverview">

        {if $tplOverviewTabOutput}
			{$tplOverviewTabOutput}
        {else}

		
		
		
		
		
		
			<div>
				<div class="product-details clearfix">

					<div class="row">
						<div class="col-md-6">

							<div class="product-status product-status-{$rawstatus|strtolower}">
								<div class="product-icon text-center">
									<span class="fa-stack fa-lg">
										<i class="fa fa-circle fa-stack-2x"></i>
										<i class="fa fa-{if $type eq "hostingaccount" || $type == "reselleraccount"}hdd-o{elseif $type eq "server"}database{else}archive{/if} fa-stack-1x fa-inverse"></i>
									</span>
									<h3>{$product}</h3>
									<h4>{$groupname}</h4>
								</div>
								<div class="product-status-text">
									{$status}
								</div>
							</div>

							{if $showcancelbutton || $packagesupgrade}
								<div class="row">
									{if $packagesupgrade}
										<div class="col-xs-{if $showcancelbutton}6{else}12{/if}">
											<a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-block btn-primary">{$LANG.upgrade}</a>
										</div>
									{/if}
									{if $showcancelbutton}
										<div class="col-xs-{if $packagesupgrade}6{else}12{/if}">
											<a href="clientarea.php?action=cancel&amp;id={$id}" class="btn btn-block btn-danger {if $pendingcancellation}disabled{/if}">{if $pendingcancellation}{$LANG.cancellationrequested}{else}{$LANG.clientareacancelrequestbutton}{/if}</a>
										</div>
									{/if}
								</div>
							{/if}

						</div>
						<div class="col-md-6">

							<h5 class="heading"><strong>{$LANG.clientareahostingregdate}</strong></h5>
							<div class="well well-sm">{$regdate}</div>

							{if $firstpaymentamount neq $recurringamount}
								<h5 class="heading"><strong>{$LANG.firstpaymentamount}</strong></h5>
								<div class="well well-sm">{$firstpaymentamount}</div>
							{/if}

							{if $billingcycle != $LANG.orderpaymenttermonetime && $billingcycle != $LANG.orderfree}
								<h5 class="heading"><strong>{$LANG.recurringamount}</strong></h5>
								<div class="well well-sm">{$recurringamount}</div>
							{/if}

							<h5 class="heading"><strong>{$LANG.orderbillingcycle}</strong></h5>
							<div class="well well-sm">{$billingcycle}</div>
							
							{if $nextduedate == '-'}{else}
							<h5 class="heading"><strong>{$LANG.clientareahostingnextduedate}</strong></h5>
							<div class="well well-sm">{$nextduedate}</div>
							{/if}

							<h5 class="heading"><strong>{$LANG.orderpaymentmethod}</strong></h5>
							<div class="well well-sm">{$paymentmethod}</div>

						</div>
					</div>

				</div>
			</div>
			
		{if $systemStatus == 'Active'}
		



            {foreach $hookOutput as $output}
				<div class="portlet padding-all">
					<div>
						{$output}
					</div>
				</div>
            {/foreach}

            {if $domain || $moduleclientarea || $configurableoptions || $customfields || $lastupdate}
				<div class="tc-tabs">
					<div class="row clearfix">
						<div class="col-xs-12">
							<ul class="nav nav-tabs nav-tabs-overflow no-margin-bottom">
								{if $domain}
									<li class="active">
										<a href="#domain" data-toggle="tab"><i class="fa fa-globe fa-fw"></i> {if $type eq "server"}{$LANG.sslserverinfo}{elseif ($type eq "hostingaccount" || $type eq "reselleraccount") && $serverdata}{$LANG.hostingInfo}{else}{$LANG.clientareahostingdomain}{/if}</a>
									</li>
								{elseif $moduleclientarea}
									<li class="active">
										<a href="#manage" data-toggle="tab"><i class="fa fa-globe fa-fw"></i> {$LANG.manage}</a>
									</li>
								{/if}
								{if $configurableoptions}
									<li{if !$domain && !$moduleclientarea} class="active"{/if}>
										<a href="#configoptions" data-toggle="tab"><i class="fa fa-cubes fa-fw"></i> {$LANG.orderconfigpackage}</a>
									</li>
								{/if}
								{if $customfields}
									<li{if !$domain && !$moduleclientarea && !$configurableoptions} class="active"{/if}>
										<a href="#additionalinfo" data-toggle="tab"><i class="fa fa-info fa-fw"></i> {$LANG.additionalInfo}</a>
									</li>
								{/if}
								{if $lastupdate}
									<li{if !$domain && !$moduleclientarea && !$configurableoptions && !$customfields} class="active"{/if}>
										<a href="#resourceusage" data-toggle="tab"><i class="fa fa-inbox fa-fw"></i> {$LANG.resourceUsage}</a>
									</li>
								{/if}
							</ul>
						</div>
					</div>
					<div class="tab-content product-details-tab-container">
						{if $domain}
							<div class="tab-pane fade in active" id="domain">
							
								{if $username || $password}
									<div class="well well-sm">
										<button type="button" class="btn btn-info" data-toggle="modal" data-target="#LoginCredentials">{$LANG.serverlogindetails}</button>
									</div>
								{/if}
								
								{if $type eq "server"}
									<h5 class="heading"><strong>{$LANG.serverhostname}</strong></h5>
									<div class="well well-sm">
										{$domain}
									</div>

									{if $dedicatedip}
										<h5 class="heading"><strong>{$LANG.primaryIP}</strong></h5>
										<div class="well well-sm">
											{$dedicatedip}
										</div>
									{/if}
									{if $assignedips}
										<h5 class="heading"><strong>{$LANG.assignedIPs}</strong></h5>
										<div class="well well-sm">
											{$assignedips|nl2br}
										</div>
									{/if}
									{if $ns1 || $ns2}
										<h5 class="heading"><strong>{$LANG.domainnameservers}</strong></h5>
										<div class="well well-sm">
											{$ns1}<br />{$ns2}
										</div>
									{/if}
								{elseif ($type eq "hostingaccount" || $type eq "reselleraccount") && $serverdata}
									{if $domain}
										<h5 class="heading"><strong>{$LANG.orderdomain}</strong></h5>
										<div class="well well-sm">
											{$domain}&nbsp;<a href="http://{$domain}" target="_blank" class="btn btn-default btn-xs" >{$LANG.visitwebsite}</a>
										</div>
									{/if}
									{if $username}
										<h5 class="heading"><strong>{$LANG.serverusername}</strong></h5>
										<div class="well well-sm">
											{$username}
										</div>
									{/if}
									<h5 class="heading"><strong>{$LANG.servername}</strong></h5>
									<div class="well well-sm">
										{$serverdata.hostname}
									</div>
									<h5 class="heading"><strong>{$LANG.domainregisternsip}</strong></h5>
									<div class="well well-sm">
										{$serverdata.ipaddress}
									</div>
									{if $serverdata.nameserver1 || $serverdata.nameserver2 || $serverdata.nameserver3 || $serverdata.nameserver4 || $serverdata.nameserver5}	
										<h5 class="heading"><strong>{$LANG.domainnameservers}</strong></h5>
										<div class="well well-sm">
											{if $serverdata.nameserver1}{$serverdata.nameserver1} ({$serverdata.nameserver1ip})<br />{/if}
											{if $serverdata.nameserver2}{$serverdata.nameserver2} ({$serverdata.nameserver2ip})<br />{/if}
											{if $serverdata.nameserver3}{$serverdata.nameserver3} ({$serverdata.nameserver3ip})<br />{/if}
											{if $serverdata.nameserver4}{$serverdata.nameserver4} ({$serverdata.nameserver4ip})<br />{/if}
											{if $serverdata.nameserver5}{$serverdata.nameserver5} ({$serverdata.nameserver5ip})<br />{/if}
										</div>
									{/if}
								{else}
									<div class="well well-sm">
										{$domain}
									</div>
									<div class="well well-sm">
										<a href="http://{$domain}" class="btn btn-default" target="_blank">{$LANG.visitwebsite}</a>
										{if $domainId}
											<a href="clientarea.php?action=domaindetails&id={$domainId}" class="btn btn-default" target="_blank">{$LANG.managedomain}</a>
										{/if}
										<input type="button" onclick="popupWindow('whois.php?domain={$domain}','whois',650,420);return false;" value="{$LANG.whoisinfo}" class="btn btn-default" />
									</div>
								{/if}
								
								{if $moduleclientarea}
									<hr class="separator" />
									
									<div class="text-center module-client-area">
										{$moduleclientarea}
									</div>
									
									<hr class="separator" />
								{/if}
								
							</div>
						{elseif $moduleclientarea}
							<div class="tab-pane fade{if !$domain} in active{/if} text-center" id="manage">
								{if $moduleclientarea}									
									<div class="text-center module-client-area">
										{$moduleclientarea}
									</div>
								{/if}
							</div>
						{/if}
						{if $configurableoptions}
							<div class="tab-pane fade{if !$domain && !$moduleclientarea} in active{/if}" id="configoptions">
								{foreach from=$configurableoptions item=configoption}
								
									<h5 class="heading"><strong>{$configoption.optionname}</strong></h5>
									<div class="well well-sm">
										{if $configoption.optiontype eq 3}{if $configoption.selectedqty}{$LANG.yes}{else}{$LANG.no}{/if}{elseif $configoption.optiontype eq 4}{$configoption.selectedqty} x {$configoption.selectedoption}{else}{$configoption.selectedoption}{/if}
									</div>
									
								{/foreach}
							</div>
						{/if}
						{if $customfields}
							<div class="tab-pane fade{if !$domain && !$moduleclientarea && !$configurableoptions} in active{/if} text-center" id="additionalinfo">
								{foreach from=$customfields item=field}
								
									<h5 class="heading"><strong>{$field.name}</strong></h5>
									<div class="well well-sm">
										{$field.value}
									</div>
									
								{/foreach}
							</div>
						{/if}
						{if $lastupdate}
							<div class="tab-pane fade text-center" id="resourceusage">
								<div class="col-sm-10 col-sm-offset-1">
									<div class="col-sm-6">
										<h5><strong>{$LANG.diskSpace}</strong></h5>
										<input type="text" value="{$diskpercent|substr:0:-1}" class="dial-usage" data-width="100" data-height="100" data-min="0" data-readOnly="true" />
										<p>{$diskusage}MB / {$disklimit}MB</p>
									</div>
									<div class="col-sm-6">
										<h5><strong>{$LANG.bandwidth}</strong></h5>
										<input type="text" value="{$bwpercent|substr:0:-1}" class="dial-usage" data-width="100" data-height="100" data-min="0" data-readOnly="true" />
										<p>{$bwusage}MB / {$bwlimit}MB</p>
									</div>
								</div>
								<div class="clearfix">
								</div>
								<p class="text-muted">{$LANG.clientarealastupdated}: {$lastupdate}</p>

								<script src="{$BASE_PATH_JS}/jquery.knob.js"></script>
								<script type="text/javascript">
								jQuery(function() {ldelim}
									jQuery(".dial-usage").knob({ldelim}'format':function (v) {ldelim} alert(v); {rdelim}{rdelim});
								{rdelim});
								</script>
							</div>
						{/if}
					</div>
				</div>
            {/if}
            <script src="{$BASE_PATH_JS}/bootstrap-tabdrop.js"></script>
            <script type="text/javascript">
                jQuery('.nav-tabs-overflow').tabdrop();
            </script>
		
		
		{else}
		
			<div class="alert alert-warning text-center" role="alert">
				{if $suspendreason}
					<strong>{$suspendreason}</strong><br />
				{/if}
				{$LANG.cPanel.packageNotActive} {$status}.<br />
				{if $systemStatus eq "Pending"}
					{$LANG.cPanel.statusPendingNotice}
				{elseif $systemStatus eq "Suspended"}
					{$LANG.cPanel.statusSuspendedNotice}
				{/if}
			</div>
				
        {/if}
	
	
	{/if}
    </div>
    <div class="tab-pane fade in" id="tabDownloads">
		
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">{$LANG.downloadstitle}</h3>
			</div>
			<div class="panel-body">
				{include file="$template/includes/alert.tpl" type="info" msg="{lang key="clientAreaProductDownloadsAvailable"}" textcenter=true}
						
				<div class="row">
					{foreach from=$downloads item=download}
						<div class="col-xs-10 col-xs-offset-1">
							<h5 class="heading"><strong>{$download.title}</strong></h5>
							<div class="well well-sm">
								<p>
									<a href="{$download.link}" class="btn btn-warning btn-xs"><i class="fa fa-download"></i> {$LANG.downloadname}</a>
								</p>
								<p>{$download.description}</p>
							</div>

						</div>
					{/foreach}
				</div>
			</div>
		</div>
		


    </div>
    <div class="tab-pane fade in" id="tabAddons">
		
        <h3>{$LANG.clientareahostingaddons}</h3>

        {if $addonsavailable}
            {include file="$template/includes/alert.tpl" type="info" msg="{lang key="clientAreaProductAddonsAvailable"}" textcenter=true}
        {/if}

        <div class="row">
            {foreach from=$addons item=addon}
                <div class="col-xs-10 col-xs-offset-1">
                    <div class="panel panel-default panel-accent-blue">
                        <div class="panel-heading">
                            {$addon.name}
                            <div class="pull-right status-{$addon.rawstatus|strtolower}">{$addon.status}</div>
                        </div>
                        <div class="row panel-body">
                            <div class="col-md-6">
                                <p>
                                    {$addon.pricing}
                                </p>
                                <p>
                                    {$LANG.registered}: {$addon.regdate}
                                </p>
                                <p>
                                    {$LANG.clientareahostingnextduedate}: {$addon.nextduedate}
                                </p>
                            </div>
                        </div>
                        <div class="panel-footer">
                            {$addon.managementActions}
                        </div>
                    </div>
                </div>
            {/foreach}
        </div>
		
								


    </div>
    <div class="tab-pane fade in" id="tabChangepw">
	
        {if $modulechangepwresult}
            {if $modulechangepwresult == "success"}
                {include file="$template/includes/alert.tpl" type="success" msg=$modulechangepasswordmessage textcenter=true}
            {elseif $modulechangepwresult == "error"}
                {include file="$template/includes/alert.tpl" type="error" msg=$modulechangepasswordmessage|strip_tags textcenter=true}
            {/if}
        {/if}
		
		<div class="note">{$LANG.serverchangepasswordintro}</div>

		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">{$LANG.serverchangepassword}</h3>
			</div>
			<div class="panel-body">
				<form class=" using-password-strength" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails#tabChangepw" role="form">
					<input type="hidden" name="id" value="{$id}" />
					<input type="hidden" name="modulechangepassword" value="true" />

					<div id="newPassword1" class="form-group has-feedback">
						<label for="inputNewPassword1" class="col-sm-5 control-label">{$LANG.newpassword}</label>
						<input type="password" class="form-control" id="inputNewPassword1" name="newpw" autocomplete="off" />
						<span class="form-control-feedback glyphicon"></span>
						{include file="$template/includes/pwstrength.tpl"}
					</div>
					<div id="newPassword2" class="form-group has-feedback">
						<label for="inputNewPassword2" class="col-sm-5 control-label">{$LANG.confirmnewpassword}</label>
						<input type="password" class="form-control" id="inputNewPassword2" name="confirmpw" autocomplete="off" />
						<span class="form-control-feedback glyphicon"></span>
						<div id="inputNewPassword2Msg">
						</div>
					</div>
					<div class="form-actions">
						<input class="btn btn-primary" type="submit" value="{$LANG.clientareasavechanges}" />
						<input class="btn" type="reset" value="{$LANG.cancel}" />
					</div>
				</form>
			</div>
		</div>
		

    </div>
</div>



<!-- Modal -->
<div class="modal fade" id="LoginCredentials" tabindex="-1" role="dialog" aria-labelledby="LoginCredentials">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i class="fa fa-times"></i></button>
        <h4 class="modal-title" id="LoginCredentials">&nbsp;</h4>
      </div>
      <div class="modal-body">
		<div class="row">
			<div class="{if $password}col-sm-6{else}col-sm-12{/if}">
				{if $username}
					<div class="form-group">
						<label><strong>{$LANG.serverusername}</strong></label>
						<input type="text" class="form-control" placeholder="Text" value="{$username}" />
					</div>
				{/if} 
			</div>
			<div class="{if $username}col-sm-6{else}col-sm-12{/if}">
				{if $password}
					<div class="form-group">
						<label><strong>{$LANG.serverpassword}</strong></label>
						<input type="text" class="form-control" placeholder="Text" value="{$password}" />
					</div>
				{/if}
			</div>
		</div>
      </div>
    </div>
  </div>
</div>