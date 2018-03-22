{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}

{if $warnings}
    {include file="$template/includes/alert.tpl" type="warning" msg=$warnings textcenter=true}
{/if}

<div class="tab-content">
    <div class="tab-pane fade in active" id="tabOverview">
        {include file="$template/includes/tablelist.tpl" tableName="DomainsList" noSortColumns="0, 6" startOrderCol="1" filterColumn="5"}

        <script type="text/javascript">
            jQuery(document).ready( function ()
            {
                var table = jQuery('#tableDomainsList').removeClass('hidden').DataTable();
                {if $orderby == 'domain'}
                    table.order(1, '{$sort}');
                {elseif $orderby == 'regdate' || $orderby == 'registrationdate'}
                    table.order(2, '{$sort}');
                {elseif $orderby == 'nextduedate'}
                    table.order(3, '{$sort}');
                {elseif $orderby == 'autorenew'}
                    table.order(4, '{$sort}');
                {elseif $orderby == 'status'}
                    table.order(5, '{$sort}');
                {/if}
                table.draw();
                jQuery('#tableLoading').addClass('hidden');
            });
        </script>
		
        <form id="domainForm" method="post" action="clientarea.php?action=bulkdomain">
            <input id="bulkaction" name="update" type="hidden" />

            <div class="table-container clearfix">
                <table id="tableDomainsList" class="datatable table table-hover table-bordered Redo-table table-primary hidden">
                    <thead>
                        <tr>
                            <th class="col-small center"></th>
                            <th data-class="expand">{$LANG.orderdomain}</th>
                            <th data-hide="phone,tablet">{$LANG.regdate}</th>
                            <th data-hide="phone,tablet">{$LANG.nextdue}</th>
                            <th data-hide="phone,tablet">{$LANG.domainsautorenew}</th>
                            <th data-hide="phone">{$LANG.domainstatus}</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach key=num item=domain from=$domains}
                        <tr>
                            <td class="col-small center">
                                <input type="checkbox" class="Redo" name="domids[]" class="domids stopEventBubble" value="{$domain.id}" />
								<span class="labels"></span>
                            </td>
                            <td><a href="clientarea.php?action=domaindetails&id={$domain.id}">{$domain.domain}</a></td>
                            <td><span class="hidden">{$domain.normalisedRegistrationDate}</span>{$domain.registrationdate}</td>
                            <td><span class="hidden">{$domain.normalisedNextDueDate}</span>{$domain.nextduedate}</td>
                            <td>
                                {if $domain.autorenew}
                                    <i class="fa fa-fw fa-check text-success"></i> {$LANG.domainsautorenewenabled}
                                {else}
                                    <i class="fa fa-fw fa-times text-danger"></i> {$LANG.domainsautorenewdisabled}
                                {/if}
                            </td>
                            <td>
                                <span class="label status status-{$domain.statusClass}">{$domain.statustext}</span>
                                <span class="hidden">
                                    {if $domain.next30}<span>{$LANG.domainsExpiringInTheNext30Days}</span><br />{/if}
                                    {if $domain.next90}<span>{$LANG.domainsExpiringInTheNext90Days}</span><br />{/if}
                                    {if $domain.next180}<span>{$LANG.domainsExpiringInTheNext180Days}</span><br />{/if}
                                    {if $domain.after180}<span>{$LANG.domainsExpiringInMoreThan180Days}</span>{/if}
                                </span>
                            </td>
                            <td class="col-small center">
                                <div class="action-buttons">
                                    <a href="clientarea.php?action=domaindetails&id={$domain.id}" data-rel="tooltip" data-placement="left" title="{$LANG.managedomain}"><i class="fa fa-edit bigger-130"></i></a>
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
                <div class="text-center" id="tableLoading">
                    <p><i class="fa fa-spinner fa-spin"></i> {$LANG.loading}</p>
                </div>
            </div>
        </form>

        <div class="btn-group margin-bottom">
            <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
                <span class="glyphicon glyphicon-folder-open"></span> &nbsp; {$LANG.withselected} <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
                <li><a href="#" id="nameservers" class="setBulkAction"><i class="glyphicon glyphicon-globe"></i> {$LANG.domainmanagens}</a></li>
                <li><a href="#" id="autorenew" class="setBulkAction"><i class="glyphicon glyphicon-refresh"></i> {$LANG.domainautorenewstatus}</a></li>
                <li><a href="#" id="reglock" class="setBulkAction"><i class="glyphicon glyphicon-lock"></i> {$LANG.domainreglockstatus}</a></li>
                <li><a href="#" id="contactinfo" class="setBulkAction"><i class="glyphicon glyphicon-user"></i> {$LANG.domaincontactinfoedit}</a></li>
            </ul>
        </div>
    </div>
    <div class="tab-pane fade in" id="tabRenew">
        {include file="$template/includes/tablelist.tpl" tableName="RenewalsList" noSortColumns="3, 4, 5" startOrderCol="0" filterColumn="1" dontControlActiveClass=true}
        <div class="table-container clearfix">
            <table id="tableRenewalsList" class="datatable table table-hover table-bordered tc-table">
                <thead>
                    <tr>
                        <th data-class="expand">{$LANG.orderdomain}</th>
                        <th data-hide="phone">{$LANG.domainstatus}</th>
                        <th data-hide="phone,tablet">{$LANG.clientareadomainexpirydate}</th>
                        <th data-hide="phone,tablet">{$LANG.domaindaysuntilexpiry}</th>
                        <th data-hide="phone">&nbsp;</th>
                        <th>
                            <div id="btnCheckout" style="display:none;">
                                <a href="cart.php?a=view" class="btn btn-default">{$LANG.domainsgotocheckout} &raquo;</a>
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $renewals as $id => $renewal}
                        <tr id="domainRow{$renewal.id}" {if $selectedIDs && in_array($renewal.id, $selectedIDs)}class="highlight"{/if}>
                            <td id="domain{$renewal.id}">{$renewal.domain}</td>
                            <td id="status{$renewal.id}">
                                <span class="label status status-{$renewal.statusClass}">{$renewal.status}</span>
                                <span class="hidden">
                                    {if $renewal.next30}<span>{$LANG.domainsExpiringInTheNext30Days}</span><br />{/if}
                                    {if $renewal.next90}<span>{$LANG.domainsExpiringInTheNext90Days}</span><br />{/if}
                                    {if $renewal.next180}<span>{$LANG.domainsExpiringInTheNext180Days}</span><br />{/if}
                                    {if $renewal.after180}<span>{$LANG.domainsExpiringInMoreThan180Days}</span>{/if}
                                </span>
                            </td>
                            <td id="expiry{$renewal.id}"><span class="hidden">{$renewal.normalisedExpiryDate}</span>{$renewal.expiryDate}</td>
                            <td id="days{$renewal.id}">
                                {if $renewal.daysUntilExpiry > 30}
                                    <span class="text-success">{$renewal.daysUntilExpiry} {$LANG.domainrenewalsdays}</span>
                                {elseif $renewal.daysUntilExpiry > 0}
                                    <span class="text-warning">{$renewal.daysUntilExpiry} {$LANG.domainrenewalsdays}</span>
                                {else}
                                    <span class="text-danger">{$renewal.daysUntilExpiry*-1} {$LANG.domainrenewalsdaysago}</span>
                                {/if}
                                {if $renewal.inGracePeriod}
                                    <br />
                                    <span class="text-danger">{$LANG.domainrenewalsingraceperiod}</span>
                                {/if}
                            </td>
                            <td id="period{$renewal.id}">
                                {if $renewal.beforeRenewLimit}
                                    <span class="text-danger">
                                        {$LANG.domainrenewalsbeforerenewlimit|sprintf2:$renewal.beforeRenewLimitDays}
                                    </span>
                                {elseif $renewal.pastGracePeriod}
                                    <span class="textred">{$LANG.domainrenewalspastgraceperiod}</span>
                                {else}
                                    <select id="renewalPeriod{$renewal.id}" name="renewalPeriod[{$renewal.id}]">
                                        {foreach $renewal.renewalOptions as $renewalOption}
                                            <option value="{$renewalOption.period}">
                                                {$renewalOption.period} {$LANG.orderyears} @ {$renewalOption.price}
                                            </option>
                                        {/foreach}
                                    </select>
                                {/if}
                            </td>
                            <td>
                                {if !$renewal.beforeRenewLimit && !$renewal.pastGracePeriod}
                                    <button type="button" class="btn btn-primary btn-xs" id="renewButton{$renewal.id}" onclick="addRenewalToCart({$renewal.id}, this)">
                                        <span class="glyphicon glyphicon-shopping-cart"></span> {$LANG.addtocart}
                                    </button>
									
								{else}
									<button type="button" class="btn btn-xs btn-primary disabled">
                                        <span class="glyphicon glyphicon-shopping-cart"></span> {$LANG.addtocart}
                                    </button>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>

        <div class="row">
            <div class="col-xs-12" id="backLink">
                <a href="#tabOverview" class="btn btn-default btn-sm" data-toggle="tab" id="back">
                    <i class="glyphicon glyphicon-backward"></i> {$LANG.clientareabacklink|replace:'&laquo; ':''}
                </a>
            </div>
        </div>
    </div>
</div>
