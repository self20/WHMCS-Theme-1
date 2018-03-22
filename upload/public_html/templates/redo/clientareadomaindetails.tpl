{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{if $registrarcustombuttonresult=="success"}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.moduleactionsuccess textcenter=true}
{elseif $registrarcustombuttonresult}
    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.moduleactionfailed textcenter=true}
{/if}

<div class="tab-content margin-bottom">
    <div class="tab-pane fade in active" id="tabOverview">

        {if $systemStatus != 'Active'}
            <div class="alert alert-warning text-center" role="alert">
                {$LANG.domainCannotBeManagedUnlessActive}
            </div>
        {/if}

        <h3>{$LANG.overview}</h3>

        {if $lockstatus eq "unlocked"}
            {capture name="domainUnlockedMsg"}<strong>{$LANG.domaincurrentlyunlocked}</strong><br />{$LANG.domaincurrentlyunlockedexp}{/capture}
            {include file="$template/includes/alert.tpl" type="error" msg=$smarty.capture.domainUnlockedMsg}
        {/if}

        <div class="row">
            <div class="col-sm-6">
			
                <h5 class="heading"><strong>{$LANG.clientareahostingdomain}:</strong></h5>
				<div class="well well-sm">
					<a href="http://{$domain}" target="_blank">{$domain}</a>
				</div>

            
                <h5 class="heading"><strong>{$LANG.clientareahostingregdate}:</strong></h5>
				<div class="well well-sm">
					<span>{$registrationdate}</span>
				</div>
		
            
                <h5 class="heading"><strong>{$LANG.clientareahostingnextduedate}:</strong></h5>
				<div class="well well-sm">
					{$nextduedate}
				</div>
			
					
			</div>
			
			<div class="col-sm-6">
			
                <h5 class="heading"><strong>{$LANG.firstpaymentamount}:</strong></h5>
				<div class="well well-sm">
					<span>{$firstpaymentamount}</span>
				</div>
            
                 <h5 class="heading"><strong>{$LANG.recurringamount}:</strong></h5>
				 <div class="well well-sm">
					{$recurringamount} {$LANG.every} {$registrationperiod} {$LANG.orderyears}
				</div>

                 <h5 class="heading"><strong>{$LANG.orderpaymentmethod}:</strong></h5>
				 <div class="well well-sm">
					{$paymentmethod}
				</div>
				
            </div>
        </div>
		

		<div class="row">
			<div class="col-sm-12">
				<h5 class="heading"><strong>{$LANG.clientareastatus}:</strong></h5>
				<div class="well well-sm">
					{$status}
				</div>
			</div>
		</div>

        {if $registrarclientarea}
            <div class="moduleoutput">
                {$registrarclientarea|replace:'modulebutton':'btn'}
            </div>
        {/if}

        {foreach $hookOutput as $output}
            <div>
                {$output}
            </div>
        {/foreach}

        <br />

        {if $systemStatus == 'Active'
            and (
                $managementoptions.nameservers or
                $managementoptions.contacts or
                $managementoptions.locking or
                $renew)}
                {* No reason to show this section if nothing can be done here! *}

            <h4>{$LANG.doToday}</h4>

            <ul>
                {if $managementoptions.nameservers}
                    <li>
                        <a class="tabControlLink" data-toggle="tab" href="#tabNameservers">
                            {$LANG.changeDomainNS}
                        </a>
                    </li>
                {/if}
                {if $managementoptions.contacts}
                    <li>
                        <a href="clientarea.php?action=domaincontacts&domainid={$domainid}">
                            {$LANG.updateWhoisContact}
                        </a>
                    </li>
                {/if}
                {if $managementoptions.locking}
                    <li>
                        <a class="tabControlLink" data-toggle="tab" href="#tabReglock">
                            {$LANG.changeRegLock}
                        </a>
                    </li>
                {/if}
                {if $renew}
                    <li>
                        <a href="cart.php?gid=renewals">
                            {$LANG.renewYourDomain}
                        </a>
                    </li>
                {/if}
            </ul>

        {/if}

    </div>
    <div class="tab-pane fade" id="tabAutorenew">

        <h3>{$LANG.domainsautorenew}</h3>

        {if $changeAutoRenewStatusSuccessful}
            {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
        {/if}

        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.domainrenewexp}

        <br />
		
		<div class="text-center">
			<h4>{$LANG.domainautorenewstatus}</h4>
			<span class="label label-{if $autorenew}success{else}danger{/if} label-xlg">{if $autorenew}{$LANG.domainsautorenewenabled}{else}{$LANG.domainsautorenewdisabled}{/if}</span>
		</div>

        <br />
        <br />
		<br />
        <br />
		<br />
        <br />

        <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabAutorenew">
            <input type="hidden" name="id" value="{$domainid}">
            <input type="hidden" name="sub" value="autorenew" />
            {if $autorenew}
                <input type="hidden" name="autorenew" value="disable">
                <p class="text-center">
                    <input type="submit" class="btn btn-lg btn-danger" value="{$LANG.domainsautorenewdisable}" />
                </p>
            {else}
                <input type="hidden" name="autorenew" value="enable">
                <p class="text-center">
                    <input type="submit" class="btn btn-lg btn-success" value="{$LANG.domainsautorenewenable}" />
                </p>
            {/if}
        </form>

    </div>
    <div class="tab-pane fade" id="tabNameservers">

        <h3>Nameservers</h3>

        {if $nameservererror}
            {include file="$template/includes/alert.tpl" type="error" msg=$nameservererror textcenter=true}
        {/if}
        {if $subaction eq "savens"}
            {if $updatesuccess}
                {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
            {elseif $error}
                {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
            {/if}
        {/if}

        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.domainnsexp}

        <form role="form" method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabNameservers">
            <input type="hidden" name="id" value="{$domainid}" />
            <input type="hidden" name="sub" value="savens" />
            <div class="radio">
                <label>
                    <input class="tc" type="radio" name="nschoice" value="default" onclick="disableFields('domnsinputs',true)"{if $defaultns} checked{/if} /><span class="labels"> {$LANG.nschoicedefault}</span>
                </label>
            </div>
            <div class="radio">
                <label>
                    <input class="tc" type="radio" name="nschoice" value="custom" onclick="disableFields('domnsinputs',false)"{if !$defaultns} checked{/if} /><span class="labels"> {$LANG.nschoicecustom}</span>
                </label>
            </div>
            <br />
            {for $num=1 to 5}
                <div class="form-group">
                    <label for="inputNs{$num}" class="control-label">{$LANG.clientareanameserver} {$num}</label>
                    <input type="text" name="ns{$num}" class="form-control domnsinputs" id="inputNs{$num}" value="{$nameservers[$num].value}" />
                </div>
            {/for}
           <div class="form-actions">
                <input type="submit" class="btn btn-primary" value="{$LANG.changenameservers}" />
            </div>
        </form>

    </div>
    <div class="tab-pane fade" id="tabReglock">

        <h3>{$LANG.domainregistrarlock}</h3>

        {if $subaction eq "savereglock"}
            {if $updatesuccess}
                {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
            {elseif $error}
                {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
            {/if}
        {/if}

        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.domainlockingexp}

        <br />

        <div class="text-center">
			<h4>{$LANG.domainreglockstatus}</h4>
			<span class="label label-{if $lockstatus == "locked"}success{else}danger{/if}" label-xlg>{if $lockstatus == "locked"}{$LANG.domainsautorenewenabled}{else}{$LANG.domainsautorenewdisabled}{/if}</span>
		</div>
		
        <br />
        <br />
		<br />
        <br />
		<br />
        <br />

        <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabReglock">
            <input type="hidden" name="id" value="{$domainid}">
            <input type="hidden" name="sub" value="savereglock" />
            {if $lockstatus=="locked"}
                <p class="text-center">
                    <input type="submit" class="btn btn-lg btn-danger" value="{$LANG.domainreglockdisable}" />
                </p>
            {else}
                <input type="hidden" name="autorenew" value="enable">
                <p class="text-center">
                    <input type="submit" class="btn btn-lg btn-success" name="reglock" value="{$LANG.domainreglockenable}" />
                </p>
            {/if}
        </form>

    </div>
    <div class="tab-pane fade" id="tabRelease">

        <h3>{$LANG.domainrelease}</h3>

        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.domainreleasedescription}

        <form role="form" method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
            <input type="hidden" name="sub" value="releasedomain">
            <input type="hidden" name="id" value="{$domainid}">

            <div class="form-group">
                <label for="inputReleaseTag" class="control-label">{$LANG.domainreleasetag}</label>
                <input type="text" class="form-control" id="inputReleaseTag" name="transtag" />
            </div>

            <div class="form-actions">
                <input type="submit" value="{$LANG.domainrelease}" class="btn btn-primary" />
            </div>
        </form>

    </div>
    <div class="tab-pane fade" id="tabAddons">

        <h3>{$LANG.domainaddons}</h3>

        <p>
            {$LANG.domainaddonsinfo}
        </p>

        {if $addons.idprotection}
			<div class="padding-all no-padding-left no-padding-right">
				<div class="row">
					<div class="col-xs-3 col-md-2 text-center">
						<i class="fa fa-shield fa-3x"></i>
					</div>
					<div class="col-xs-9 col-md-10">
						<strong>{$LANG.domainidprotection}</strong><br />
						{$LANG.domainaddonsidprotectioninfo}<br />
						<form action="clientarea.php?action=domainaddons" method="post">
							<input type="hidden" name="id" value="{$domainid}"/>
							{if $addonstatus.idprotection}
								<input type="hidden" name="disable" value="idprotect"/>
								<input type="submit" value="{$LANG.disable}" class="btn btn-danger"/>
							{else}
								<input type="hidden" name="buy" value="idprotect"/>
								<input type="submit" value="{$LANG.domainaddonsbuynow} {$addonspricing.idprotection}" class="btn btn-success"/>
							{/if}
						</form>
					</div>
				</div>
			</div>
        {/if}
        {if $addons.dnsmanagement}
			<div class="padding-all no-padding-left no-padding-right">
				<div class="row">
					<div class="col-xs-3 col-md-2 text-center">
						<i class="fa fa-cloud fa-3x"></i>
					</div>
					<div class="col-xs-9 col-md-10">
						<strong>{$LANG.domainaddonsdnsmanagement}</strong><br />
						{$LANG.domainaddonsdnsmanagementinfo}<br />
						<form action="clientarea.php?action=domainaddons" method="post">
							<input type="hidden" name="id" value="{$domainid}"/>
							{if $addonstatus.dnsmanagement}
								<input type="hidden" name="disable" value="dnsmanagement"/>
								<a class="btn btn-success" href="clientarea.php?action=domaindns&domainid={$domainid}">{$LANG.manage}</a> <input type="submit" value="{$LANG.disable}" class="btn btn-danger"/>
							{else}
								<input type="hidden" name="buy" value="dnsmanagement"/>
								<input type="submit" value="{$LANG.domainaddonsbuynow} {$addonspricing.dnsmanagement}" class="btn btn-success"/>
							{/if}
						</form>
					</div>
				</div>
			</div>
        {/if}
        {if $addons.emailforwarding}
			<div class="padding-all no-padding-left no-padding-right">
				<div class="row">
					<div class="col-xs-3 col-md-2 text-center">
						<i class="fa fa-envelope fa-3x">&nbsp;</i><i class="fa fa-mail-forward fa-2x"></i>
					</div>
					<div class="col-xs-9 col-md-10">
						<strong>{$LANG.domainemailforwarding}</strong><br />
						{$LANG.domainaddonsemailforwardinginfo}<br />
						<form action="clientarea.php?action=domainaddons" method="post">
							<input type="hidden" name="id" value="{$domainid}"/>
							{if $addonstatus.emailforwarding}
								<input type="hidden" name="disable" value="emailfwd"/>
								<a class="btn btn-success" href="clientarea.php?action=domainemailforwarding&domainid={$domainid}">{$LANG.manage}</a> <input type="submit" value="{$LANG.disable}" class="btn btn-danger"/>
							{else}
								<input type="hidden" name="buy" value="emailfwd"/>
								<input type="submit" value="{$LANG.domainaddonsbuynow} {$addonspricing.emailforwarding}" class="btn btn-success"/>
							{/if}
						</form>
					</div>
				</div>
			</div>
        {/if}
    </div>
</div>