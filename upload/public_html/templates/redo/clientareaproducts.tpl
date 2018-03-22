{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{include file="$template/includes/tablelist.tpl" tableName="ServicesList" filterColumn="3" noSortColumns="4"}

<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableServicesList').removeClass('hidden').DataTable();
        {if $orderby == 'product'}
            table.order([0, '{$sort}'], [3, 'asc']);
        {elseif $orderby == 'amount' || $orderby == 'billingcycle'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'nextduedate'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'domainstatus'}
            table.order(3, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>

<div class="table-container clearfix">
    <table id="tableServicesList" class="datatable table table-hover table-bordered Redo-table table-primary hidden">
        <thead>
            <tr>
                <th data-class="expand">{$LANG.orderproduct}</th>
                <th data-hide="phone,tablet">{$LANG.clientareaaddonpricing}</th>
                <th data-hide="phone,tablet">{$LANG.clientareahostingnextduedate}</th>
                <th>{$LANG.clientareastatus}</th>
                <th class="col-small center"></th>
            </tr>
        </thead>
        <tbody>
            {foreach key=num item=service from=$services}
                <tr onclick="clickableSafeRedirect(event, 'clientarea.php?action=productdetails&amp;id={$service.id}', false)">
                    <td><a href="clientarea.php?action=productdetails&amp;id={$service.id}"><strong>{$service.product}</strong></a>{if $service.domain}<br /><small><i>{$service.domain}</i></small>{/if}</td>
                    <td data-order="{$service.amountnum}">{$service.amount} <small>{$service.billingcycle}</small></td>
                    <td><span class="hidden">{$service.normalisedNextDueDate}</span>{$service.nextduedate}</td>
                    <td><span class="label status status-{$service.status|strtolower}">{$service.statustext}</span></td>
                    <td class="col-small center">
                        <div class="action-buttons">
							<a href="clientarea.php?action=productdetails&amp;id={$service.id}" data-rel="tooltip" data-placement="left" title="{$LANG.manageproduct}"><i class="fa fa-edit bigger-130"></i></a>	
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
